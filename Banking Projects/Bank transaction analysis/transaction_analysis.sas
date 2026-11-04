/*====================================================================
  Program  : Transaction_analysis.sas
  Project 3: Bank Transaction Analysis
  Purpose  : Study transaction behaviour - types, amounts, busiest accounts and largest transactions.
  Input    : work.CUSTOMERS, work.ACCOUNTS, work.TRANSACTIONS (created in Part A of this file)
  Note     : Data is fictional (synthetic) and made for learning.
             
====================================================================*/

/*====================== PART A: CREATE DATA =========================*/

/*--------------------------------------------------------------------
  CUSTOMERS dataset: one row per customer
--------------------------------------------------------------------*/
data work.customers;
    infile datalines dlm=' ' truncover;
    input cust_id name :$12. gender :$1. age city :$10.
          occupation :$12. join_date :date9.;
    format join_date date9.;
    label cust_id    = "Customer ID"
          name       = "Customer Name"
          gender     = "Gender"
          age        = "Age (years)"
          city       = "City"
          occupation = "Occupation"
          join_date  = "Date Joined Bank";
datalines;
1 Amit M 34 Pune Engineer 15JAN2018
2 Priya F 28 Mumbai Teacher 20MAR2019
3 Rahul M 45 Nashik Businessman 11JUL2015
4 Sneha F 39 Pune Doctor 05SEP2017
5 Vikram M 52 Nagpur Retired 23FEB2012
6 Anjali F 23 Mumbai Student 14AUG2022
7 Karan M 31 Pune Engineer 30NOV2020
8 Neha F 41 Thane Accountant 17APR2016
9 Rohit M 29 Nashik Clerk 09JUN2021
10 Pooja F 36 Mumbai Teacher 25OCT2018
11 Suresh M 58 Nagpur Retired 12DEC2010
12 Meera F 26 Pune Student 03MAY2023
;
run;

/*--------------------------------------------------------------------
  ACCOUNTS dataset: one row per account (a customer may have many)
--------------------------------------------------------------------*/
data work.accounts;
    infile datalines dlm=' ' truncover;
    input acct_id cust_id acct_type :$8. balance;
    format balance comma12.2;
    label acct_id   = "Account ID"
          cust_id   = "Customer ID"
          acct_type = "Account Type"
          balance   = "Current Balance (INR)";
datalines;
101 1 Savings 45000
102 1 Current 120000
103 2 Savings 23000
104 3 Current 560000
105 3 Savings 210000
106 4 Savings 98000
107 5 Savings 150000
108 6 Savings 5200
109 7 Savings 67000
110 8 Savings 88000
111 9 Savings 12500
112 10 Savings 41000
113 11 Savings 175000
114 12 Savings 3100
;
run;

/*--------------------------------------------------------------------
  TRANSACTIONS dataset: one row per deposit / withdrawal
--------------------------------------------------------------------*/
data work.transactions;
    infile datalines dlm=' ' truncover;
    input txn_id acct_id txn_date :date9. txn_type :$10. amount;
    format txn_date date9. amount comma12.2;
    label txn_id   = "Transaction ID"
          acct_id  = "Account ID"
          txn_date = "Transaction Date"
          txn_type = "Transaction Type"
          amount   = "Amount (INR)";
