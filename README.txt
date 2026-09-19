CSCI 585 - HW1, ER diagram
Sohail Gidwani (sgidwani@usc.edu)


WHAT I AM SUBMITTING

The ER diagram I am submitting is ER-diagram-FINAL-gpt6-astra-max.png, and the
mermaid source for it is in ER-diagram-FINAL-gpt6-astra-max.mmd. That is my
answer. Everything inside the comparison folder is just the other models I
tested, I put it there so you can see the work, it is not my submission.


WHICH LLMS I TRIED

I did the ollama route from the assignment first. Installed llama3 and gemma2:2b
locally and ran them side by side in the streamlit app, same prompt going to both
at once. After that I ran the same task on GPT-6 Astra Max through my USC
ChatGPT Edu account, and on Gemini 3.6 Thinking through the USC google account.
So four models in total.

The two local ones both did badly.

llama3 on the first run gave me class diagram syntax instead of ER diagram
syntax, so every entity came out as "class STAFF {" which mermaid.live will not
parse at all. It also gave zero relationship lines, so what I got was basically a
list of tables and not an ER diagram. I sent it a second prompt with its broken
output pasted in and told it exactly what was wrong, and that time it did fix the
syntax and it did add relationships. But it was still only 15 entities and 8
relationships, and 5 of those entities (FINANCING, PROCEDURE_CODE, FACILITIES,
LEASE and REPORTING) had no relationship lines on them at all, so they just float
around on the diagram with nothing connecting them.

gemma2:2b never really got there. Every time I ran it, it copied the CUSTOMER and
ORDER example straight out of the mermaid documentation into my dental diagram.
It also kept writing attributes backwards as "PK staff_id int" instead of
"int staff_id PK", which is a parse error, and most of its entity blocks had no
attributes inside them at all.

GPT-6 and Gemini both did a proper job and both gave me something that actually
renders and covers the business.


WHY I PICKED THE GPT-6 ONE

The counts first. GPT-6 gave 28 entities and 34 relationships with no orphan
entities, and it parsed and rendered with no edits from me at all. Gemini gave 23
entities and 23 relationships, also no orphans, but I had to fix "int staff_id PK
FK" to "int staff_id PK, FK" in two places before it would parse. llama3 after
its second attempt was 15 entities, 8 relationships and 5 orphans.

Beyond the counts, the GPT-6 design handles the money side of this business much
better, and this business is mostly about money:

1. It has one cost ledger (COST_CATEGORY and COST_ENTRY) that everything expense
   related hangs off, and then PAYROLL_ENTRY, LEASE_CHARGE and FIXED_ASSET extend
   it for salaries, rent and equipment. So the monthly profit and loss report is
   one query. In the Gemini design the expenses are spread over five separate
   tables and you have to union all of them to get the same report.

2. It splits LOAN_INSTALLMENT (what is scheduled to be paid) from LOAN_PAYMENT
   (what actually got paid), with principal and interest kept separate. The
   assignment says the loan is paid off in installments over 10 years, so the
   schedule itself is part of the requirement. Gemini only models the payments
   and not the schedule.

3. PAYMENT_ALLOCATION sits between payments and charges. This is the part I liked
   most. It means one insurance cheque can cover six different procedures, and a
   patient can pay a bill in parts, and the amount owed vs amount paid by
   insurance vs amount paid by the patient all still come out correctly. Without
   it you cannot really answer those three numbers the assignment asks for.

4. The five patient scheduling states are a proper lookup table
   (SCHEDULING_STATE) on the one side of the relationship. Gemini just made
   scheduling_state a string column on PATIENT, which works but is weaker.

5. It has PATIENT_CONTACT, so a front office person phoning a patient is recorded
   even when that call does not turn into an appointment. The description
   specifically says front office staff routinely contact patients, so this felt
   right to keep.

The one place Gemini is better is supplies. Gemini models SUPPLY_ITEM,
SUPPLY_ORDER and SUPPLY_ORDER_ITEM with stock quantities, and GPT-6 just treats
supply restocking as another cost entry. I still went with GPT-6 because it says
in its own notes that it is leaving inventory out on purpose, and the assignment
says some things will not fit in an ER diagram and that is fine. A gap that is
written down reads better to me than one that is just missing.


THE DESIGN ITSELF

The rationale below is condensed from the design notes GPT-6 produced with the
diagram. I have cut it down and kept the parts I agree with and can defend.

Staff. EMPLOYEE is the supertype and every employee is either a
MEDICAL_PROFESSIONAL or FRONT_OFFICE_STAFF, total and disjoint. Licenses hang off
MEDICAL_PROFESSIONAL only, because front office people do not have them. Each
license row has its state, number, validity dates, status and a verified date, so
you can check who is expiring. Salary is monthly on EMPLOYEE and the historical
amounts live in the payroll cost entries, so old salaries are not lost when
someone gets a raise.

Appointments. An appointment has one patient, one room, one scheduled doctor and
one front office person who booked it. The doctor who is scheduled and the doctor
who actually did the work are stored separately, because those are not always the
same person. FACILITY and ROOM are separate from LEASE so that if the lease gets
renewed the rooms keep their identity.

Medical records. Procedures, treatments and surgeries are all SERVICE_TYPE rows
told apart by service_kind, since all three are the same shape of thing, they are
just a CDT code and a fee. PERFORMED_SERVICE is one actual thing done to one
patient at one appointment. The patient medical record is not a stored table, you
get it by following the patient to their appointments to their performed
services.

Insurance. PATIENT_COVERAGE sits between PATIENT and INSURANCE_PROVIDER so a
patient can have no insurance, or more than one policy, or change policy over
time. A claim bills one performed service against one coverage row. The subscriber
ID, CDT code and treatment date do not get copied onto the claim, you reach them
through the relationships.

Reports. The morning schedule, the end of day billable income and the monthly
profit and loss are all queries, not tables. I did not store any of them. Daily
income is the sum of billed amounts on services performed that day. Monthly
profit and loss is service charges minus recognised costs, loan interest and
depreciation.


WHAT IS NOT MODELLED

Supply quantities and inventory levels, as mentioned above. Also invoice headers
as their own entity, treatment plans, refunds and write offs, tax, and the
history of a patient moving between scheduling states (only the current state is
stored).

Some of the rules cannot be drawn in an ER diagram and would need database
constraints or application code instead. For example, two appointments must not
overlap in the same room, a patient must have exactly one scheduling state, an
employee cannot be in both subtypes at once, and the payment allocations against
a payment have to add up to that payment and not overpay a charge.


FILES

README.txt                                this file
README.md                                 same content, the diagrams render in it
ER-diagram-FINAL-gpt6-astra-max.png       the ER diagram I am submitting
ER-diagram-FINAL-gpt6-astra-max.mmd       mermaid source for the above
prompt-used.txt                           the prompt I gave GPT-6 and Gemini
screenshot-ollama-llama3-gemma2.png       prompt and output, local llama3 + gemma2
screenshot-gpt6-astra-max.png             prompt and output, GPT-6 Astra Max
comparison/                               the other three models, not my answer
comparison/prompt-ollama.txt              the prompt I gave llama3 and gemma2:2b
