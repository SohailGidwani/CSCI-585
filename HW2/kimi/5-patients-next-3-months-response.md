Right now: **zero**, for the same reason as before — there's no database and no appointment data anywhere yet. But the schema answers this directly once it's loaded.

Today is Oct 2, 2026, so "next 3 months" is the rolling window through Jan 2, 2027. The question asks about *patients*, so count distinct patients (one person with three check-ups still counts once) — though counting the visits themselves is also useful:

```sql
SELECT
    COUNT(DISTINCT PatientID) AS PatientsScheduled,
    COUNT(*)                  AS TotalAppointments
FROM APPOINTMENT
WHERE Status = 'scheduled'
  AND Date >= CURDATE()
  AND Date <  DATE_ADD(CURDATE(), INTERVAL 3 MONTH);
```

And if the owners want it month by month (useful for staffing the 8 rooms):

```sql
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
```

One design note worth mentioning in your write-up: you might be tempted to answer this with `SELECT COUNT(*) FROM PATIENT WHERE SchedState = 'scheduled'` — but that would be wrong, for two reasons:

1. **It can't express the time window.** `SchedState` says *that* a patient is scheduled, not *when* — a patient whose appointment is 8 months out looks identical to one coming in next week.
2. **It's derived data that can drift.** The `APPOINTMENT` table is the authoritative source; `SchedState` is just a cached convenience for the front office's workflow queue. If someone cancels an appointment and forgets to flip the state, the two disagree — and the query above keeps telling the truth.

This is a classic normalization trade-off you can cite: we kept `SchedState` for workflow convenience (decision #11 in the design rationale) while treating `APPOINTMENT` as the system of record for anything time-based.
