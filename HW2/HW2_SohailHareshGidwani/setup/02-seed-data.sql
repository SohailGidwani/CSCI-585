-- Fake data for Kimi's dental_practice schema (run 01-schema.sql first).
-- Explicit IDs everywhere, inserted parent tables first so the foreign keys are satisfied.
-- Upcoming appointments use DATE_ADD(CURDATE(), ...) so the 'next 3 months' question
-- has the same answer whatever day this is loaded.

USE dental_practice;

INSERT INTO STAFF (StaffID, Name, Phone, Email, Address, HireDate, MonthlySalary) VALUES
  (1, 'Dr. Maya Patel', '(213) 555-0111', 'maya.patel@dentalpractice.example', '418 S Grand Ave, Los Angeles, CA 90071', '2024-11-01', 15000),
  (2, 'Dr. James Okafor', '(213) 555-0112', 'james.okafor@dentalpractice.example', '1250 W 7th St, Los Angeles, CA 90017', '2024-11-01', 17000),
  (3, 'Dr. Elena Ruiz', '(213) 555-0113', 'elena.ruiz@dentalpractice.example', '930 Hill St, Los Angeles, CA 90015', '2024-11-15', 17500),
  (4, 'Dr. Kevin Cho', '(213) 555-0114', 'kevin.cho@dentalpractice.example', '77 Alvarado St, Los Angeles, CA 90057', '2024-12-01', 18000),
  (5, 'Dr. Sarah Lindqvist', '(213) 555-0115', 'sarah.lindqvist@dentalpractice.example', '2100 Sunset Blvd, Los Angeles, CA 90026', '2024-11-01', 20000),
  (6, 'Priya Nair', '(213) 555-0116', 'priya.nair@dentalpractice.example', '615 N Broadway, Los Angeles, CA 90012', '2024-12-01', 8500),
  (7, 'Marcus Bell', '(213) 555-0117', 'marcus.bell@dentalpractice.example', '3400 Vermont Ave, Los Angeles, CA 90007', '2024-12-01', 8200),
  (8, 'Linda Gomez', '(213) 555-0118', 'linda.gomez@dentalpractice.example', '1820 Figueroa St, Los Angeles, CA 90007', '2024-10-15', 5500),
  (9, 'Tom Becker', '(213) 555-0119', 'tom.becker@dentalpractice.example', '2600 Hoover St, Los Angeles, CA 90007', '2024-12-01', 4200),
  (10, 'Aisha Rahman', '(213) 555-0120', 'aisha.rahman@dentalpractice.example', '845 W 23rd St, Los Angeles, CA 90007', '2024-12-01', 4800);

INSERT INTO PROVIDER (StaffID, Specialty) VALUES
  (1, 'dentist'),
  (2, 'periodontist'),
  (3, 'endodontist'),
  (4, 'orthodontist'),
  (5, 'dental surgeon'),
  (6, 'hygienist'),
  (7, 'hygienist');

INSERT INTO FRONT_OFFICE_STAFF (StaffID, Role) VALUES
  (8, 'Office Manager'),
  (9, 'Receptionist / Scheduler'),
  (10, 'Billing Coordinator');

INSERT INTO LICENSE (LicenseNo, StaffID, Type, IssueDate, ExpiryDate, Status) VALUES
  ('DDS-58231', 1, 'DDS', '2025-03-31', '2027-03-31', 'active'),
  ('DDS-60417', 2, 'DDS', '2024-12-31', '2026-12-31', 'active'),
  ('DDS-61102', 3, 'DDS', '2025-08-31', '2027-08-31', 'active'),
  ('DDS-57789', 4, 'DDS', '2026-06-30', '2028-06-30', 'active'),
  ('DDS-59950', 5, 'DDS', '2025-10-31', '2027-10-31', 'active'),
  ('GA-1184', 5, 'General Anesthesia Permit', '2025-05-31', '2027-05-31', 'active'),
  ('RDH-104522', 6, 'RDH', '2026-02-28', '2028-02-29', 'active'),
  ('RDH-088100', 7, 'RDH', '2023-01-31', '2025-01-31', 'expired'),
  ('RDH-099318', 7, 'RDH', '2025-01-31', '2027-01-31', 'active');

