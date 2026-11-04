# Project : Customer Account Balance Analysis

## Project Details

**Goal:** Analyse how much money customers hold across accounts, by account type, city, balance category and customer.

**Questions answered**
- What is the total, average, minimum and maximum balance?
- How do Savings and Current accounts compare?
- Which cities hold the most money?
- How many accounts are Low, Medium or High balance?
- Who are the top 5 accounts, and what is each customer's total balance?

**Program:** `account_balance_analysis.sas` (Part A creates the data, Part B runs the analysis)

## Data Details

**Dataset 1:** `BANK.CUSTOMERS` - 12 rows, one per customer.

| Variable | Type | Description |
|----------|------|-------------|
| `cust_id` | Numeric | Unique customer ID |
| `name` | Character | Customer first name |
| `gender` | Character | M or F |
| `age` | Numeric | Age in years |
| `city` | Character | City of residence |
| `occupation` | Character | Customer occupation |
| `join_date` | Numeric (date) | Date the customer joined the bank |

**Dataset 2:** `BANK.ACCOUNTS` - 14 rows, one per account. A customer can have more than one account.

| Variable | Type | Description |
|----------|------|-------------|
| `acct_id` | Numeric | Unique account ID |
| `cust_id` | Numeric | Links to `BANK.CUSTOMERS` |
| `acct_type` | Character | Savings or Current |
| `balance` | Numeric | Current balance in INR |

## SAS Keywords / Procedures Used

| Keyword | Purpose in this project |
|---------|-------------------------|
| 
| `PROC FORMAT` (`VALUE`) | Group balances into Low, Medium and High |
| `PROC SQL` (`CREATE TABLE`, `INNER JOIN`, `GROUP BY`, `ORDER BY`, `COUNT`, `SUM`) | Join accounts to customers and total balance per customer |
| `PROC MEANS` (`CLASS`, `VAR`) | Balance statistics overall, by account type and by city |
| `PROC FREQ` (`TABLES`, `FORMAT`) | Count accounts per balance category |
| `PROC SORT` (`BY DESCENDING`, `OUT=`) | Sort accounts from highest to lowest balance |
| `PROC PRINT` (`OBS=`, `NOOBS`, `VAR`) | Show the top 5 accounts |
| `PROC SGPLOT` (`VBAR`, `RESPONSE=`, `STAT=SUM`) | Chart total balance by account type |
| `TITLE` | Add headings to output |
| `ods pdf` | to print the output |

## Dataset Source

The data is **synthetic (fictional)**, created with `DATALINES`. It contains no real customer information.
