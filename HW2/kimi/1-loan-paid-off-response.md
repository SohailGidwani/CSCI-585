Confirmed — no TiDB or MySQL instance is running on this machine, so there's literally nothing to query. Once you've run the schema script and inserted the loan and its installment rows, this is the query that answers your question against the design we built:

```sql
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
```

One design nuance worth knowing before you rely on this number: each installment payment is part **principal**, part **interest**, and our schema stores only a single `AmountPaid` per installment. So:

- `SUM(AmountPaid)` = total cash handed to the bank (principal + interest) — this *overstates* how much of the $300K principal is actually retired.
- The true principal paid off would be `SUM(AmountPaid) − SUM(interest portion of each installment)`.

If the owners want an exact "principal remaining" figure (they will, for the P&L and for loan payoff quotes), the fix at detailed-design time is to split each installment into `PrincipalPortion` and `InterestPortion` columns on `LOAN_INSTALLMENT` — the amortization schedule gives you those numbers up front. For a homework answer, the query above plus this caveat is exactly the kind of observation that earns extra credit.

If you'd like, I can also write the `INSERT` statements to seed the loan and its 120-installment schedule so you can actually run this query and watch the number change.