INSERT INTO PATIENT (PatientID, Name, DOB, Phone, Email, Address, SchedState) VALUES
  (1, 'John Carter', '1985-04-12', '(323) 555-0141', 'john.carter@mail.example', '1123 W 36th St, Los Angeles, CA 90007', 'up for next visit'),
  (2, 'Emily Nguyen', '1992-09-03', '(323) 555-0142', 'emily.nguyen@mail.example', '2741 Ellendale Pl, Los Angeles, CA 90007', 'scheduled'),
  (3, 'Robert Kim', '1978-01-27', '(323) 555-0143', 'robert.kim@mail.example', '650 S Normandie Ave, Los Angeles, CA 90005', 'scheduled'),
  (4, 'Sofia Martinez', '2001-06-18', '(323) 555-0144', 'sofia.martinez@mail.example', '1458 Menlo Ave, Los Angeles, CA 90006', 'scheduled'),
  (5, 'Daniel Brooks', '1969-11-30', '(323) 555-0145', 'daniel.brooks@mail.example', '3020 Orchard Ave, Los Angeles, CA 90007', 'contacted'),
  (6, 'Hannah Lee', '1996-02-14', '(323) 555-0146', 'hannah.lee@mail.example', '505 S Westmoreland Ave, Los Angeles, CA 90020', 'scheduled'),
  (7, 'Michael Turner', '1958-08-08', '(323) 555-0147', 'michael.turner@mail.example', '4100 S Main St, Los Angeles, CA 90037', 'dormant'),
  (8, 'Olivia Chen', '1988-12-22', '(323) 555-0148', 'olivia.chen@mail.example', '900 Wilshire Blvd, Los Angeles, CA 90017', 'contacted'),
  (9, 'Ethan Walker', '1975-05-05', '(323) 555-0149', 'ethan.walker@mail.example', '1720 Magnolia Ave, Los Angeles, CA 90006', 'up for next visit'),
  (10, 'Grace Adams', '1999-03-09', '(323) 555-0150', 'grace.adams@mail.example', '2255 Portland St, Los Angeles, CA 90007', 'recently visited'),
  (11, 'Lucas Rivera', '2004-07-21', '(323) 555-0151', 'lucas.rivera@mail.example', '3335 S Flower St, Los Angeles, CA 90007', 'scheduled'),
  (12, 'Mia Thompson', '2010-10-01', '(323) 555-0152', 'mia.thompson@mail.example', '1301 W 29th St, Los Angeles, CA 90007', 'scheduled');

INSERT INTO INSURANCE_PROVIDER (ProviderID, Name, Phone, Address, ContactPerson) VALUES
  (1, 'Delta Dental', '(800) 555-0101', 'PO Box 1001, Sacramento, CA 95899', 'Karen Holt'),
  (2, 'MetLife Dental', '(800) 555-0102', 'PO Box 1002, Utica, NY 13504', 'Brian Molina'),
  (3, 'Cigna Dental', '(800) 555-0103', 'PO Box 1003, Chattanooga, TN 37422', 'Denise Park'),
  (4, 'Aetna Dental', '(800) 555-0104', 'PO Box 1004, Lexington, KY 40512', 'Victor Shaw'),
  (5, 'Guardian Dental', '(800) 555-0105', 'PO Box 1005, Appleton, WI 54912', 'Renee Fox'),
  (6, 'Humana Dental', '(800) 555-0106', 'PO Box 1006, Louisville, KY 40201', 'Omar Haddad');

