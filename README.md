# Audit the Refund – Fraud Detection with SQL

**Short pitch:** A lightweight, end-to-end project that simulates how auditors flag **suspicious tax returns** using **SQL + simple analytics**. Built for accountants, risk analysts, and data-curious pros who want a clean, explainable baseline they can extend.

---

## 🎯 Objectives
- Detect **duplicate SSNs**, **excessive deductions**, and **inflated refunds**.
- Produce a **flag table** and **risk score** per return.
- Ship a **dashboard** (Excel/Power BI) that summarizes red flags and dollars at risk.

---

## 🧱 Project Stack
- **Database:** SQLite (simple + portable) or PostgreSQL (optional).
- **SQL:** ANSI-SQL, works with minor tweaks across engines.
- **BI:** Excel or Power BI (choose either).
- **(Optional)** Python/R for exports or visuals.

---

## 📁 Repo Structure
audit-the-refund/

├─ data/

│ ├─ tax_returns_sample.csv

│ └─ lookup_filing_status.csv

├─ sql/

│ ├─ 00_create_tables.sql

│ ├─ 01_load_sample_data.sql

│ ├─ 02_rules_flags.sql

│ ├─ 03_risk_scoring.sql

│ └─ 04_export_views.sql

├─ dashboards/

│ └─ (placeholder for BI dashboards)

├─ notebooks/

│ └─ (optional Python/R)

└─ README.md


---

## 🧪 Dataset Schema

**`TaxReturns`**
| Column            | Type     | Notes |
|---|---|---|
| ReturnID          | INTEGER  | Unique id per return |
| SSN               | TEXT     | Pseudonymized OK (e.g., XXX-XX-1234) |
| FilingStatus      | TEXT     | Single, Married, HOH, etc. |
| ReportedIncome    | NUMERIC  | Wages + other income |
| ClaimedDeductions | NUMERIC  | Total deductions |
| TaxWithheld       | NUMERIC  | Employer/estimated payments |
| RefundRequested   | NUMERIC  | Requested refund amount |
| TaxYear           | INTEGER  | e.g., 2024 |

**`lookup_filing_status.csv`**
Basic reference table mapping `FilingStatus` codes to descriptions.

---

## ⚖️ Red-Flag Rules (Baseline)
1. **Duplicate SSN filings**: same `SSN` appears > 1 time for the same `TaxYear`.
2. **Excessive deductions**: `ClaimedDeductions > 0.80 * ReportedIncome` (tuneable).
3. **Refund inflated vs. withholdings**: `RefundRequested > 1.5 * TaxWithheld` (tuneable).
4. **Low income, high refund** (optional): `ReportedIncome < 20000 AND RefundRequested > 3000`.
5. **Withholding missing** (optional): `TaxWithheld = 0 AND RefundRequested > 0`.

> Adjust thresholds per policy or historical data. The point is explainability.

---

## 🧮 Risk Scoring (Simple, Explainable)
Each triggered rule adds points:

| Rule | Points |
|---|---|
| Duplicate SSN | +50 |
| Excessive Deductions | +30 |
| Refund > 1.5× Withheld | +25 |
| Low Income, High Refund | +15 |
| Withholding Missing | +10 |

**RiskLevel**:
- `85+ = High`, `50–84 = Medium`, `<50 = Low`

---

## 🚀 Quickstart (SQLite)

### Create DB & Tables
```sql
.read sql/00_create_tables.sql

2) Load sample Data
```sql
.read sql/01_load_sample_data.sql

3) Genrate Flags and Scores
.read sql/02_rules_flags.sql
.read sql/03_risk_scoring.sql
.read sql/04_export_views.sql

4) See Results
SELECT * FROM v_refund_risk;

5) Export for Excel or BI
sqlite3 refund.db -header -csv "SELECT * FROM v_refund_risk;" > data/refund_risk.csv


