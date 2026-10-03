-- Kimi K3's CREATE TABLE script, copied unchanged from kimi/0b-create-tables-mysql-response.md

CREATE DATABASE IF NOT EXISTS dental_practice;
USE dental_practice;

-- ============================================================
-- PEOPLE
-- ============================================================

CREATE TABLE STAFF (
    StaffID       INT AUTO_INCREMENT,
    Name          VARCHAR(100) NOT NULL,
    Phone         VARCHAR(20),
    Email         VARCHAR(100),
    Address       VARCHAR(255),
    HireDate      DATE,
    MonthlySalary DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (StaffID)
);

CREATE TABLE PROVIDER (
    StaffID   INT,
    Specialty ENUM('hygienist','dentist','periodontist','endodontist',
                   'orthodontist','dental surgeon') NOT NULL,
    PRIMARY KEY (StaffID),
    CONSTRAINT fk_provider_staff FOREIGN KEY (StaffID)
        REFERENCES STAFF (StaffID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE FRONT_OFFICE_STAFF (
    StaffID INT,
    Role    VARCHAR(50),
    PRIMARY KEY (StaffID),
    CONSTRAINT fk_fos_staff FOREIGN KEY (StaffID)
        REFERENCES STAFF (StaffID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LICENSE (
    LicenseNo  VARCHAR(20),
    StaffID    INT NOT NULL,
    Type       VARCHAR(50),
    IssueDate  DATE,
    ExpiryDate DATE,
    Status     ENUM('active','expired','suspended') NOT NULL DEFAULT 'active',
    PRIMARY KEY (LicenseNo),
    CONSTRAINT fk_license_provider FOREIGN KEY (StaffID)
        REFERENCES PROVIDER (StaffID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE PATIENT (
    PatientID  INT AUTO_INCREMENT,
    Name       VARCHAR(100) NOT NULL,
    DOB        DATE,
    Phone      VARCHAR(20),
    Email      VARCHAR(100),
    Address    VARCHAR(255),
    SchedState ENUM('contacted','scheduled','recently visited',
                    'up for next visit','dormant') NOT NULL DEFAULT 'contacted',
    PRIMARY KEY (PatientID)
);

-- ============================================================
-- INSURANCE
-- ============================================================

CREATE TABLE INSURANCE_PROVIDER (
    ProviderID    INT AUTO_INCREMENT,
    Name          VARCHAR(100) NOT NULL,
    Phone         VARCHAR(20),
    Address       VARCHAR(255),
    ContactPerson VARCHAR(100),
    PRIMARY KEY (ProviderID)
);

CREATE TABLE POLICY (
    SubscriberID   VARCHAR(50),
    PatientID      INT NOT NULL,
    ProviderID     INT NOT NULL,
    CoverageType   VARCHAR(50),
    CoverageAmount DECIMAL(10,2),
    PRIMARY KEY (SubscriberID),
    CONSTRAINT uq_policy_patient UNIQUE (PatientID),   -- a patient holds at most one policy
    CONSTRAINT fk_policy_patient FOREIGN KEY (PatientID)
        REFERENCES PATIENT (PatientID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_policy_provider FOREIGN KEY (ProviderID)
        REFERENCES INSURANCE_PROVIDER (ProviderID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- CLINICAL OPERATIONS
-- ============================================================

CREATE TABLE ROOM (
    RoomNo      INT,
    Description VARCHAR(100),
    PRIMARY KEY (RoomNo)
);

CREATE TABLE BILL (
    BillID     INT AUTO_INCREMENT,
    PatientID  INT NOT NULL,
    BillDate   DATE NOT NULL,
    AmountOwed DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (BillID),
    CONSTRAINT fk_bill_patient FOREIGN KEY (PatientID)
        REFERENCES PATIENT (PatientID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE APPOINTMENT (
    ApptID     INT AUTO_INCREMENT,
    PatientID  INT NOT NULL,
    ProviderID INT NOT NULL,   -- the doctor/hygienist serving the patient
    RoomNo     INT NOT NULL,
    StaffID    INT NOT NULL,   -- the front-office worker who arranged it
    Date       DATE NOT NULL,
    StartTime  TIME NOT NULL,
    EndTime    TIME,
    Status     ENUM('scheduled','completed','cancelled','no-show')
               NOT NULL DEFAULT 'scheduled',
    PRIMARY KEY (ApptID),
    CONSTRAINT uq_appt_room_slot     UNIQUE (RoomNo, Date, StartTime),
    CONSTRAINT uq_appt_provider_slot UNIQUE (ProviderID, Date, StartTime),
    CONSTRAINT fk_appt_patient FOREIGN KEY (PatientID)
        REFERENCES PATIENT (PatientID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_appt_provider FOREIGN KEY (ProviderID)
        REFERENCES PROVIDER (StaffID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_appt_room FOREIGN KEY (RoomNo)
        REFERENCES ROOM (RoomNo)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_appt_scheduler FOREIGN KEY (StaffID)
        REFERENCES FRONT_OFFICE_STAFF (StaffID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE SERVICE (
    ServiceID   INT AUTO_INCREMENT,
    ApptID      INT NOT NULL,
    BillID      INT NOT NULL,
    Code        VARCHAR(20) NOT NULL,   -- CDT-style treatment code
    Description VARCHAR(255),
    ServiceDate DATE NOT NULL,
    Fee         DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ServiceID),
    CONSTRAINT fk_service_appt FOREIGN KEY (ApptID)
        REFERENCES APPOINTMENT (ApptID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_service_bill FOREIGN KEY (BillID)
        REFERENCES BILL (BillID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- PROCEDURE is a MySQL reserved word, so it must stay backticked
CREATE TABLE `PROCEDURE` (
    ServiceID INT,
    PRIMARY KEY (ServiceID),
    CONSTRAINT fk_procedure_service FOREIGN KEY (ServiceID)
        REFERENCES SERVICE (ServiceID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE TREATMENT (
    ServiceID INT,
    Diagnosis VARCHAR(255),
    PRIMARY KEY (ServiceID),
    CONSTRAINT fk_treatment_service FOREIGN KEY (ServiceID)
        REFERENCES SERVICE (ServiceID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SURGERY (
    ServiceID      INT,
    AnesthesiaType VARCHAR(50),
    PRIMARY KEY (ServiceID),
    CONSTRAINT fk_surgery_service FOREIGN KEY (ServiceID)
        REFERENCES SERVICE (ServiceID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- BILLING & CLAIMS
-- ============================================================

CREATE TABLE PAYMENT (
    PaymentID INT AUTO_INCREMENT,
    BillID    INT NOT NULL,
    PayDate   DATE NOT NULL,
    Amount    DECIMAL(10,2) NOT NULL,
    Source    ENUM('patient','insurance') NOT NULL,
    Method    ENUM('cash','card','check','bank transfer'),
    PRIMARY KEY (PaymentID),
    CONSTRAINT fk_payment_bill FOREIGN KEY (BillID)
        REFERENCES BILL (BillID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE INSURANCE_CLAIM (
    ClaimID       INT AUTO_INCREMENT,
    ServiceID     INT NOT NULL,
    ProviderID    INT NOT NULL,
    SubscriberID  VARCHAR(50) NOT NULL,
    TreatmentCode VARCHAR(20) NOT NULL,
    TreatmentDate DATE NOT NULL,
    AmountClaimed DECIMAL(10,2) NOT NULL,
    AmountPaid    DECIMAL(10,2),
    ClaimDate     DATE NOT NULL,
    Status        ENUM('submitted','approved','denied','paid')
                  NOT NULL DEFAULT 'submitted',
    PRIMARY KEY (ClaimID),
    CONSTRAINT uq_claim_service UNIQUE (ServiceID),   -- at most one claim per service
    CONSTRAINT fk_claim_service FOREIGN KEY (ServiceID)
        REFERENCES SERVICE (ServiceID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_claim_provider FOREIGN KEY (ProviderID)
        REFERENCES INSURANCE_PROVIDER (ProviderID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_claim_policy FOREIGN KEY (SubscriberID)
        REFERENCES POLICY (SubscriberID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ============================================================
-- BUSINESS FINANCE
-- ============================================================

CREATE TABLE PAYROLL (
    PayID    INT AUTO_INCREMENT,
    StaffID  INT NOT NULL,
    PayMonth CHAR(7) NOT NULL,   -- format 'YYYY-MM'
    Amount   DECIMAL(10,2) NOT NULL,
    PayDate  DATE,
    PRIMARY KEY (PayID),
    CONSTRAINT fk_payroll_staff FOREIGN KEY (StaffID)
        REFERENCES STAFF (StaffID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE LOAN (
    LoanID       INT AUTO_INCREMENT,
    BankName     VARCHAR(100) NOT NULL,
    Principal    DECIMAL(12,2) NOT NULL,
    InterestRate DECIMAL(5,4) NOT NULL,
    TermYears    INT NOT NULL,
    StartDate    DATE NOT NULL,
    PRIMARY KEY (LoanID)
);

-- weak entity: identified by (LoanID, InstallmentNo)
CREATE TABLE LOAN_INSTALLMENT (
    LoanID        INT,
    InstallmentNo INT,
    DueDate       DATE NOT NULL,
    AmountDue     DECIMAL(10,2) NOT NULL,
    AmountPaid    DECIMAL(10,2),
    PaidDate      DATE,
    Status        ENUM('pending','paid','late') NOT NULL DEFAULT 'pending',
    PRIMARY KEY (LoanID, InstallmentNo),
    CONSTRAINT fk_installment_loan FOREIGN KEY (LoanID)
        REFERENCES LOAN (LoanID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE LEASE (
    LeaseID         INT AUTO_INCREMENT,
    Landlord        VARCHAR(100),
    PropertyAddress VARCHAR(255),
    MonthlyRent     DECIMAL(10,2) NOT NULL,
    StartDate       DATE NOT NULL,
    EndDate         DATE,
    PRIMARY KEY (LeaseID)
);

-- weak entity: identified by (LeaseID, PaymentNo)
CREATE TABLE LEASE_PAYMENT (
    LeaseID   INT,
    PaymentNo INT,
    DueDate   DATE NOT NULL,
    Amount    DECIMAL(10,2) NOT NULL,
    PaidDate  DATE,
    PRIMARY KEY (LeaseID, PaymentNo),
    CONSTRAINT fk_leasepay_lease FOREIGN KEY (LeaseID)
        REFERENCES LEASE (LeaseID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SUPPLY_ITEM (
    ItemID       INT AUTO_INCREMENT,
    Name         VARCHAR(100) NOT NULL,
    Category     VARCHAR(50),
    UnitCost     DECIMAL(10,2),
    QtyOnHand    INT NOT NULL DEFAULT 0,
    ReorderLevel INT,
    PRIMARY KEY (ItemID)
);

CREATE TABLE RESTOCK_ORDER (
    OrderID   INT AUTO_INCREMENT,
    OrderDate DATE NOT NULL,
    TotalCost DECIMAL(10,2),
    PRIMARY KEY (OrderID)
);

-- resolves the M:N "restocked in" relationship (carries its Qty/UnitPrice attributes)
CREATE TABLE RESTOCK_LINE (
    OrderID   INT,
    ItemID    INT,
    Qty       INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (OrderID, ItemID),
    CONSTRAINT fk_line_order FOREIGN KEY (OrderID)
        REFERENCES RESTOCK_ORDER (OrderID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_line_item FOREIGN KEY (ItemID)
        REFERENCES SUPPLY_ITEM (ItemID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE OPERATING_EXPENSE (
    ExpenseID   INT AUTO_INCREMENT,
    Category    VARCHAR(50) NOT NULL,   -- cleaning, utilities, food, ...
    Description VARCHAR(255),
    Amount      DECIMAL(10,2) NOT NULL,
    ExpenseDate DATE NOT NULL,
    PRIMARY KEY (ExpenseID)
);

CREATE TABLE STARTUP_EXPENSE (
    StartupCostID INT AUTO_INCREMENT,
    Category      ENUM('furniture','equipment','software','supplies','training') NOT NULL,
    Description   VARCHAR(255),
    Amount        DECIMAL(10,2) NOT NULL,
    PurchaseDate  DATE,
    PRIMARY KEY (StartupCostID)
);
