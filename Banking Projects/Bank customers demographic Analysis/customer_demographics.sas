/*====================================================================
  Program  : customer_demographics.sas
  Project  : Bank Customer Demographic Analysis
  Purpose  : Understand who the bank's customers are - gender, age,
             city and occupation.
  Input    : CUSTOMERS (created in Part A of this file)
  Note     : Data is fictional (synthetic) and made for practice.
            
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

/*====================== PART B: ANALYSIS ============================*/

/*--------------------------------------------------------------------
  Step 1: Create age groups using a user-defined FORMAT
--------------------------------------------------------------------*/
proc format;
    value agegrp
        low -< 30 = "Under 30"
        30  -< 45 = "30 to 44"
        45  -< 60 = "45 to 59"
        60 - high = "60 and above";
run;

/*--------------------------------------------------------------------
  Step 2: Preview the data
--------------------------------------------------------------------*/
ods pdf file="D:\project\SAS\bank-sas-project\customer_demographics" startpage=no ;

proc print data=customers (obs=5) label;
    title "Project : Customer Demographics - Data Preview";
run;

/*--------------------------------------------------------------------
  Step 3: Gender, city and occupation distribution (frequency counts)
--------------------------------------------------------------------*/
proc freq data=customers;
    tables gender city occupation;
    title "Distribution of Customers by Gender, City and Occupation";
run;

/*--------------------------------------------------------------------
  Step 4: Age statistics (mean, median, min, max)
--------------------------------------------------------------------*/
proc means data=customers n mean median min max maxdec=1;
    var age;
    title "Age Summary of Bank Customers";
run;

/*--------------------------------------------------------------------
  Step 5: Average age by gender
--------------------------------------------------------------------*/
proc means data=customers n mean maxdec=1 nonobs;
    class gender;
    var age;
    title "Average Customer Age by Gender";
run;

/*--------------------------------------------------------------------
  Step 6: Age group x Gender cross-tabulation
--------------------------------------------------------------------*/
proc freq data=customers;
    tables age*gender / nocol nopercent;
    format age agegrp.;
    title "Age Group by Gender";
run;

/*--------------------------------------------------------------------
  Step 7: Simple bar chart - customers by city
--------------------------------------------------------------------*/
proc sgplot data=customers;
    vbar city / datalabel;
    xaxis label="City";
    yaxis label="Number of Customers";
    title "Number of Customers by City";
run;

title;
ods pdf close;