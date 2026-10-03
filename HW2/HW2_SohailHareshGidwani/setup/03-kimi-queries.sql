-- Kimi K3's SQL for the 5 questions, copied unchanged from kimi/<n>-*-response.md.
-- Run each query on its own in TiDB (select it, then Run) so the result panel shows just that one.

-- Q1: how much of the $300,000 loan have we paid off, so far?
SELECT
    l.LoanID,
    l.BankName,
    l.Principal,
    COALESCE(SUM(i.AmountPaid), 0)                    AS TotalPaidSoFar,
    l.Principal - COALESCE(SUM(i.AmountPaid), 0)      AS RemainingBalance,
    ROUND(100 * COALESCE(SUM(i.AmountPaid), 0)
              / l.Principal, 2)                       AS PctPaidOff,
    SUM(CASE WHEN i.Status = 'paid' THEN 1 ELSE 0 END) AS InstallmentsPaid,
    l.TermYears * 12                                  AS InstallmentsTotal
FROM LOAN l
LEFT JOIN LOAN_INSTALLMENT i
       ON i.LoanID = l.LoanID
WHERE l.Principal = 300000          -- or: l.LoanID = <id>
GROUP BY l.LoanID, l.BankName, l.Principal, l.TermYears;

-- Q2a: which staff members' licenses will expire next year?  (main answer, calendar year 2027)
SELECT
    s.StaffID,
    s.Name,
    p.Specialty,
    lic.LicenseNo,
    lic.Type        AS LicenseType,
    lic.ExpiryDate
FROM LICENSE lic
JOIN PROVIDER p ON lic.StaffID = p.StaffID
JOIN STAFF    s ON p.StaffID   = s.StaffID
WHERE lic.ExpiryDate >= DATE '2027-01-01'
  AND lic.ExpiryDate <  DATE '2028-01-01'
  AND lic.Status = 'active'
ORDER BY lic.ExpiryDate, s.Name;

-- Q2b: which staff members' licenses will expire next year?  (extra, rolling 12-month renewal watchlist)
-- renewal watchlist: anything expiring in the next 12 months
SELECT s.Name, p.Specialty, lic.LicenseNo, lic.ExpiryDate,
       DATEDIFF(lic.ExpiryDate, CURDATE()) AS DaysUntilExpiry
FROM LICENSE lic
JOIN PROVIDER p ON lic.StaffID = p.StaffID
JOIN STAFF    s ON p.StaffID   = s.StaffID
WHERE lic.Status = 'active'
  AND lic.ExpiryDate BETWEEN CURDATE()
                         AND DATE_ADD(CURDATE(), INTERVAL 1 YEAR)
ORDER BY lic.ExpiryDate;

-- Q3a: how many medical procedures did we perform last year?  (main answer, PROCEDURE subtype only)
SELECT COUNT(*) AS ProceduresLastYear
FROM `PROCEDURE` pr
JOIN SERVICE s ON pr.ServiceID = s.ServiceID
WHERE s.ServiceDate >= DATE '2025-01-01'
  AND s.ServiceDate <  DATE '2026-01-01';

-- Q3b: how many medical procedures did we perform last year?  (extra, every service in 2025 broken down by type)
SELECT
    COUNT(*)                       AS TotalServices,
    SUM(pr.ServiceID IS NOT NULL)  AS Procedures,
    SUM(t.ServiceID  IS NOT NULL)  AS Treatments,
    SUM(sg.ServiceID IS NOT NULL)  AS Surgeries
FROM SERVICE s
LEFT JOIN `PROCEDURE` pr ON pr.ServiceID = s.ServiceID
LEFT JOIN TREATMENT  t  ON t.ServiceID  = s.ServiceID
LEFT JOIN SURGERY    sg ON sg.ServiceID = s.ServiceID
WHERE s.ServiceDate >= DATE '2025-01-01'
  AND s.ServiceDate <  DATE '2026-01-01';

-- Q4a: can we get a list of insurance companies that our patients are using?  (main answer)
SELECT DISTINCT
    ip.ProviderID,
    ip.Name,
    ip.Phone,
    ip.ContactPerson
FROM INSURANCE_PROVIDER ip
JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
ORDER BY ip.Name;

-- Q4b: can we get a list of insurance companies that our patients are using?  (extra, patients per company)
SELECT
    ip.Name,
    COUNT(*) AS PatientsCovered
FROM INSURANCE_PROVIDER ip
JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
GROUP BY ip.ProviderID, ip.Name
ORDER BY PatientsCovered DESC, ip.Name;

-- Q4c: can we get a list of insurance companies that our patients are using?  (extra, companies on the list that no patient uses)
SELECT ip.Name
FROM INSURANCE_PROVIDER ip
LEFT JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
WHERE pol.SubscriberID IS NULL
ORDER BY ip.Name;

-- Q5a: how many patients are scheduled to visit, during the next 3 months?  (main answer)
SELECT
    COUNT(DISTINCT PatientID) AS PatientsScheduled,
    COUNT(*)                  AS TotalAppointments
FROM APPOINTMENT
WHERE Status = 'scheduled'
  AND Date >= CURDATE()
  AND Date <  DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

-- Q5b: how many patients are scheduled to visit, during the next 3 months?  (extra, month by month)
SELECT
    DATE_FORMAT(Date, '%Y-%m')  AS Month,
    COUNT(DISTINCT PatientID)   AS PatientsScheduled,
    COUNT(*)                    AS Appointments
FROM APPOINTMENT
WHERE Status = 'scheduled'
  AND Date >= CURDATE()
  AND Date <  DATE_ADD(CURDATE(), INTERVAL 3 MONTH)
GROUP BY DATE_FORMAT(Date, '%Y-%m')
ORDER BY Month;
