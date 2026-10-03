CSCI 585 - HW2, SQL from Kimi K3, run on TiDB
Sohail Gidwani (sgidwani@usc.edu)


The assignment: give Kimi K3 the HW1 dental practice description, ask it five
questions in plain English one at a time, and get SQL back for each. Then run
that SQL on TiDB Cloud against tables with real rows in them, and check that the
answers come out right.

README.md has the same content as this file, with the screenshots shown in
place.


RESULTS AT A GLANCE

All of Kimi's SQL ran on TiDB exactly as Kimi wrote it. Nothing needed fixing,
and every result is what the data says it should be.

1. how much of the $300,000 loan have we paid off, so far?
   $73,273.64 paid (24.42%), 22 of 120 installments. Correct.
2. which staff members' licenses will expire next year?
   5 licenses held by 4 people, all expiring in 2027. Correct.
3. how many medical procedures did we perform last year?
   6 (out of 10 services in 2025). Correct.
4. can we get a list of insurance companies that our patients are using?
   Cigna, Delta, Guardian, MetLife. Correct.
5. how many patients are scheduled to visit, during the next 3 months?
   5 patients, 6 appointments. Correct.

Kimi gave more than one query for questions 2 to 5. I ran all ten queries, not
just the main one per question, and they all came out right too.


WHERE TO FIND THE SCREENSHOTS

There is one folder per question. In each one:
- kimi-prompt.png is my question to Kimi K3 with the SQL it gave back.
- tidb-run.png is that same SQL running on TiDB Cloud, with its result.
- the other tidb-run-*.png files are Kimi's extra queries for that question.

setup/ has the two prompts that came before the questions, the screenshots of
creating the tables and loading the data on TiDB, and the three SQL files. The
full list is under FILES at the end.


HOW I GOT THE SQL

Kimi K3 through Cursor, not kimi.com

The assignment says to use kimi.com. kimi.com answered the first prompt once,
and after that every message got this:

    Too many people are chatting with Kimi; a subscription will grant you
    priority access

Kimi K3 is also one of the models you can pick in Cursor, so I used it there. It
is the same model, just a different window. Every Kimi screenshot has "Kimi K3
High" in the model picker at the bottom.

My first try in Cursor was in my coursework folder, and that did not work out.
Cursor quietly feeds files from the open folder to the model, and its answer to
the description mentioned "licenses expiring next year" before I had asked
anything about licenses. It had picked up files from that folder, which by then
held the HW2 handout and my question files. I threw that chat away and redid
everything in a new, empty folder, in Ask mode, so Kimi had nothing to go on but
my prompts. Everything here comes from that second, clean chat.

The prompts

All in one chat, in this order:

0.  the HW1 dental practice description, pasted verbatim
0b. the CREATE TABLE request below
1.  how much of the $300,000 loan have we paid off, so far?
2.  which staff members' licenses will expire next year?
3.  how many medical procedures did we perform last year?
4.  can we get a list of insurance companies that our patients are using?
5.  how many patients are scheduled to visit, during the next 3 months?

Questions 1 to 5 are worded exactly as in the assignment, one prompt each.

Prompt 0b, word for word:

    Now turn this design into CREATE TABLE statements I can run as-is on TiDB
    (MySQL-compatible). Include every foreign key column and constraint the
    relationships need, and order the tables so each one is created after the
    tables it references. Write all SQL in this chat in MySQL syntax, using
    exactly these table and column names.

I added 0b for two reasons. Kimi's answer to the description was a conceptual
design, and most of the linking columns were not spelled out yet. For example,
APPOINTMENT had no patient or room column. If I had gone straight to the five
questions, Kimi would have had to invent those column names separately in each
answer, and they might not have matched each other. With 0b, Kimi wrote one real
schema first, and all five queries were written against it. The assignment says
to run CREATE TABLE commands on TiDB, so this way those commands came from Kimi
too. 0b also fixed the dialect to MySQL, which is what TiDB speaks.

Screenshots: setup/kimi-prompt-0-description.png and
setup/kimi-prompt-0b-create-tables.png


KIMI'S SCHEMA

Kimi designed 26 tables. The full script is setup/01-schema.sql, unchanged from
what Kimi gave me.

  people     STAFF, PROVIDER, FRONT_OFFICE_STAFF, LICENSE, PATIENT
  insurance  INSURANCE_PROVIDER, POLICY
  clinical   ROOM, APPOINTMENT, SERVICE, PROCEDURE, TREATMENT, SURGERY
  billing    BILL, PAYMENT, INSURANCE_CLAIM
  finance    PAYROLL, LOAN, LOAN_INSTALLMENT, LEASE, LEASE_PAYMENT,
             SUPPLY_ITEM, RESTOCK_ORDER, RESTOCK_LINE, OPERATING_EXPENSE,
             STARTUP_EXPENSE

