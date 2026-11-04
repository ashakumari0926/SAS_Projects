/*====================================================================
  Program : Non_Performing_Asset_NPA_Analysis.sas
  Project : Non-Performing Asset (NPA) Analysis (Intermediate)
  Purpose : Measure and explain Non-Performing Assets in a loan book:
            gross and net NPA ratios, asset classification,
            provisioning, and risk drivers by sector and security.
  Input   : work.ADVANCES (generated in Part A, fixed random seed)
  Note    : Data is synthetic (fictional) and made for learning.
            The 90-day rule is used to flag an NPA. Asset classes and
            provision rates are SIMPLIFIED and ILLUSTRATIVE for
            practice - they are not exact regulatory figures.
            The program is self-contained - set proj_path and run
            the whole file.
====================================================================*/

/*====================== PART A: CREATE DATA =========================*/

/*--------------------------------------------------------------------
  Formats for readable groups
--------------------------------------------------------------------*/
proc format;
    value classfmt 1 = "Standard"
                   2 = "Sub-Standard"
                   3 = "Doubtful"
                   4 = "Loss";
    value yesno    1 = "Yes"
                   0 = "No";
run;

/*--------------------------------------------------------------------
  Generate 400 synthetic loan accounts (advances).
  Loan is an NPA when days past due (DPD) is more than 90.
  NPA risk differs by sector and is higher for unsecured loans.
--------------------------------------------------------------------*/
data work.advances;
    call streaminit(2026);
    length sector $11 branch $10 security $9;
    format outstanding provision comma14. npa_flag yesno. asset_class classfmt.;

    do loan_id = 1 to 400;

        /* Sector mix: Agriculture 20%, MSME 30%, Retail 35%, Corporate 15% */
        r = rand("uniform");
        if r < 0.20 then do;
            sector      = "Agriculture";
            outstanding = round(100000 + rand("uniform") * 900000, 1000);
            base_risk   = 0.14;
        end;
        else if r < 0.50 then do;
            sector      = "MSME";
            outstanding = round(500000 + rand("uniform") * 4500000, 1000);
            base_risk   = 0.12;
        end;
        else if r < 0.85 then do;
            sector      = "Retail";
            outstanding = round(200000 + rand("uniform") * 2800000, 1000);
            base_risk   = 0.05;
        end;
        else do;
            sector      = "Corporate";
            outstanding = round(5000000 + rand("uniform") * 45000000, 1000);
            base_risk   = 0.09;
        end;

        branch   = choosec(ceil(rand("uniform") * 5),
                          "Pune", "Mumbai", "Nashik", "Nagpur", "Thane");
        security = ifc(rand("uniform") < 0.70, "Secured", "Unsecured");

        /* NPA probability = sector risk, plus 6 points if unsecured */
        p_npa    = base_risk + 0.06 * (security = "Unsecured");
        npa_flag = rand("bernoulli", p_npa);

        /* Days past due: NPAs are over 90 days, others are 0-84 days */
        if npa_flag = 1 then
            days_past_due = 91 + floor((rand("uniform") ** 2) * 1200);
        else
            days_past_due = floor(rand("uniform") * 85);

        /* Simplified asset classification based on days past due */
        if      days_past_due <= 90   then do; asset_class = 1; prov_rate = 0.004; end;
        else if days_past_due <= 365  then do; asset_class = 2; prov_rate = 0.15;  end;
        else if days_past_due <= 1095 then do; asset_class = 3; prov_rate = 0.40;  end;
        else                               do; asset_class = 4; prov_rate = 1.00;  end;

        provision = round(outstanding * prov_rate);

        /* Outstanding in lakh for modelling (1 lakh = 100,000) */
        outstanding_lakh = outstanding / 100000;

        output;
    end;
    drop r base_risk p_npa;

    label loan_id          = "Loan ID"
          sector           = "Sector"
          branch           = "Branch"
          security         = "Security Type"
          outstanding      = "Outstanding (INR)"
          outstanding_lakh = "Outstanding (INR lakh)"
          days_past_due    = "Days Past Due"
          npa_flag         = "Is NPA"
          asset_class      = "Asset Classification"
          prov_rate        = "Provision Rate (illustrative)"
          provision        = "Provision Required (INR)";
run;

/*====================== PART B: ANALYSIS ============================*/

/*--------------------------------------------------------------------
  Step 1: Structure and preview
--------------------------------------------------------------------*/
proc contents data=work.advances varnum;
    title "NPA Analysis - Dataset Structure";
run;

proc print data=work.advances (obs=10) label;
    var loan_id sector branch security outstanding days_past_due
        npa_flag asset_class;
    title "NPA Analysis - Data Preview";
run;

