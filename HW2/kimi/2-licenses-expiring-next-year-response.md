Same situation as the loan question — **no one, because there's still no data.** No database is running on this machine and no `LICENSE` rows exist yet; this is all still design-on-paper. But once you've loaded data, here's the query against our schema.

Since today is October 2, 2026, "next year" means calendar year 2027:

```sql
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
```

A few notes:

- **Why the join chain**: `LICENSE.StaffID` points at `PROVIDER` (only medical professionals hold licenses — that was the point of the EER subclass), and `PROVIDER` shares its PK with `STAFF`, where `Name` lives. `Specialty` comes along from `PROVIDER` for free.
- **Date range instead of `YEAR()`**: `ExpiryDate >= '2027-01-01' AND ExpiryDate < '2028-01-01'` can use an index on `ExpiryDate`; wrapping the column in `YEAR(ExpiryDate) = 2027` cannot. If you want it to stay correct without editing it every January, use `YEAR(lic.ExpiryDate) = YEAR(CURDATE()) + 1` and accept the full scan (trivial at this data volume).
- **Two different questions people conflate**: "expires in calendar 2027" (above) vs. "expires within the next 12 months." The operationally useful one for the front office is the rolling window:

```sql
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
```

That second query is really the one the business wants — per the renewal requirement in the brief, the practice needs advance warning so no hygienist or dentist is ever scheduled while unlicensed. In a later design pass you could pair it with a business rule like "an appointment may not be created for a provider whose license expires before the appointment date" — enforceable with a trigger, not expressible in the ER diagram.

Want me to write seed `INSERT`s (a few staff, providers, and licenses with staggered expiry dates) so you can run these and see real output?