The design choices that matter for the five questions:

- Two subtype hierarchies, done with a shared primary key.
  - PROVIDER (the doctors and hygienists) and FRONT_OFFICE_STAFF are subtypes
    of STAFF. Licenses hang off PROVIDER only, since front office staff do not
    have them.
  - PROCEDURE, TREATMENT and SURGERY are subtypes of SERVICE. The date and fee
    live on SERVICE, so counting procedures means joining PROCEDURE to SERVICE.
- PROCEDURE is a reserved word in MySQL. Kimi backticked it everywhere, in the
  CREATE TABLE and in every later query, so it never caused an error.
- Weak entities for the payment schedules. LOAN_INSTALLMENT and LEASE_PAYMENT
  are keyed by (parent ID, installment number). Each loan installment stores
  one AmountPaid, which is why question 1 can only report cash paid and not
  principal paid. Kimi pointed this out itself.
- UNIQUE constraints for rules an ER diagram can't show:
  - one policy per patient
  - at most one claim per service
  - no room or provider double-booked at the same start time
- Foreign keys everywhere. TiDB enforces them, so the data has to go in parent
  tables first.
- Naming. PROVIDER (a dentist or hygienist) and INSURANCE_PROVIDER (an insurance
  company) are different things with similar names. Kimi kept them straight in
  all its queries.


RUNNING IT ON TIDB

I made a free TiDB Cloud cluster and used its SQL Editor for everything. Before
that, I loaded the same files into a local TiDB v8.5 in Docker and ran every
query there. I checked each result against answers worked out separately from
the data, so I knew the SQL was valid and the numbers were right before touching
TiDB Cloud.

1. Create the database and tables. I ran Kimi's script, setup/01-schema.sql. Its
   first two lines are "CREATE DATABASE IF NOT EXISTS dental_practice;" and
   "USE dental_practice;", which is the assignment's "create a DB with the USE
   command" step. All 28 statements ran (CREATE DATABASE, USE and 26 CREATE
   TABLEs), and the schema tree on the left shows the 26 tables.
   Screenshot: setup/tidb-create-tables.png

2. Load the data. I ran setup/02-seed-data.sql, all 27 statements (USE and one
   INSERT per table).
   Screenshot: setup/tidb-insert-data.png

3. Run the queries. I ran each query from setup/03-kimi-queries.sql on its own,
   so the result panel shows just that one. That file is Kimi's SQL copied out
   of the chat. The only thing I added is a comment line on top of each query
   saying which question it answers.


THE DATA

setup/02-seed-data.sql is made-up data, 253 rows over the 26 tables. The
assignment suggests about 10 rows per table. Mine range from 1 to 24. Some
tables are small because the description fixes their size, like one loan, one
lease and 8 rooms. Others are small because they are subtypes or short lists.

  APPOINTMENT          19      PAYMENT              21
  BILL                 11      PAYROLL              10
  FRONT_OFFICE_STAFF    3      POLICY               10
  INSURANCE_CLAIM      14      PROCEDURE             8
  INSURANCE_PROVIDER    6      PROVIDER              7
  LEASE                 1      RESTOCK_LINE         10
  LEASE_PAYMENT        23      RESTOCK_ORDER         3
  LICENSE               9      ROOM                  8
  LOAN                  1      SERVICE              14
  LOAN_INSTALLMENT     24      STAFF                10
  OPERATING_EXPENSE     9      STARTUP_EXPENSE       6
  PATIENT              12      SUPPLY_ITEM           8
                               SURGERY               3
                               TREATMENT             3

The rows were chosen so each question has something to find, plus some rows
that should be left out. That way a query that filters wrongly would get a
visibly wrong answer. The story behind the data: the practice took the loan in
December 2024, opened in January 2025, and has been seeing patients since.

- Dates. Past dates are fixed. The upcoming appointments are written as
  DATE_ADD(CURDATE(), INTERVAL n DAY), so "the next 3 months" has the same
  answer whatever day the data is loaded.
- Everything is internally consistent:
  - every SERVICE row is in exactly one of PROCEDURE, TREATMENT or SURGERY
  - every bill equals the fees of its services
  - insurance payments match the claims they pay
  - claims point at the patient's own insurer and subscriber ID


QUESTION 1: how much of the $300,000 loan have we paid off, so far?