-- patients 11 and 12 have no insurance, Aetna and Humana have no patients
INSERT INTO POLICY (SubscriberID, PatientID, ProviderID, CoverageType, CoverageAmount) VALUES
  ('DDC-4471023', 1, 1, 'PPO', 2000),
  ('DDC-4471188', 2, 1, 'PPO', 2000),
  ('DDC-5520391', 3, 1, 'savings plan', 1000),
  ('MET-88231907', 4, 2, 'PPO', 1500),
  ('MET-88239044', 5, 2, 'savings plan', 1000),
  ('CIG-U7720415', 6, 3, 'HMO', 1500),
  ('GRD-3009186', 7, 5, 'PPO', 1500),
  ('GRD-3009550', 8, 5, 'HMO', 1000),
  ('DDC-6610457', 9, 1, 'PPO', 1500),
  ('CIG-U7721980', 10, 3, 'PPO', 2000);

INSERT INTO ROOM (RoomNo, Description) VALUES
  (1, 'Hygiene room 1'),
  (2, 'Hygiene room 2'),
  (3, 'General / periodontics operatory'),
  (4, 'Endodontics operatory'),
  (5, 'Orthodontics bay'),
  (6, 'General operatory'),
  (7, 'Imaging and X-ray room'),
  (8, 'Surgical suite');

INSERT INTO BILL (BillID, PatientID, BillDate, AmountOwed) VALUES
  (1, 1, '2025-01-15', 180.00),
  (2, 2, '2025-02-20', 275.00),
  (3, 3, '2025-04-08', 250.00),
  (4, 4, '2025-06-12', 220.00),
  (5, 5, '2025-08-05', 195.00),
  (6, 6, '2025-10-21', 450.00),
  (7, 7, '2025-12-30', 120.00),
  (8, 8, '2026-01-06', 120.00),
  (9, 9, '2026-03-17', 1100.00),
  (10, 1, '2026-06-09', 120.00),
  (11, 10, '2026-08-25', 380.00);

INSERT INTO APPOINTMENT (ApptID, PatientID, ProviderID, RoomNo, StaffID, Date, StartTime, EndTime, Status) VALUES
  (1, 1, 6, 1, 9, '2025-01-15', '09:00:00', '10:00:00', 'completed'),
  (2, 2, 1, 3, 9, '2025-02-20', '10:00:00', '11:00:00', 'completed'),
  (3, 3, 2, 3, 8, '2025-04-08', '13:00:00', '14:30:00', 'completed'),
  (4, 4, 5, 8, 9, '2025-06-12', '09:30:00', '10:30:00', 'completed'),
  (5, 5, 7, 2, 9, '2025-08-05', '11:00:00', '12:00:00', 'completed'),
  (6, 6, 5, 8, 8, '2025-10-21', '14:00:00', '15:30:00', 'completed'),
  (7, 7, 6, 1, 9, '2025-12-30', '15:00:00', '16:00:00', 'completed'),
  (8, 8, 6, 1, 9, '2026-01-06', '09:00:00', '10:00:00', 'completed'),
  (9, 9, 3, 4, 8, '2026-03-17', '10:30:00', '12:00:00', 'completed'),
  (10, 1, 7, 2, 9, '2026-06-09', '13:30:00', '14:30:00', 'completed'),
  (11, 10, 5, 8, 9, '2026-08-25', '11:00:00', '12:00:00', 'completed'),
  (12, 2, 6, 1, 9, DATE_ADD(CURDATE(), INTERVAL 6 DAY), '09:00:00', '10:00:00', 'scheduled'),
  (13, 3, 2, 3, 9, DATE_ADD(CURDATE(), INTERVAL 13 DAY), '10:00:00', '11:30:00', 'scheduled'),
  (14, 11, 1, 6, 8, DATE_ADD(CURDATE(), INTERVAL 27 DAY), '14:00:00', '15:00:00', 'scheduled'),
  (15, 2, 1, 6, 9, DATE_ADD(CURDATE(), INTERVAL 41 DAY), '09:30:00', '10:30:00', 'scheduled'),
  (16, 12, 4, 5, 9, DATE_ADD(CURDATE(), INTERVAL 55 DAY), '11:00:00', '11:45:00', 'scheduled'),
  (17, 4, 7, 2, 8, DATE_ADD(CURDATE(), INTERVAL 76 DAY), '13:00:00', '14:00:00', 'scheduled'),
  (18, 5, 1, 6, 9, DATE_ADD(CURDATE(), INTERVAL 20 DAY), '15:00:00', '16:00:00', 'cancelled'),
  (19, 6, 6, 1, 9, DATE_ADD(CURDATE(), INTERVAL 120 DAY), '10:00:00', '11:00:00', 'scheduled');