/*--------------------------------------------------------------------
  Step 2 (SQL): Headline NPA ratios
    Gross NPA ratio = Gross NPA / Total advances
    Net NPA         = Gross NPA - provision held on NPA accounts
    Net NPA ratio   = Net NPA / (Total advances - NPA provision)
--------------------------------------------------------------------*/
proc sql;
    title "Headline NPA Ratios";
    select count(*)  as accounts,
           sum(npa_flag) as npa_accounts,
           sum(outstanding) as total_advances format=comma16.,
           sum(case when npa_flag = 1 then outstanding else 0 end) as gross_npa format=comma16.,
           sum(case when npa_flag = 1 then provision else 0 end) as npa_provision format=comma16.,
           calculated gross_npa - calculated npa_provision  as net_npa format=comma16.,
           calculated gross_npa / calculated total_advances * 100 as gross_npa_ratio_pct format=6.2,
           calculated net_npa /(calculated total_advances - calculated npa_provision) * 100 as net_npa_ratio_pct format=6.2
    from work.advances;
quit;

/*--------------------------------------------------------------------
  Step 3 (SQL): Gross NPA ratio by sector
--------------------------------------------------------------------*/
proc sql;
    title "Gross NPA Ratio by Sector";
    select sector,
           count(*) as accounts,
           sum(outstanding) as advances format=comma16.,
           sum(case when npa_flag = 1 then outstanding else 0 end) as gross_npa format=comma16.,
           calculated gross_npa / calculated advances * 100 as gnpa_ratio_pct format=6.2
    from work.advances
    group by sector
    order by gnpa_ratio_pct desc;
quit;

/*--------------------------------------------------------------------
  Step 4 (SQL): Gross NPA ratio by branch
--------------------------------------------------------------------*/
proc sql;
    title "Gross NPA Ratio by Branch";
    select branch,
           count(*)as accounts,
           sum(npa_flag)as npa_accounts,
           sum(case when npa_flag = 1 then outstanding else 0 end) as gross_npa format=comma16.,
           calculated gross_npa / sum(outstanding) * 100 as gnpa_ratio_pct format=6.2
    from work.advances
    group by branch
    order by gnpa_ratio_pct desc;
quit;

/*--------------------------------------------------------------------
  Step 5 (SQL): Secured vs Unsecured loans
--------------------------------------------------------------------*/
proc sql;
    title "NPA by Security Type";
    select security,
           count(*)as accounts,
           sum(npa_flag) as npa_accounts,
           mean(npa_flag) * 100  as npa_account_rate_pct format=6.1
    from work.advances
    group by security;
quit;

/*--------------------------------------------------------------------
  Step 6 (SQL): Asset classification with provision required
--------------------------------------------------------------------*/
proc sql;
    title "Asset Classification and Provisioning";
    select asset_class format=classfmt. label="Asset Class",
           count(*) as accounts,
           sum(outstanding) as outstanding format=comma16.,
           sum(provision) as provision_required format=comma16.,
           calculated provision_required / calculated outstanding * 100 as effective_prov_pct format=6.2
    from work.advances
    group by asset_class
    order by asset_class;
quit;

/*--------------------------------------------------------------------
  Step 7 (SQL): Top 10 NPA accounts by outstanding amount
--------------------------------------------------------------------*/
proc sql outobs=10;
    title "Top 10 NPA Accounts by Outstanding Amount";
    select loan_id, sector, branch, security, outstanding,
           days_past_due, asset_class format=classfmt.
    from work.advances
    where npa_flag = 1
    order by outstanding desc;
quit;

/*--------------------------------------------------------------------
  Step 8 (Statistics): Days-past-due and size of NPA accounts
--------------------------------------------------------------------*/
proc means data=work.advances n mean median std min max maxdec=1 nonobs;
    class npa_flag;
    var days_past_due outstanding_lakh;
    title "Descriptive Statistics: NPA vs Standard Accounts";
run;

proc univariate data=work.advances;
    where npa_flag = 1;
    var days_past_due;
    histogram days_past_due;
    title "Distribution of Days Past Due (NPA accounts only)";
run;

/*--------------------------------------------------------------------
  Step 9 (Statistics): Chi-square tests - is NPA status related to
  sector or to security type?
--------------------------------------------------------------------*/
proc freq data=work.advances;
    tables sector*npa_flag   / chisq nopercent nocol;
    tables security*npa_flag / chisq nopercent nocol;
    title "Chi-Square Tests: NPA Status vs Sector and Security Type";
run;

/*--------------------------------------------------------------------
  Step 10 (Statistics): Logistic regression - what increases the
  odds that an account becomes an NPA?
  Reference groups: sector = Retail, security = Secured
--------------------------------------------------------------------*/
proc logistic data=work.advances;
    class sector   (param=ref ref="Retail")
          security (param=ref ref="Secured");
    model npa_flag(event="Yes") = sector security outstanding_lakh / lackfit;
    title "Logistic Regression: Drivers of NPA";
run;

/*--------------------------------------------------------------------
  Step 11: Charts
--------------------------------------------------------------------*/
proc sgplot data=work.advances;
    vbar sector / response=npa_flag stat=mean datalabel;
    yaxis label="Share of Accounts that are NPA";
    xaxis label="Sector";
    title "NPA Account Rate by Sector";
run;

proc sgplot data=work.advances;
    vbar asset_class / response=outstanding stat=sum datalabel;
    format asset_class classfmt.;
    yaxis label="Outstanding (INR)";
    xaxis label="Asset Classification";
    title "Outstanding Amount by Asset Classification";
run;

title;
