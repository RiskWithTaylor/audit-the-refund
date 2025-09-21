WITH dup AS (
  SELECT SSN, TaxYear, COUNT(*) AS filings
  FROM TaxReturns
  GROUP BY SSN, TaxYear
  HAVING COUNT(*) > 1
),
flags AS (
  SELECT
    t.ReturnID,
    CASE WHEN d.SSN IS NOT NULL THEN 1 ELSE 0 END AS flag_duplicate_ssn,
    CASE WHEN t.ClaimedDeductions > 0.80 * t.ReportedIncome THEN 1 ELSE 0 END AS flag_excessive_deductions,
    CASE WHEN t.RefundRequested > 1.5 * t.TaxWithheld THEN 1 ELSE 0 END AS flag_inflated_refund,
    CASE WHEN t.ReportedIncome < 20000 AND t.RefundRequested > 3000 THEN 1 ELSE 0 END AS flag_low_income_high_refund,
    CASE WHEN t.TaxWithheld = 0 AND t.RefundRequested > 0 THEN 1 ELSE 0 END AS flag_missing_withholding
  FROM TaxReturns t
  LEFT JOIN dup d ON d.SSN = t.SSN AND d.TaxYear = t.TaxYear
)
SELECT * FROM flags;
