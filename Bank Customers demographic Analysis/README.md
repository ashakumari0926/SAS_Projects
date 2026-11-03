# Project : Bank Customer Demographic Analysis

## Project Details

**Goal:** Understand who the bank's customers are by looking at their gender, age, city and occupation.

**Questions answered**
- How many customers are male and female?
- Which cities and occupations are most common?
- What is the average, minimum and maximum customer age?
- How do age groups split by gender?

**Program:** `customer_demographics.sas` (Part A creates the data, Part B runs the analysis)

## Data Details

**Dataset:** `BANK.CUSTOMERS` - 12 rows, one per customer.

| Variable | Type | Description |
|----------|------|-------------|
| `cust_id` | Numeric | Unique customer ID |
| `name` | Character | Customer first name |
| `gender` | Character | M or F |
| `age` | Numeric | Age in years |
| `city` | Character | City of residence (Pune, Mumbai, Nashik, Nagpur, Thane) |
| `occupation` | Character | Customer occupation |
| `join_date` | Numeric (date) | Date the customer joined the bank |

## SAS Keywords / Procedures Used

| Keyword | Purpose in this project |
|---------|-------------------------|
| `DATA`, `INFILE`, `INPUT`, `DATALINES` | Create the dataset from in-program data |
| `FORMAT`, `LABEL` | Display dates properly and give variables readable names |
| `PROC FORMAT` (`VALUE`) | Create age groups (Under 30, 30 to 44, ...) |
| `PROC PRINT` (`OBS=`, `LABEL`) | Preview the data |
| `PROC FREQ` (`TABLES`) | Frequency counts and age group by gender cross-tab |
| `PROC MEANS` (`VAR`, `CLASS`) | Age statistics, overall and by gender |
| `PROC SGPLOT` (`VBAR`) | Bar chart of customers by city |
| `TITLE` | Add headings to output |

## Dataset Source

The data is **synthetic (fictional)**, created with `DATALINES`. It contains no real customer information.

