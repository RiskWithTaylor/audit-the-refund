DROP TABLE IF EXISTS TaxReturns;
CREATE TABLE TaxReturns (
  ReturnID        INTEGER PRIMARY KEY,
  SSN             TEXT NOT NULL,
  FilingStatus    TEXT NOT NULL,
  ReportedIncome  NUMERIC NOT NULL,
  ClaimedDeductions NUMERIC NOT NULL,
  TaxWithheld     NUMERIC NOT NULL,
  RefundRequested NUMERIC NOT NULL,
  TaxYear         INTEGER NOT NULL
);
