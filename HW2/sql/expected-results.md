# What each Kimi query should return

Use these numbers for the "check that the output is correct" step. They come from the data in
`02-seed-data.sql` and were confirmed by loading `01-schema.sql` and `02-seed-data.sql` into a
local TiDB v8.5 and running every query in `03-kimi-queries.sql`.

Results marked **(changes daily)** depend on the day you run them. Everything else is fixed.
"Today" means whatever `CURDATE()` returns on the database server. The local test container ran
on UTC, so its "today" was 2026-10-03 while it was still Oct 2 in LA. TiDB Cloud may also use UTC.
That doesn't matter as long as you load the data and run the queries on the same day.

## Q1, the loan

One row:

| BankName | Principal | TotalPaidSoFar | RemainingBalance | PctPaidOff | InstallmentsPaid | InstallmentsTotal |
|---|---|---|---|---|---|---|
| Pacific Coast Community Bank | 300000.00 | 73273.64 | 226726.36 | 24.42 | 22 | 120 |

There are 24 installments in the table, $3,330.62 each ($300,000 at 6% over 10 years). Everything due up to
2026-10-01 is paid (22 installments), and the last 2 are still pending. Kimi's caveat holds here: the
$73,273.64 includes interest. Only $42,460.19 of it actually paid down the $300,000, and $30,813.45 was interest.

## Q2a, licenses expiring in 2027

5 rows, ordered by expiry date:

| Name | Specialty | LicenseNo | LicenseType | ExpiryDate |
|---|---|---|---|---|
| Marcus Bell | hygienist | RDH-099318 | RDH | 2027-01-31 |
| Dr. Maya Patel | dentist | DDS-58231 | DDS | 2027-03-31 |
| Dr. Sarah Lindqvist | dental surgeon | GA-1184 | General Anesthesia Permit | 2027-05-31 |
| Dr. Elena Ruiz | endodontist | DDS-61102 | DDS | 2027-08-31 |
| Dr. Sarah Lindqvist | dental surgeon | DDS-59950 | DDS | 2027-10-31 |

Licenses that are correctly left out:
- Dr. Okafor's license expires 2026-12-31, which is this year, not next.
- Dr. Cho's expires in 2028.
- Marcus Bell's old license expired in 2025.

Dr. Lindqvist shows up twice because she holds two licenses that both expire in 2027.

## Q2b, the 12-month watchlist (changes daily)

5 rows: Okafor (2026-12-31), Bell, Patel, Lindqvist's GA permit, and Ruiz. `DaysUntilExpiry` counts down
each day. Compared with Q2a, Okafor is in this list and Lindqvist's DDS (2027-10-31) is not, because this
query looks at the next 12 months rather than calendar year 2027.

## Q3a, procedures in 2025

`ProceduresLastYear` = **6**

## Q3b, every service in 2025 by type

| TotalServices | Procedures | Treatments | Surgeries |
|---|---|---|---|
| 10 | 6 | 2 | 2 |

The 4 services from 2026 are correctly left out.

## Q4a, insurance companies patients use

4 rows: Cigna Dental, Delta Dental, Guardian Dental, MetLife Dental (alphabetical, with phone and contact person).

## Q4b, patients per company

Delta Dental 4, then Cigna Dental, Guardian Dental and MetLife Dental with 2 each.

## Q4c, companies nobody uses

Aetna Dental, Humana Dental

## Q5a, patients scheduled in the next 3 months

| PatientsScheduled | TotalAppointments |
|---|---|
| 5 | 6 |

The upcoming appointments are dated relative to the day you load the data, so this stays 5 / 6 whenever you run it.
- Emily Nguyen has two appointments in the window, which is why it's 5 patients but 6 appointments.
- Daniel Brooks's appointment is in the window but was cancelled.
- Hannah Lee is booked about 4 months out, so she falls outside the window even though her `SchedState` is 'scheduled'.
  That's the case Kimi warned about: `SELECT COUNT(*) FROM PATIENT WHERE SchedState = 'scheduled'` gives 6, not 5.

## Q5b, month by month (changes daily)

The rows add up to 6 appointments. Which months appear depends on the day you run it. Loaded on
2026-10-03 the rows were 2026-10 (3 patients, 3 appointments), 2026-11 (2, 2) and 2026-12 (1, 1).