Screenshots: 1-loan/kimi-prompt.png, 1-loan/tidb-run.png

Kimi's assumptions. "Paid off" is the sum of AmountPaid over the loan's
installments. Kimi flagged that this is cash handed to the bank, interest
included, so it overstates how much of the $300,000 principal is gone. To get
true principal it suggested splitting each installment into principal and
interest columns in a later design pass.

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

Result (one row):

    BankName           Pacific Coast Community Bank
    Principal          300000.00
    TotalPaidSoFar     73273.64
    RemainingBalance   226726.36
    PctPaidOff         24.42
    InstallmentsPaid   22
    InstallmentsTotal  120

Why it's right. The loan is $300,000 at 6% over 10 years. That works out to 120
monthly installments of $3,330.62, starting January 2025. The table holds the
first 24.

- Paid: installments 1 to 22, everything due up to 2026-10-01. One of them (#14)
  was paid 8 days late, and it still counts because it was paid.
- Pending: 23 and 24, with AmountPaid NULL. SUM skips NULLs, and COALESCE would
  cover a loan with nothing paid yet.
- The arithmetic: 22 x 3,330.62 = 73,273.64, which is 24.42% of 300,000.

Kimi's caveat holds here. Of that $73,273.64, only $42,460.19 actually paid down
the principal, and $30,813.45 was interest. So RemainingBalance is "principal
minus cash paid", not the real balance still owed.


QUESTION 2: which staff members' licenses will expire next year?

Screenshots: 2-licenses/kimi-prompt.png, 2-licenses/tidb-run.png,
2-licenses/tidb-run-12-month-watchlist.png

Kimi's assumptions. Today is October 2, 2026, so "next year" is calendar 2027.
Only active licenses count. Licenses belong to PROVIDER, so names come through
PROVIDER to STAFF. Kimi used a date range rather than YEAR() so an index on
ExpiryDate could be used. It also noted YEAR(lic.ExpiryDate) = YEAR(CURDATE())
+ 1 as a version that never needs editing. It then pointed out that "expires
next year" and "expires in the next 12 months" are different questions, and
wrote a second query for the 12-month version.

Main query, calendar 2027:

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

Extra query, rolling 12-month watchlist:

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

Result, main query:

    StaffID  Name                 Specialty       LicenseNo   LicenseType                ExpiryDate
    7        Marcus Bell          hygienist       RDH-099318  RDH                        2027-01-31
    1        Dr. Maya Patel       dentist         DDS-58231   DDS                        2027-03-31
    5        Dr. Sarah Lindqvist  dental surgeon  GA-1184     General Anesthesia Permit  2027-05-31
    3        Dr. Elena Ruiz       endodontist     DDS-61102   DDS                        2027-08-31
    5        Dr. Sarah Lindqvist  dental surgeon  DDS-59950   DDS                        2027-10-31

Result, watchlist (run on 2026-10-03, so DaysUntilExpiry counts from that day):

    Name                 Specialty       LicenseNo   ExpiryDate  DaysUntilExpiry
    Dr. James Okafor     periodontist    DDS-60417   2026-12-31   89
    Marcus Bell          hygienist       RDH-099318  2027-01-31  120
    Dr. Maya Patel       dentist         DDS-58231   2027-03-31  179
    Dr. Sarah Lindqvist  dental surgeon  GA-1184     2027-05-31  240
    Dr. Elena Ruiz       endodontist     DDS-61102   2027-08-31  332

Why it's right. There are 9 licenses. Five are active and expire in 2027, and
those five are exactly what came back. The other four should not show up, and
didn't:

    DDS-60417   Dr. James Okafor  expires 2026-12-31  this year, not next
    DDS-57789   Dr. Kevin Cho     expires 2028-06-30  the year after next
    RDH-104522  Priya Nair        expires 2028-02-29  the year after next
    RDH-088100  Marcus Bell       expired 2025-01-31  his old license, status expired

Dr. Lindqvist shows up twice because she holds two licenses, her DDS and a
general anesthesia permit, and both expire in 2027. Marcus Bell shows up once,
for his current license only.

The watchlist gives a different list, as it should:
- it adds Okafor, whose license expires within 12 months but in 2026;
- it drops Lindqvist's DDS, which expires in 2027 but more than 12 months out.


QUESTION 3: how many medical procedures did we perform last year?

Screenshots: 3-procedures/kimi-prompt.png, 3-procedures/tidb-run.png,
3-procedures/tidb-run-by-type.png

Kimi's assumptions. Last year is calendar 2025. Because of the subtypes,
"procedures" can mean two things. The narrow reading is rows in the PROCEDURE
subtype only, such as cleanings, and not treatments or surgeries. The broad
reading is every service performed. Kimi wrote a query for each. The broad one
breaks the total down by type, which works because each service is in exactly
one subtype.

Main query, PROCEDURE subtype only:

    SELECT COUNT(*) AS ProceduresLastYear
    FROM `PROCEDURE` pr
    JOIN SERVICE s ON pr.ServiceID = s.ServiceID
    WHERE s.ServiceDate >= DATE '2025-01-01'
      AND s.ServiceDate <  DATE '2026-01-01';

Extra query, every service in 2025 by type:

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

Result. ProceduresLastYear = 6. The breakdown query gives TotalServices 10,
Procedures 6, Treatments 2, Surgeries 2.

Why it's right. There are 14 services, from 11 completed appointments.

- 10 are in 2025:
  - 6 procedures: three cleanings (D1110), a periodic exam (D0120), a full
    exam (D0150) and bitewing X-rays (D0274)
  - 2 treatments: a filling (D2391) and scaling and root planing for gum
    disease (D4341)
  - 2 surgeries: two extractions (D7140, D7240)
- 4 are in 2026, and none of them got counted.
- The year edges are covered: one cleaning is on 2025-12-30 and is counted, the
  next one is on 2026-01-06 and is not.


QUESTION 4: can we get a list of insurance companies that our patients are using?

Screenshots: 4-insurance/kimi-prompt.png, 4-insurance/tidb-run.png,
4-insurance/tidb-run-patients-per-company.png,
4-insurance/tidb-run-companies-not-used.png

Kimi's assumptions. INSURANCE_PROVIDER is the practice's master list of
companies, so "companies our patients are using" means companies that appear in
at least one patient's POLICY. Kimi wrote three queries:
- the list itself
- a count of patients per company
- companies on the list that no patient uses

Kimi also pointed out that keeping providers in their own table is what makes
this question easy. With insurer names typed per patient, a typo would invent a
company.

Main query, the list:

    SELECT DISTINCT
        ip.ProviderID,
        ip.Name,
        ip.Phone,
        ip.ContactPerson
    FROM INSURANCE_PROVIDER ip
    JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
    ORDER BY ip.Name;

Extra query, patients per company:

    SELECT
        ip.Name,
        COUNT(*) AS PatientsCovered
    FROM INSURANCE_PROVIDER ip
    JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
    GROUP BY ip.ProviderID, ip.Name
    ORDER BY PatientsCovered DESC, ip.Name;

Extra query, companies no patient uses:

    SELECT ip.Name
    FROM INSURANCE_PROVIDER ip
    LEFT JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
    WHERE pol.SubscriberID IS NULL
    ORDER BY ip.Name;

Result, the list:

    ProviderID  Name             Phone           ContactPerson
    3           Cigna Dental     (800) 555-0103  Denise Park
    1           Delta Dental     (800) 555-0101  Karen Holt
    5           Guardian Dental  (800) 555-0105  Renee Fox
    2           MetLife Dental   (800) 555-0102  Brian Molina

Patients per company: Delta Dental 4, then Cigna Dental, Guardian Dental and
MetLife Dental with 2 each. Companies nobody uses: Aetna Dental, Humana Dental.

Why it's right.
- There are 6 insurance companies on the list and 12 patients.
- 10 patients have a policy: Delta covers 4 (patients 1, 2, 3 and 9), and
  MetLife, Cigna and Guardian cover 2 each.
- 2 patients have no insurance. The description says most patients are insured,
  not all of them.
- Aetna and Humana are on the list with no patients, so the main query had to
  leave them out, and it did.
- The three queries agree with each other: 4 companies in use plus 2 unused
  makes the 6 on the list, and 4 + 2 + 2 + 2 is the 10 policies.
- Two of the policies have the coverage type "savings plan", the example from
  the description.


QUESTION 5: how many patients are scheduled to visit, during the next 3 months?

Screenshots: 5-upcoming-visits/kimi-prompt.png, 5-upcoming-visits/tidb-run.png,
5-upcoming-visits/tidb-run-by-month.png

Kimi's assumptions.
- The window: a rolling 3 months from today, so from Oct 2, 2026 it runs
  through Jan 2, 2027.
- Which appointments: only status 'scheduled', so cancelled ones are left out.
- Patients, not appointments: the question asks about patients, so it counts
  distinct patients, with appointments counted alongside.
- Not SchedState: Kimi said not to use PATIENT.SchedState = 'scheduled'. That
  column says a patient is scheduled but not when, and it can drift out of
  date, while APPOINTMENT is the real record. It also wrote a month-by-month
  version.

Main query:

    SELECT
        COUNT(DISTINCT PatientID) AS PatientsScheduled,
        COUNT(*)                  AS TotalAppointments
    FROM APPOINTMENT
    WHERE Status = 'scheduled'
      AND Date >= CURDATE()
      AND Date <  DATE_ADD(CURDATE(), INTERVAL 3 MONTH);

Extra query, month by month:

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

Result. PatientsScheduled 5, TotalAppointments 6. By month (run on 2026-10-03):
October 3 and 3, November 2 and 2, December 1 and 1.

Why it's right. There are 19 appointments. 11 are completed visits in the past,
and 8 are upcoming:

    days from today  patient         status     counted?
    +6               Emily Nguyen    scheduled  yes
    +13              Robert Kim      scheduled  yes
    +20              Daniel Brooks   cancelled  no, cancelled
    +27              Lucas Rivera    scheduled  yes
    +41              Emily Nguyen    scheduled  yes, but she is the same patient
    +55              Mia Thompson    scheduled  yes
    +76              Sofia Martinez  scheduled  yes
    +120             Hannah Lee      scheduled  no, about 4 months out

That gives 6 appointments and 5 different patients, which is exactly what came
back. Kimi's warning about SchedState also shows up in this data. Six patients
have SchedState 'scheduled', because Hannah Lee is booked, just not within 3
months. So the SchedState shortcut would have said 6 patients, and the right
answer is 5.


WHAT I NOTICED ABOUT KIMI'S SQL

- It all ran on TiDB as written. That includes the CREATE TABLE script with its
  foreign keys, ENUMs and the backticked PROCEDURE table, and all ten queries.
  Apart from the comment line I added above each query, I did not change a
  single character.
- It stated its assumptions before the SQL every time, which is what the
  assignment said to expect. Several were worth stating:
  - interest vs principal in question 1
  - calendar year vs next 12 months in question 2
  - the two readings of "procedures" in question 3
  - why SchedState is the wrong column in question 5
- It offered the second reading as extra SQL instead of quietly picking one,
  which is why questions 2 to 5 have more than one query.
- Two queries hardcode the year. Question 2 uses 2027 and question 3 uses 2025.
  They are right today but go stale in January 2027. Kimi mentioned the
  YEAR(CURDATE()) + 1 and YEAR(CURDATE()) - 1 versions that keep working, but
  did not make them the main answer.
- Question 1 finds the loan with WHERE l.Principal = 300000. That works with one
  loan, but would break if the amount ever changed. Kimi noted LoanID as the
  better filter in a comment.
- Kimi answered the questions literally. Each answer opens by saying there is no
  database yet, so the real answer is zero or unknown, and then gives the SQL.
  Question 1 opens with "Confirmed - no TiDB or MySQL instance is running on
  this machine".


FILES

This is what is inside the submission zip:

README.md                          same content, the screenshots show up in place
README.txt                         this file
1-loan/                            kimi-prompt.png, tidb-run.png
2-licenses/                        kimi-prompt.png, tidb-run.png,
                                   tidb-run-12-month-watchlist.png
3-procedures/                      kimi-prompt.png, tidb-run.png,
                                   tidb-run-by-type.png
4-insurance/                       kimi-prompt.png, tidb-run.png,
                                   tidb-run-patients-per-company.png,
                                   tidb-run-companies-not-used.png
5-upcoming-visits/                 kimi-prompt.png, tidb-run.png,
                                   tidb-run-by-month.png
setup/
  kimi-prompt-0-description.png    prompt 0, the HW1 description
  kimi-prompt-0b-create-tables.png prompt 0b, Kimi's CREATE TABLE script
  tidb-create-tables.png           running that script on TiDB
  tidb-insert-data.png             loading the data on TiDB
  01-schema.sql                    Kimi's CREATE TABLE script
  02-seed-data.sql                 the data
  03-kimi-queries.sql              Kimi's queries for the 5 questions

The github repo the zip is built from has a few more things.
HW2_SohailHareshGidwani/ is the zip unpacked, and it is where the screenshots
live. kimi/ has Kimi's full reply to every prompt as text, prompts/ has the
prompts, and sql/ also has a reset script and the expected results I checked
against. make-zip.sh copies the READMEs and the SQL files into
HW2_SohailHareshGidwani/ and zips that folder. The assignment PDF and the copy
of the HW1 description came off bytes.usc.edu and belong to the professor, so I
keep local copies but don't push them.
