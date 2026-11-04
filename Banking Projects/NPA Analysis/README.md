# Non-Performing Asset (NPA) Analysis

Description : PROC SQL, Statistical Analysis, Risk Assessment and Data Visualization using SAS.

**Project Overview:**

This project analyzes Non-Performing Assets (NPAs) in a simulated loan portfolio using SAS. It focuses on measuring asset quality, evaluating credit risk, understanding provisioning requirements, and identifying factors associated with loan defaults.

The analysis combines PROC SQL, descriptive statistics, hypothesis testing, and logistic regression to generate insights into loan portfolio performance.
## Project Details

**Goal:** To measure and explain Non-Performing Assets in a loan portfolio by analyzing NPA ratios, asset classification, provisioning requirements, and risk drivers across different sectors, branches, and security types.

**Key Business Questions**
What are the Gross NPA and Net NPA ratios of the loan portfolio?
Which sectors and branches have the highest NPA ratios?
Are unsecured loans more likely to become NPAs compared to secured loans?
How much provision is required for each asset classification?
Which are the largest NPA accounts based on outstanding loan amounts?
Which factors increase the likelihood of an account becoming an NPA?
How do loan characteristics such as sector, security type, and outstanding amount influence NPA risk?

**Key financial terms**

**NPA Flag:** A loan account is classified as an NPA when the repayment is overdue by more than 90 days.
**Gross NPA Ratio:** Gross NPA / Total Advances × 100.
**Net NPA:** Gross NPA minus provisions held against NPAs.
**Net NPA Ratio:** Net NPA / (Total Advances − NPA Provisions) × 100.
**Provisioning:** The amount set aside to cover potential credit losses arising from non-performing loans.

**Important:** The asset classifications (Standard, Sub-Standard, Doubtful, and Loss) and corresponding provisioning rates used in this project are simplified and illustrative for learning purposes. They do not represent exact regulatory provisioning requirements.

**SAS Program:** `Non_Performing_Asset_NPA_Analysis.sas` 
The program is divided into two parts:

Part A – Data Generation: Creates a synthetic loan portfolio using SAS random-number functions.
Part B – Data Analysis: Performs NPA calculations, asset classification, provisioning analysis, statistical testing, logistic regression, and visualization.

## Data Details

**Dataset:** `WORK.ADVANCES` 
**Dataset Size:** - 400 observations (one observation per loan account).

| Variable | Type | Description |
|----------|------|-------------|
| `loan_id` | Numeric | Unique loan ID |
| `sector` | Character | Agriculture, MSME, Retail or Corporate |
| `branch` | Character | Pune, Mumbai, Nashik, Nagpur or Thane |
| `security` | Character | Secured or Unsecured |
| `outstanding` | Numeric | Outstanding amount (INR) |
| `outstanding_lakh` | Numeric | Outstanding in lakh (INR 100,000 each) |
| `days_past_due` | Numeric | Number of days the loan repayment is overdue |
| `npa_flag` | Numeric | 1 if days past due is more than 90,otherwise 0 |
| `asset_class` | Numeric | 1 = Standard, 2 = Sub-Standard, 3 = Doubtful, 4 = Loss (illustrative) |
| `prov_rate` | Numeric | Illustrative provisioning rate based on asset classification |
| `provision` | Numeric | Provision amount calculated in INR |

**Note**: The dataset is synthetically generated and contains no actual customer or banking information.

## SAS Keywords / Procedures Used