INSERT INTO SERVICE (ServiceID, ApptID, BillID, Code, Description, ServiceDate, Fee) VALUES
  (1, 1, 1, 'D1110', 'Prophylaxis (teeth cleaning), adult', '2025-01-15', 120),
  (2, 1, 1, 'D0120', 'Periodic oral evaluation', '2025-01-15', 60),
  (3, 2, 2, 'D0150', 'Comprehensive oral evaluation', '2025-02-20', 95),
  (4, 2, 2, 'D2391', 'Resin composite filling, one surface, posterior', '2025-02-20', 180),
  (5, 3, 3, 'D4341', 'Periodontal scaling and root planing, per quadrant', '2025-04-08', 250),
  (6, 4, 4, 'D7140', 'Extraction, erupted tooth', '2025-06-12', 220),
  (7, 5, 5, 'D1110', 'Prophylaxis (teeth cleaning), adult', '2025-08-05', 120),
  (8, 5, 5, 'D0274', 'Bitewing X-rays, four images', '2025-08-05', 75),
  (9, 6, 6, 'D7240', 'Removal of impacted tooth, completely bony', '2025-10-21', 450),
  (10, 7, 7, 'D1110', 'Prophylaxis (teeth cleaning), adult', '2025-12-30', 120),
  (11, 8, 8, 'D1110', 'Prophylaxis (teeth cleaning), adult', '2026-01-06', 120),
  (12, 9, 9, 'D3330', 'Root canal therapy, molar', '2026-03-17', 1100),
  (13, 10, 10, 'D1110', 'Prophylaxis (teeth cleaning), adult', '2026-06-09', 120),
  (14, 11, 11, 'D7210', 'Surgical extraction of erupted tooth', '2026-08-25', 380);

INSERT INTO `PROCEDURE` (ServiceID) VALUES
  (1),
  (2),
  (3),
  (7),
  (8),
  (10),
  (11),
  (13);

INSERT INTO TREATMENT (ServiceID, Diagnosis) VALUES
  (4, 'Dental caries, lower left first molar'),
  (5, 'Chronic periodontitis (gum disease)'),
  (12, 'Irreversible pulpitis, upper right first molar');

INSERT INTO SURGERY (ServiceID, AnesthesiaType) VALUES
  (6, 'Local anesthesia'),
  (9, 'IV sedation'),
  (14, 'Local anesthesia');

INSERT INTO PAYMENT (PaymentID, BillID, PayDate, Amount, Source, Method) VALUES
  (1, 1, '2025-02-06', 144.00, 'insurance', 'bank transfer'),
  (2, 1, '2025-01-15', 36.00, 'patient', 'cash'),
  (3, 2, '2025-03-14', 220.00, 'insurance', 'bank transfer'),
  (4, 2, '2025-02-20', 55.00, 'patient', 'check'),
  (5, 3, '2025-04-30', 200.00, 'insurance', 'bank transfer'),
  (6, 3, '2025-04-08', 50.00, 'patient', 'card'),
  (7, 4, '2025-07-04', 176.00, 'insurance', 'bank transfer'),
  (8, 4, '2025-06-12', 44.00, 'patient', 'cash'),
  (9, 5, '2025-08-27', 96.00, 'insurance', 'bank transfer'),
  (10, 5, '2025-08-05', 99.00, 'patient', 'check'),
  (11, 6, '2025-11-12', 360.00, 'insurance', 'bank transfer'),
  (12, 6, '2025-10-21', 90.00, 'patient', 'card'),
  (13, 7, '2026-01-21', 96.00, 'insurance', 'bank transfer'),
  (14, 7, '2025-12-30', 24.00, 'patient', 'cash'),
  (15, 8, '2026-01-28', 96.00, 'insurance', 'bank transfer'),
  (16, 8, '2026-01-06', 24.00, 'patient', 'check'),
  (17, 9, '2026-04-08', 880.00, 'insurance', 'bank transfer'),
  (18, 9, '2026-03-17', 220.00, 'patient', 'card'),
  (19, 10, '2026-07-01', 96.00, 'insurance', 'bank transfer'),
  (20, 10, '2026-06-09', 24.00, 'patient', 'cash'),
  (21, 11, '2026-08-25', 76.00, 'patient', 'check');

