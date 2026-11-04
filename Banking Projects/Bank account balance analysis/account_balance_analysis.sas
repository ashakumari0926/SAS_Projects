/*====================================================================
  Program  : account_balance_analysis.sas
  Project  : Customer Account Balance Analysis
  Purpose  : Analyse account balances by account type, balance
             category, city and customer.
  Input    : CUSTOMERS, ACCOUNTS (created in Part A)
  Note     : Data is fictional (synthetic).
            
====================================================================*/

/*====================== PART A: CREATE DATA =========================*/

/*--------------------------------------------------------------------
  CUSTOMERS dataset: one row per customer
--------------------------------------------------------------------*/
data customers;
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
data accounts;
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

/*====================== PART B: ANALYSIS ============================*/

/*--------------------------------------------------------------------
  Step 1: Format to group balances into categories
--------------------------------------------------------------------*/
proc format;
    value balcat
        low -< 25000      = "Low (< 25K)"
        25000 -< 100000   = "Medium (25K - 100K)"
        100000 - high     = "High (100K+)";
run;

/*--------------------------------------------------------------------
  Step 2: Merge account data with customer details using PROC SQL
--------------------------------------------------------------------*/
proc sql;
    create table work.acct_cust as
    select a.acct_id,
           a.cust_id,
           c.name,
           c.city,
           a.acct_type,
           a.balance
    from work.accounts as a
         inner join work.customers as c
         on a.cust_id = c.cust_id;
quit;

/*--------------------------------------------------------------------
  Step 3: Overall balance statistics
--------------------------------------------------------------------*/
options nodate nonumber;
ods pdf file="/home/u39704259/Bank projects/bank_account_balance_ouput.pdf" startpage=no  ;
proc means data=work.acct_cust n sum mean median min max maxdec=2;
    var balance;
    title "Project : Overall Account Balance Summary";
run;

/*--------------------------------------------------------------------
  Step 4: Balance statistics by account type
--------------------------------------------------------------------*/
proc means data=work.acct_cust n sum mean maxdec=2;
    class acct_type;
    var balance;
    title "Balance Summary by Account Type";
run;

/*--------------------------------------------------------------------
  Step 5: Balance statistics by city
--------------------------------------------------------------------*/
proc means data=work.acct_cust n sum mean maxdec=2 nonobs;
    class city;
    var balance;
    title "Balance Summary by City";
run;

/*--------------------------------------------------------------------
  Step 6: Number of accounts in each balance category
--------------------------------------------------------------------*/
proc freq data=work.acct_cust;
    tables balance;
    format balance balcat.;
    title "Accounts by Balance Category";
run;

/*--------------------------------------------------------------------
  Step 7: Top 5 accounts by balance
--------------------------------------------------------------------*/
proc sort data=work.acct_cust out=work.acct_sorted;
    by descending balance;
run;

proc print data=work.acct_sorted (obs=5) noobs;
    var acct_id name city acct_type balance;
    title "Top 5 Accounts by Balance";
run;

/*--------------------------------------------------------------------
  Step 8: Total balance held by each customer (all accounts combined)
--------------------------------------------------------------------*/
proc sql;
    title "Total Balance per Customer";
    select name,
           count(*)        as num_accounts,
           sum(balance)    as total_balance format=comma12.2
    from work.acct_cust
    group by name
    order by total_balance desc;
quit;

/*--------------------------------------------------------------------
  Step 9: Chart - total balance by account type
--------------------------------------------------------------------*/
proc sgplot data=work.acct_cust;
    vbar acct_type / response=balance stat=sum datalabel;
    yaxis label="Total Balance (INR)";
    xaxis label="Account Type";
    title "Total Balance by Account Type";
run;

title;
ods pdf close;