| Keyword | Purpose in this project |
|---------|-------------------------|
| `PROC FORMAT` (`VALUE`) | Assigns descriptive labels to asset classes and Yes/No indicators |
| `CALL STREAMINIT`, `RAND("uniform" / "bernoulli")` | Initializes the random-number generator for reproducible data generation |
| `RAND("UNIFORM"), RAND("BERNOULLI")` | 	Generates random values and binary outcomes |
| `DO` loop, `IF/ELSE IF`, `CHOOSE()`, `IFC()` | Build accounts and classify assets |
| `PROC CONTENTS`, `PROC PRINT` | Structure and preview |
| `PROC SQL`: `GROUP BY`, `ORDER BY`, `CASE WHEN`, `CALCULATED`, `OUTOBS=`, `WHERE` | Gross/Net NPA ratios, sector and branch NPA, provisioning, top NPA accounts |
| `PROC MEANS` (`CLASS`, `VAR`) | Statistics for NPA vs standard accounts |
| `PROC UNIVARIATE` (`WHERE`, `HISTOGRAM`) | Analyzes the distribution of days past due among NPA accounts |
| `PROC FREQ` (`CHISQ`) | Performs frequency analysis and Chi-square tests for NPA status against sector and security type |
| `PROC LOGISTIC` (`CLASS`, `PARAM=REF`, `REF=`, `EVENT=`, `LACKFIT`) | Uses logistic regression to examine factors associated with the likelihood of an account becoming an NPA |
| `PROC SGPLOT` (`VBAR`) | 	Creates visualizations to communicate NPA trends and portfolio risk |

**Analytical Techniques Applied**
Financial Analysis: Calculation of Gross NPA, Net NPA, and provisioning requirements.
Comparative Analysis: Identification of high-risk sectors, branches, and security categories.
Descriptive Statistics: Comparison of outstanding amounts and overdue days between NPA and standard accounts.
Hypothesis Testing: Chi-square tests to examine associations between NPA status and categorical variables.
Predictive Analysis: Logistic regression to evaluate the relationship between loan characteristics and NPA probability.
Data Visualization: Charts to present portfolio performance and risk distribution.

**Output and Key Insights**
Note: All numerical results below are randomly created sample values for demonstration purposes only. 
1. Portfolio-Level NPA Analysis
Writing

## Output and Key Insights

**Note: All numerical results below are randomly created sample values for demonstration purposes only.**

### 1\. Portfolio-Level NPA Analysis
 
| Metric                    | Result          |
| Total Loan Accounts       | 400             |
| Total Advances (INR)      | ₹2,410,301,000  |
| Total Gross NPA (INR)     | ₹207,411,000    |
| Gross NPA Ratio (%)       | 8.61%           |
| Total NPA Provision (INR) | ₹39,671,650     |
| Net NPA (INR)             | ₹167,739,350    |
| Net NPA Ratio (%)         | 7.08%           |

**Key Insight:** The portfolio recorded a Gross NPA ratio of **8.61%** and a Net NPA ratio of **7.08%**, indicating that a considerable portion of the simulated loan portfolio is classified as non-performing.

### 2\. Sector-Wise NPA Analysis

### Sector-Wise NPA Analysis

| Sector      | Accounts   | Advances (INR) | Gross NPA (INR) | GNPA Ratio (%) |
| Agriculture | 88         | 42,651,000     | 8,815,000       | 20.67% |
| MSME        | 101        | 268,510,000    | 37,373,000      | 13.92% |
| Corporate   | 67         | 1,863,545,000  | 155,397,000     | 8.34% |
| Retail      | 144        | 235,595,000    | 5,826,000       | 2.47% |

Key Insights:

- Agriculture recorded the highest GNPA ratio of 20.67%, indicating the highest proportion of non-performing advances relative to total advances in this sector.
- MSME followed with a GNPA ratio of 13.92%, highlighting potential credit-risk concerns.
- Corporate had the highest Gross NPA amount of ₹155,397,000, despite a relatively lower GNPA ratio of 8.34%, due to its significantly larger loan portfolio.
- Retail recorded the lowest GNPA ratio of 2.47%, indicating comparatively better asset quality.

Note: GNPA Ratio (%) = (Gross NPA / Total Advances) × 100. The analysis is based on a synthetic loan portfolio and is intended for illustrative purposes only.

**Key Insight:** The Agriculture sector recorded the highest NPA ratio of **20.67%**, followed by MSME at **13.92%**. 

### 3\. Branch-Wise NPA Analysis

| Branch | Accounts | NPA Accounts | Gross NPA (INR) | GNPA Ratio (%) |
| Nashik | 88       | 10           | 65,951,000      | 12.84%         |
| Mumbai | 83       | 8            | 40,286,000      | 10.24%         |
| Nagpur | 83       | 11           | 55,966,000      | 8.45%          |
| Thane  | 75       | 7            | 40,287,000      | 8.30%          |
| Pune   | 71       | 6            | 4,921,000       | 1.38%          |

