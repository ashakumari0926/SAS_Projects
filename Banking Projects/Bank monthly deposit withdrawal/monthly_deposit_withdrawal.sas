/*====================================================================
  Program      : monthly_deposit_withdrawal.sas
  Project      : Monthly Deposit and Withdrawal Analysis
  Description  : Compare total deposits and withdrawals month by month
             and calculate the net cash flow.
  Input        : work.TRANSACTIONS (created in Part A of this file)
  Note         : Data is fictional (synthetic) and made for learning.
====================================================================*/

/*====================== PART A: CREATE DATA =========================*/

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
  Step 1: Derive a MONTH variable from the transaction date
          INTNX('month', date, 0) = first day of that month
--------------------------------------------------------------------*/
data work.txn_month;
    set work.transactions;
    month = intnx('month', txn_date, 0);
    format month monyy7.;
    label month = "Month";
run;

/*--------------------------------------------------------------------
  Step 2: Total amount by month and transaction type
--------------------------------------------------------------------*/
proc means data=work.txn_month sum noprint nway;
    class month txn_type;
    var amount;
    output out=work.monthly_sum (drop=_type_ _freq_) sum=total_amount;
run;

/*--------------------------------------------------------------------
  Step 3: Reshape - one row per month with Deposit and Withdrawal
          columns, then compute NET = Deposit - Withdrawal
--------------------------------------------------------------------*/
proc transpose data=work.monthly_sum out=work.monthly_wide (drop=_name_);
    by month;
    id txn_type;
    var total_amount;
run;

data work.monthly_net;
    set work.monthly_wide;
    /* Replace missing values (no transactions of that type) with 0 */
    if missing(Deposit)    then Deposit    = 0;
    if missing(Withdrawal) then Withdrawal = 0;
    Net_Flow = Deposit - Withdrawal;
    format Deposit Withdrawal Net_Flow comma12.2;
run;

/*--------------------------------------------------------------------
  Step 4: Print the monthly summary report
--------------------------------------------------------------------*/
option nodate;
ods pdf file="/home/u39704259/Bank projects/monthly_deposit_withdrawl.pdf" startpage=no ;
proc print data=work.monthly_net noobs label;
    var month Deposit Withdrawal Net_Flow;
    sum Deposit Withdrawal Net_Flow;
    title "Project : Monthly Deposit and Withdrawal Summary (INR)";
run;

/*--------------------------------------------------------------------
  Step 5: Chart - deposits vs withdrawals by month (grouped bars)
--------------------------------------------------------------------*/
proc sgplot data=work.monthly_sum;
    vbar month / response=total_amount group=txn_type
                 groupdisplay=cluster;
    yaxis label="Total Amount (INR)";
    xaxis label="Month";
    title "Monthly Deposits vs Withdrawals";
run;

/*--------------------------------------------------------------------
  Step 6: Chart - net cash flow trend
--------------------------------------------------------------------*/
proc sgplot data=work.monthly_net;
    series x=month y=Net_Flow / markers;
    refline 0 / axis=y lineattrs=(pattern=dash);
    yaxis label="Net Flow (INR)";
    xaxis label="Month";
    title "Monthly Net Cash Flow (Deposits - Withdrawals)";
run;

title;
ods pdf close;