INSERT INTO INSURANCE_CLAIM (ClaimID, ServiceID, ProviderID, SubscriberID, TreatmentCode, TreatmentDate, AmountClaimed, AmountPaid, ClaimDate, Status) VALUES
  (1, 1, 1, 'DDC-4471023', 'D1110', '2025-01-15', 120.00, 96.00, '2025-01-16', 'paid'),
  (2, 2, 1, 'DDC-4471023', 'D0120', '2025-01-15', 60.00, 48.00, '2025-01-16', 'paid'),
  (3, 3, 1, 'DDC-4471188', 'D0150', '2025-02-20', 95.00, 76.00, '2025-02-21', 'paid'),
  (4, 4, 1, 'DDC-4471188', 'D2391', '2025-02-20', 180.00, 144.00, '2025-02-21', 'paid'),
  (5, 5, 1, 'DDC-5520391', 'D4341', '2025-04-08', 250.00, 200.00, '2025-04-09', 'paid'),
  (6, 6, 2, 'MET-88231907', 'D7140', '2025-06-12', 220.00, 176.00, '2025-06-13', 'paid'),
  (7, 7, 2, 'MET-88239044', 'D1110', '2025-08-05', 120.00, 96.00, '2025-08-06', 'paid'),
  (8, 8, 2, 'MET-88239044', 'D0274', '2025-08-05', 75.00, 0.00, '2025-08-06', 'denied'),
  (9, 9, 3, 'CIG-U7720415', 'D7240', '2025-10-21', 450.00, 360.00, '2025-10-22', 'paid'),
  (10, 10, 5, 'GRD-3009186', 'D1110', '2025-12-30', 120.00, 96.00, '2025-12-31', 'paid'),
  (11, 11, 5, 'GRD-3009550', 'D1110', '2026-01-06', 120.00, 96.00, '2026-01-07', 'paid'),
  (12, 12, 1, 'DDC-6610457', 'D3330', '2026-03-17', 1100.00, 880.00, '2026-03-18', 'paid'),
  (13, 13, 1, 'DDC-4471023', 'D1110', '2026-06-09', 120.00, 96.00, '2026-06-10', 'paid'),
  (14, 14, 3, 'CIG-U7721980', 'D7210', '2026-08-25', 380.00, NULL, '2026-08-26', 'submitted');

INSERT INTO PAYROLL (PayID, StaffID, PayMonth, Amount, PayDate) VALUES
  (1, 1, '2026-09', 15000, '2026-09-30'),
  (2, 2, '2026-09', 17000, '2026-09-30'),
  (3, 3, '2026-09', 17500, '2026-09-30'),
  (4, 4, '2026-09', 18000, '2026-09-30'),
  (5, 5, '2026-09', 20000, '2026-09-30'),
  (6, 6, '2026-09', 8500, '2026-09-30'),
  (7, 7, '2026-09', 8200, '2026-09-30'),
  (8, 8, '2026-09', 5500, '2026-09-30'),
  (9, 9, '2026-09', 4200, '2026-09-30'),
  (10, 10, '2026-09', 4800, '2026-09-30');

INSERT INTO LOAN (LoanID, BankName, Principal, InterestRate, TermYears, StartDate) VALUES
  (1, 'Pacific Coast Community Bank', 300000, 0.0600, 10, '2024-12-01');

