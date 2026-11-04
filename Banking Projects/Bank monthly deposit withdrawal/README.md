# Project 4: Monthly Deposit and Withdrawal Analysis

## Project Details

**Goal:** Compare total deposits and withdrawals month by month and find the net cash flow (deposits minus withdrawals).

**Questions answered**
- How much was deposited and withdrawn each month?
- Which months had positive or negative net cash flow?
- What is the overall trend from January to June 2026?

**Program:** `04_monthly_deposit_withdrawal.sas` (Part A creates the data, Part B runs the analysis)

## Data Details

**Dataset:** `BANK.TRANSACTIONS` - 40 rows, one per transaction, January to June 2026.

| Variable | Type | Description |
|----------|------|-------------|
| `txn_id` | Numeric | Unique transaction ID |
| `acct_id` | Numeric | Account ID |
| `txn_date` | Numeric (date) | Date of the transaction |
| `txn_type` | Character | Deposit or Withdrawal |
| `amount` | Numeric | Amount in INR |

**Derived datasets created while running:** `WORK.TXN_MONTH` (adds a `month` variable), `WORK.MONTHLY_SUM` (totals by month and type), `WORK.MONTHLY_WIDE` and `WORK.MONTHLY_NET` (one row per month with Deposit, Withdrawal and Net_Flow).

## SAS Keywords / Procedures Used

| Keyword | Purpose in this project |
|---------|-------------------------|
| `%LET`, `LIBNAME` | Set the folder path and create library `BANK` |
| `DATA`, `SET`, `INFILE`, `INPUT`, `DATALINES` | Create and read datasets |
| `INTNX` | Convert each date to the first day of its month |
| `FORMAT` (`MONYY7.`, `COMMA12.2`) | Show months and amounts in a readable form |
| `PROC MEANS` (`CLASS`, `VAR`, `NWAY`, `NOPRINT`, `OUTPUT OUT=`) | Total amount by month and transaction type |
| `PROC TRANSPOSE` (`BY`, `ID`, `VAR`, `OUT=`) | Turn Deposit and Withdrawal into columns |
| `IF ... THEN`, `MISSING()` | Replace missing totals with 0 |
| Assignment statement | Calculate `Net_Flow = Deposit - Withdrawal` |
| `PROC PRINT` (`VAR`, `SUM`, `NOOBS`, `LABEL`) | Monthly report with column totals |
| `PROC SGPLOT` (`VBAR`, `GROUP=`, `GROUPDISPLAY=CLUSTER`) | Grouped bar chart of deposits vs withdrawals |
| `PROC SGPLOT` (`SERIES`, `REFLINE`) | Net cash flow trend line with a zero line |
| `TITLE` | Add headings to output |

## Dataset Source

The data is **synthetic (fictional)**, created by the project author for learning and typed directly into the program with `DATALINES`. It contains no real customer information.

To practise with real data, you can search public sources such as Kaggle (https://www.kaggle.com/datasets), the UCI Machine Learning Repository (https://archive.ics.uci.edu) or Data.gov (https://data.gov). Check each dataset's licence and credit it here if used.

## How to Run

1. Upload `04_monthly_deposit_withdrawal.sas` to SAS (for example SAS OnDemand for Academics).
2. Change `%let proj_path = ...;` to your own folder.
3. Submit the whole file.
