# Project : Bank Transaction Analysis

## Project Details

**Goal:** Study how customers use their accounts - transaction types, sizes, most active accounts and the largest transactions.

**Questions answered**
- How many deposits and withdrawals were made?
- What are the total, average, minimum and maximum amounts for each type?
- How many transactions are Small, Medium or Large?
- Which accounts are most active?
- Who made the 5 largest transactions?

**Program:** `transaction_analysis.sas` (Part A creates the data, Part B runs the analysis)

## Data Details

**Dataset 1:** `BANK.CUSTOMERS` - 12 rows, one per customer (`cust_id`, `name`, `gender`, `age`, `city`, `occupation`, `join_date`).

**Dataset 2:** `BANK.ACCOUNTS` - 14 rows, one per account.

| Variable | Type | Description |
|----------|------|-------------|
| `acct_id` | Numeric | Unique account ID |
| `cust_id` | Numeric | Links to `BANK.CUSTOMERS` |
| `acct_type` | Character | Savings or Current |
| `balance` | Numeric | Current balance in INR |

**Dataset 3:** `BANK.TRANSACTIONS` - 40 rows, one per transaction, January to June 2026.

| Variable | Type | Description |
|----------|------|-------------|
| `txn_id` | Numeric | Unique transaction ID |
| `acct_id` | Numeric | Links to `BANK.ACCOUNTS` |
| `txn_date` | Numeric (date) | Date of the transaction |
| `txn_type` | Character | Deposit or Withdrawal |
| `amount` | Numeric | Amount in INR |

## SAS Keywords / Procedures Used

| Keyword | Purpose in this project |
|---------|-------------------------|
| `%LET`, `LIBNAME` | Set the folder path and create library `BANK` |
| `DATA`, `SET`, `INFILE`, `INPUT`, `DATALINES` | Create and read datasets |
| `LENGTH` | Set the length of the new `size_flag` variable |
| `IF / ELSE IF / THEN` | Label each transaction Small, Medium or Large |
| `PROC PRINT` (`OBS=`, `LABEL`) | Preview the transactions |
| `PROC FREQ` (`TABLES`, `NOPERCENT`, `NOROW`, `NOCOL`) | Count by type and size-by-type cross-tab |
| `PROC MEANS` (`CLASS`, `VAR`) | Amount statistics by transaction type |
| `PROC SQL` (`INNER JOIN`, `GROUP BY`, `ORDER BY`, `COUNT`, `SUM`, `OUTOBS=`) | Activity per account and top 5 transactions with customer name |
| `PROC SGPLOT` (`VBAR`, `RESPONSE=`, `STAT=SUM`) | Chart total amount by transaction type |
| `TITLE` | Add headings to output |
| `ods odf` | Export SAS output, including tables and charts, into a PDF file |
| `ODS PDF CLOSE` | Close and save the generated PDF file |

## Dataset Source

The data is **synthetic (fictional)**, created with `DATALINES`. It contains no real customer information.