-- $300,000 at 6% over 120 months = 3330.62/month, first 22 paid
INSERT INTO LOAN_INSTALLMENT (LoanID, InstallmentNo, DueDate, AmountDue, AmountPaid, PaidDate, Status) VALUES
  (1, 1, '2025-01-01', 3330.62, 3330.62, '2024-12-30', 'paid'),
  (1, 2, '2025-02-01', 3330.62, 3330.62, '2025-01-30', 'paid'),
  (1, 3, '2025-03-01', 3330.62, 3330.62, '2025-02-27', 'paid'),
  (1, 4, '2025-04-01', 3330.62, 3330.62, '2025-03-30', 'paid'),
  (1, 5, '2025-05-01', 3330.62, 3330.62, '2025-04-29', 'paid'),
  (1, 6, '2025-06-01', 3330.62, 3330.62, '2025-05-30', 'paid'),
  (1, 7, '2025-07-01', 3330.62, 3330.62, '2025-06-29', 'paid'),
  (1, 8, '2025-08-01', 3330.62, 3330.62, '2025-07-30', 'paid'),
  (1, 9, '2025-09-01', 3330.62, 3330.62, '2025-08-30', 'paid'),
  (1, 10, '2025-10-01', 3330.62, 3330.62, '2025-09-29', 'paid'),
  (1, 11, '2025-11-01', 3330.62, 3330.62, '2025-10-30', 'paid'),
  (1, 12, '2025-12-01', 3330.62, 3330.62, '2025-11-29', 'paid'),
  (1, 13, '2026-01-01', 3330.62, 3330.62, '2025-12-30', 'paid'),
  (1, 14, '2026-02-01', 3330.62, 3330.62, '2026-02-09', 'paid'),
  (1, 15, '2026-03-01', 3330.62, 3330.62, '2026-02-27', 'paid'),
  (1, 16, '2026-04-01', 3330.62, 3330.62, '2026-03-30', 'paid'),
  (1, 17, '2026-05-01', 3330.62, 3330.62, '2026-04-29', 'paid'),
  (1, 18, '2026-06-01', 3330.62, 3330.62, '2026-05-30', 'paid'),
  (1, 19, '2026-07-01', 3330.62, 3330.62, '2026-06-29', 'paid'),
  (1, 20, '2026-08-01', 3330.62, 3330.62, '2026-07-30', 'paid'),
  (1, 21, '2026-09-01', 3330.62, 3330.62, '2026-08-30', 'paid'),
  (1, 22, '2026-10-01', 3330.62, 3330.62, '2026-09-29', 'paid'),
  (1, 23, '2026-11-01', 3330.62, NULL, NULL, 'pending'),
  (1, 24, '2026-12-01', 3330.62, NULL, NULL, 'pending');

INSERT INTO LEASE (LeaseID, Landlord, PropertyAddress, MonthlyRent, StartDate, EndDate) VALUES
  (1, 'Harborview Medical Properties LLC', '2200 Medical Center Dr, Suite 310, Los Angeles, CA 90033', 12500, '2025-01-01', '2029-12-31');

INSERT INTO LEASE_PAYMENT (LeaseID, PaymentNo, DueDate, Amount, PaidDate) VALUES
  (1, 1, '2025-01-01', 12500, '2024-12-29'),
  (1, 2, '2025-02-01', 12500, '2025-01-29'),
  (1, 3, '2025-03-01', 12500, '2025-02-26'),
  (1, 4, '2025-04-01', 12500, '2025-03-29'),
  (1, 5, '2025-05-01', 12500, '2025-04-28'),
  (1, 6, '2025-06-01', 12500, '2025-05-29'),
  (1, 7, '2025-07-01', 12500, '2025-06-28'),
  (1, 8, '2025-08-01', 12500, '2025-07-29'),
  (1, 9, '2025-09-01', 12500, '2025-08-29'),
  (1, 10, '2025-10-01', 12500, '2025-09-28'),
  (1, 11, '2025-11-01', 12500, '2025-10-29'),
  (1, 12, '2025-12-01', 12500, '2025-11-28'),
  (1, 13, '2026-01-01', 12500, '2025-12-29'),
  (1, 14, '2026-02-01', 12500, '2026-01-29'),
  (1, 15, '2026-03-01', 12500, '2026-02-26'),
  (1, 16, '2026-04-01', 12500, '2026-03-29'),
  (1, 17, '2026-05-01', 12500, '2026-04-28'),
  (1, 18, '2026-06-01', 12500, '2026-05-29'),
  (1, 19, '2026-07-01', 12500, '2026-06-28'),
  (1, 20, '2026-08-01', 12500, '2026-07-29'),
  (1, 21, '2026-09-01', 12500, '2026-08-29'),
  (1, 22, '2026-10-01', 12500, '2026-09-28'),
  (1, 23, '2026-11-01', 12500, NULL);

