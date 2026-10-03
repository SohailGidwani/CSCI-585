Yes — the schema supports that directly, though right now it would return an **empty list**, since there are still no patients, policies, or providers in any database (same story as the last three questions: nothing has been loaded anywhere).

Once data exists, here's the query. The key design point: `INSURANCE_PROVIDER` is the *master list* of all companies the practice works with, so "companies our patients are actually using" means providers that appear in `POLICY`:

```sql
SELECT DISTINCT
    ip.ProviderID,
    ip.Name,
    ip.Phone,
    ip.ContactPerson
FROM INSURANCE_PROVIDER ip
JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
ORDER BY ip.Name;
```

A more useful version for the front office — with how many patients each company covers:

```sql
SELECT
    ip.Name,
    COUNT(*) AS PatientsCovered
FROM INSURANCE_PROVIDER ip
JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
GROUP BY ip.ProviderID, ip.Name
ORDER BY PatientsCovered DESC, ip.Name;
```

`COUNT(*)` equals the number of patients here because of the `uq_policy_patient UNIQUE (PatientID)` constraint we put on `POLICY` — one policy per patient, so no patient can be counted twice under the same insurer.

And the flip side, which the staff will eventually want for list maintenance — companies on the master list that **no** patient currently uses:

```sql
SELECT ip.Name
FROM INSURANCE_PROVIDER ip
LEFT JOIN POLICY pol ON pol.ProviderID = ip.ProviderID
WHERE pol.SubscriberID IS NULL
ORDER BY ip.Name;
```

Worth noting for your write-up: this is exactly the requirement from the brief — "the staff needs to maintain a list of insurance providers" — and it's why `INSURANCE_PROVIDER` was modeled as its own entity rather than a `ProviderName` string on the patient's billing record. If provider names were stored as free text per patient, this simple query would need error-prone `DISTINCT` over hand-typed names, and a typo would invent a phantom insurance company.