datalines;
1001 101 05JAN2026 Deposit 10000
1002 101 18JAN2026 Withdrawal 4000
1003 102 22JAN2026 Deposit 50000
1004 103 03JAN2026 Deposit 8000
1005 104 10JAN2026 Deposit 200000
1006 104 28JAN2026 Withdrawal 75000
1007 105 15JAN2026 Deposit 30000
1008 106 07FEB2026 Deposit 15000
1009 106 19FEB2026 Withdrawal 6000
1010 107 02FEB2026 Withdrawal 12000
1011 108 14FEB2026 Deposit 2500
1012 109 21FEB2026 Deposit 9000
1013 110 25FEB2026 Withdrawal 5000
1014 101 06MAR2026 Deposit 12000
1015 102 12MAR2026 Withdrawal 20000
1016 103 16MAR2026 Withdrawal 3500
1017 104 20MAR2026 Deposit 150000
1018 105 27MAR2026 Withdrawal 18000
1019 111 04MAR2026 Deposit 4000
1020 112 09MAR2026 Deposit 6500
1021 113 13APR2026 Deposit 25000
1022 113 24APR2026 Withdrawal 10000
1023 114 02APR2026 Deposit 1200
1024 109 11APR2026 Withdrawal 4500
1025 110 18APR2026 Deposit 14000
1026 107 29APR2026 Deposit 22000
1027 101 08MAY2026 Deposit 9500
1028 104 15MAY2026 Withdrawal 90000
1029 106 21MAY2026 Deposit 11000
1030 108 26MAY2026 Withdrawal 1800
1031 111 30MAY2026 Withdrawal 2500
1032 112 05JUN2026 Withdrawal 7000
1033 102 12JUN2026 Deposit 60000
1034 103 17JUN2026 Deposit 5000
1035 105 23JUN2026 Deposit 40000
1036 107 27JUN2026 Withdrawal 9000
1037 109 03JUN2026 Deposit 13000
1038 113 19JUN2026 Deposit 18000
1039 110 28JUN2026 Withdrawal 6500
1040 114 14JUN2026 Deposit 900
;
run;

/*====================== PART B: ANALYSIS ============================*/

/*--------------------------------------------------------------------
  Step 1: Preview the transactions
--------------------------------------------------------------------*/
option nodate;
ods pdf file ="D:/project/2.SAS/transaction analysis report.pdf" startpage =no;
proc print data=work.transactions (obs=10) label;
    title "Project: Transaction Analysis - Data Preview";
run;

/*--------------------------------------------------------------------
  Step 2: How many deposits vs withdrawals?
--------------------------------------------------------------------*/
proc freq data=work.transactions;
    tables txn_type;
    title "Number of Transactions by Type";
run;

/*--------------------------------------------------------------------
  Step 3: Amount statistics by transaction type
--------------------------------------------------------------------*/
proc means data=work.transactions n sum mean median min max maxdec=2;
    class txn_type;
    var amount;
    title "Transaction Amount Summary by Type";
run;

/*--------------------------------------------------------------------
  Step 4: Flag transactions by size using a DATA step
          (50,000 or more = Large, 10,000 or more = Medium)
--------------------------------------------------------------------*/
data work.txn_flagged;
    set work.transactions;
    length size_flag $8;
    if amount >= 50000 then size_flag = "Large";
    else if amount >= 10000 then size_flag = "Medium";
    else size_flag = "Small";
run;

proc freq data=work.txn_flagged;
    tables size_flag*txn_type / nopercent norow nocol;
    title "Transaction Size by Type";
run;

/*--------------------------------------------------------------------
  Step 5: Number of transactions and total value per account
--------------------------------------------------------------------*/
proc sql;
    title "Transaction Activity per Account";
    select acct_id,
           count(*)       as num_txns,
           sum(amount)    as total_amount format=comma12.2
    from work.transactions
    group by acct_id
    order by num_txns desc, total_amount desc;
quit;

/*--------------------------------------------------------------------
  Step 6: Top 5 largest transactions with customer name
--------------------------------------------------------------------*/
proc sql outobs=5;
    title "Top 5 Largest Transactions";
    select t.txn_id,
           t.txn_date,
           t.txn_type,
           t.amount format=comma12.2,
           c.name
    from work.transactions as t
         inner join work.accounts  as a on t.acct_id = a.acct_id
         inner join work.customers as c on a.cust_id = c.cust_id
    order by t.amount desc;
quit;

/*--------------------------------------------------------------------
  Step 7: Chart - total amount by transaction type
--------------------------------------------------------------------*/
proc sgplot data=work.transactions;
    vbar txn_type / response=amount stat=sum datalabel;
    yaxis label="Total Amount (INR)";
    xaxis label="Transaction Type";
    title "Total Transaction Amount by Type";
run;

title;
ods pdf close;