INSERT INTO SUPPLY_ITEM (ItemID, Name, Category, UnitCost, QtyOnHand, ReorderLevel) VALUES
  (1, 'Needles, 27G short (box of 100)', 'needles', 18.50, 12, 5),
  (2, 'Lidocaine 2% cartridges (box of 50)', 'drugs', 42.00, 8, 4),
  (3, 'Nitrile gloves (box of 200)', 'PPE', 16.75, 30, 15),
  (4, 'Paper towels (case of 12 rolls)', 'paper goods', 24.00, 10, 4),
  (5, 'Prophy paste (box of 200 cups)', 'consumables', 31.20, 6, 3),
  (6, 'Composite resin syringe, A2', 'restorative', 54.90, 9, 4),
  (7, 'Sterilization pouches (box of 200)', 'sterilization', 12.40, 20, 8),
  (8, 'Face masks, level 3 (box of 50)', 'PPE', 11.80, 25, 10);

INSERT INTO RESTOCK_ORDER (OrderID, OrderDate, TotalCost) VALUES
  (1, '2026-07-01', 374.50),
  (2, '2026-08-01', 478.80),
  (3, '2026-09-01', 498.10);

INSERT INTO RESTOCK_LINE (OrderID, ItemID, Qty, UnitPrice) VALUES
  (1, 1, 6, 18.50),
  (1, 3, 10, 16.75),
  (1, 4, 4, 24.00),
  (2, 2, 4, 42.00),
  (2, 5, 3, 31.20),
  (2, 7, 8, 12.40),
  (2, 8, 10, 11.80),
  (3, 1, 6, 18.50),
  (3, 3, 10, 16.75),
  (3, 6, 4, 54.90);

INSERT INTO OPERATING_EXPENSE (ExpenseID, Category, Description, Amount, ExpenseDate) VALUES
  (1, 'cleaning', 'Nightly facilities cleaning service', 1450.00, '2026-07-31'),
  (2, 'utilities', 'Electricity, water and internet', 1185.40, '2026-07-31'),
  (3, 'food', 'Break room snacks and coffee', 320.75, '2026-07-31'),
  (4, 'cleaning', 'Nightly facilities cleaning service', 1450.00, '2026-08-31'),
  (5, 'utilities', 'Electricity, water and internet', 1262.10, '2026-08-31'),
  (6, 'food', 'Break room snacks and coffee', 298.40, '2026-08-31'),
  (7, 'cleaning', 'Nightly facilities cleaning service', 1450.00, '2026-09-30'),
  (8, 'utilities', 'Electricity, water and internet', 1214.85, '2026-09-30'),
  (9, 'food', 'Break room snacks and coffee', 341.20, '2026-09-30');

INSERT INTO STARTUP_EXPENSE (StartupCostID, Category, Description, Amount, PurchaseDate) VALUES
  (1, 'furniture', 'Waiting room and front desk furniture', 18500, '2024-11-20'),
  (2, 'equipment', 'Dental chairs and delivery units (8 rooms)', 96000, '2024-12-05'),
  (3, 'equipment', 'Digital X-ray sensors and panoramic unit', 65000, '2024-12-10'),
  (4, 'software', 'Practice management, scheduling and billing', 9800, '2024-12-12'),
  (5, 'supplies', 'Initial stock of clinical supplies', 14200, '2024-12-15'),
  (6, 'training', 'Staff onboarding and software training', 6500, '2024-12-18');
