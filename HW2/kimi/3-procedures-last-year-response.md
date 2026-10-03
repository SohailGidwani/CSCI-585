Still zero — or more precisely, still unknowable: no database exists, no `SERVICE` rows have ever been inserted. The practice hasn't seen a single patient in this system. Once it's loaded, here's how you'd answer it.

"Last year" relative to today (Oct 2, 2026) is calendar year 2025. And because of our EER design, "procedures" has two possible meanings, so here are both:

**Narrow reading — rows of the `PROCEDURE` subtype only** (e.g., teeth cleanings, not treatments or surgeries):

```sql
SELECT COUNT(*) AS ProceduresLastYear
FROM `PROCEDURE` pr
JOIN SERVICE s ON pr.ServiceID = s.ServiceID
WHERE s.ServiceDate >= DATE '2025-01-01'
  AND s.ServiceDate <  DATE '2026-01-01';
```

Note the backticks — `PROCEDURE` is a reserved word, as flagged when we built the schema. The date lives on the `SERVICE` superclass, which is exactly why the subtype join is needed.

**Broad reading — every service performed** (procedures + treatments + surgeries), with a per-type breakdown:

```sql
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
```

This works because each `SERVICE` row appears in **at most one** subtype table (the disjoint specialization), so the three `LEFT JOIN`s partition the count without double-counting.

Two small refinements if you want them:

- **Evergreen version** (no annual edit): replace the date range with `YEAR(s.ServiceDate) = YEAR(CURDATE()) - 1`.
- **Only count completed visits**: add `JOIN APPOINTMENT a ON s.ApptID = a.ApptID AND a.Status = 'completed'` — this excludes anything recorded under a cancelled or no-show appointment.

This query is also a preview of the owners' analytics vision: wrap it without the date filter, `GROUP BY YEAR(s.ServiceDate), MONTH(s.ServiceDate)`, and you've got procedure-volume trend reporting — the seed of the future `FACT_SERVICE` star schema I mentioned in the design rationale.