**Key Insight:** Nashik branch reported the highest NPA ratio of **12.84%**, while Pune branch recorded the lowest at **1.38%**. This highlights Mumbai as a potential area for closer credit monitoring.

### 4\. Security-Wise NPA Analysis

| Security Type | Accounts | NPA Accounts | NPA Account Rate (%) |
| Secured       | 298      | 27           | 9.10%                |
| Unsecured     | 102      | 15           | 14.70%               |

**Key Insight:** The NPA ratio for unsecured loans was **14.70%** and **9.10%** for secured loans. This suggests that unsecured loans have a higher NPA incidence in the simulated portfolio.

### 5\. Asset Classification and Provisioning Analysis

| Asset Class  | Accounts | Outstanding (INR) | Provision Required (INR) | Effective Provision (%) |
| Standard     | 358      | 2,202,890,000     | 8,811,560                | 0.40%                   |
| Sub-Standard | 25       | 183,071,000       | 27,460,650               | 15.00%                  |
| Doubtful     | 15       | 20,215,000        | 8,086,000                | 40.00%                  |
| Loss         | 2        | 4,125,000         | 4,125,000                | 100.00%                 |

**Key Insight:** Key Insight: Standard assets accounted for the majority of the portfolio (358 accounts), with a low provisioning rate of 0.40%. The Loss category required 100% provisioning, highlighting the relationship between asset deterioration and increased provisioning requirements.

### 6\. Top NPA Accounts

| Loan ID   | Sector    | Branch  | Security Type | Outstanding (INR) | Days Past Due | Asset Classification    |
| 55        | Corporate | Nagpur  | Unsecured     | 47,244,000        | 206           | Sub-Standard            |
| 175       | Corporate | Nashik  | Secured       | 40,791,000        | 322           | Sub-Standard            |
| 72        | Corporate | Thane   | Secured       | 26,569,000        | 114           | Sub-Standard            |
| 313       | Corporate | Mumbai  | Unsecured     | 23,060,000        | 244           | Sub-Standard            |
| 320       | Corporate | Nashik  | Secured       | 12,098,000        | 225           | Sub-Standard            |
| 33        | Corporate | Nashik  | Secured       | 5,635,000         | 934           | Doubtful                |
| 293       | MSME      | Mumbai  | Unsecured     | 4,443,000         | 211           | Sub-Standard            |
| 137       | MSME      | Thane   | Unsecured     | 4,355,000         | 126           | Sub-Standard            |
| 54        | MSME      | Mumbai  | Secured       | 4,096,000         | 92            | Sub-Standard            |
| 146       | MSME      | Thane   | Secured       | 3,561,000         | 150           | Sub-Standard            |

**Key Insight:** Key Insight: Loan account **55** had the highest outstanding NPA amount of **₹47,244,000**, making it the largest NPA exposure identified in the analysis.



### 9\. Overall Business Insights

Based on the analysis, the following observations were identified:

1. Portfolio Quality: The Gross NPA ratio was 8.61%%.
2. Sector Risk: The Agriculture sector showed the highest NPA ratio of 20.67%.
3. Branch Performance: Nashik branch had the highest GNPA ratio of 12.84%.
4. Security Risk: Unsecured loans showed a higher NPA incidence (14.70%) compared to secured loans (9.10%).
5. Provisioning: The Loss asset class required the highest effective provisioning rate of 100.00%, amounting to ₹4,125,000.

### 10\. Visualizations

The following charts were generated using `PROC SGPLOT`:

- NPA Account Rate by Sector
- Outstanding Amount by Asset Classification
![alt text](image-1.png)
![alt text](image-2.png)
## Conclusion

This project demonstrates how SAS can be used to evaluate loan portfolio quality, calculate NPA ratios, estimate provisioning requirements, perform statistical hypothesis testing, and examine factors associated with credit risk.

Through PROC SQL and statistical procedures, the analysis identifies potential risk concentrations across sectors, branches, and security categories. It also demonstrates how logistic regression can help examine the relationship between loan characteristics and NPA occurrence.
