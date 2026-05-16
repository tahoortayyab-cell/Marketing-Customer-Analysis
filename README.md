# 📊 Marketing Customer Analysis — SQL Project

## Project Overview

This project performs exploratory data analysis on a marketing customers dataset using MySQL. The goal is to extract meaningful business insights about customer behavior, lifetime value, sales channels, demographics, and marketing response rates.

- **Database:** Marketing  
- **Table:** marketing_customers  
- **Tool Used:** MySQL Workbench  
- **Total Queries:** 14  

---

## Dataset Description

The `marketing_customers` table contains customer-level insurance and marketing data including:

| Column | Description |
|---|---|
| Customer | Unique customer ID |
| State | Customer's state |
| Customer Lifetime Value | Total projected revenue from customer |
| Response | Whether customer responded to marketing offer (Yes/No) |
| Coverage | Insurance coverage type (Basic, Extended, Premium) |
| Sales Channel | Channel through which policy was sold |
| Gender | Customer gender |
| Income | Annual income |
| Education | Education level |
| EmploymentStatus | Employment status |
| Number of Open Complaints | Count of open complaints |
| Policy Type | Type of auto policy |
| Renew Offer Type | Type of renewal offer sent |
| Monthly Premium Auto | Monthly premium amount |
| Total Claim Amount | Total insurance claims |
| Marital Status | Customer marital status |
| Vehicle Class | Class of vehicle insured |
| Number of Policies | Number of policies held |

---

## Queries & Results

### Q1. Which states have the highest average Customer Lifetime Value?

**Objective:** Identify top-performing states by average CLV and customer count, sorted descending.

```sql
SELECT state, 
       ROUND(AVG(`Customer Lifetime Value`), 2) AS Customer_Lifetime_Value, 
       COUNT(*) AS `total customer`
FROM marketing_customers
GROUP BY state
ORDER BY Customer_Lifetime_Value DESC;
```

**Result:**

| State | AVG CLV | Total Customers |
|---|---|---|
| Oregon | 8077.90 | 2601 |
| Nevada | 8056.71 | 882 |
| Washington | 8021.47 | 798 |
| California | 8003.65 | 3150 |
| Arizona | 7861.34 | 1703 |

**Insight:** Oregon has the highest average CLV despite not having the most customers.

---

### Q2. Yes vs No Response — Average Income & CLV Comparison

**Objective:** Compare average income and CLV between customers who responded Yes vs No.

```sql
SELECT Response, 
       AVG(Income), 
       AVG(`Customer Lifetime Value`)
FROM marketing_customers
GROUP BY Response;
```

**Result:**

| Response | AVG Income | AVG CLV |
|---|---|---|
| No | 37509.19 | 8030.02 |
| Yes | 38544.03 | 7854.87 |

**Insight:** Customers who responded Yes have slightly higher income but lower average CLV.

---

### Q3. Customer Enrollment & Total Claims by Coverage Type

**Objective:** Count customers and total claim amount per coverage type.

```sql
SELECT Coverage, 
       COUNT(*) AS `Customer Enrolled`,
       ROUND(SUM(`Total Claim Amount`), 2) AS `Total Claim Amount`
FROM marketing_customers
GROUP BY Coverage;
```

**Result:**

| Coverage | Customers Enrolled | Total Claim Amount |
|---|---|---|
| Basic | 5568 | 2,110,474.19 |
| Extended | 2742 | 1,317,747.30 |
| Premium | 824 | 536,745.56 |

**Insight:** Basic coverage dominates in both enrollment and total claims.

---

### Q4. Sales Channel with Highest Average CLV

**Objective:** Identify which sales channel generates the highest average Customer Lifetime Value.

```sql
SELECT `Sales Channel`, 
       ROUND(AVG(`Customer Lifetime Value`), 2) AS `highest avg CLV`
FROM marketing_customers
GROUP BY `Sales Channel`
ORDER BY `highest avg CLV` DESC;
```

**Result:**

| Sales Channel | Highest AVG CLV |
|---|---|
| Branch | 8119.71 |
| Call Center | 8100.09 |
| Agent | 7957.71 |
| Web | 7779.79 |

**Insight:** Branch channel generates the highest average CLV, while Web generates the lowest.

---

### Q5. Gender Comparison — Monthly Premium & Total Claims

**Objective:** Compare average Monthly Premium Auto and Total Claim Amount by gender.

```sql
SELECT Gender, 
       ROUND(AVG(`Monthly Premium Auto`), 2) AS `AVG Monthly Premium Auto`,
       ROUND(AVG(`Total Claim Amount`), 2) AS `AVG Total Claim Amount`
FROM marketing_customers
GROUP BY Gender;
```

**Result:**

| Gender | AVG Monthly Premium | AVG Total Claim |
|---|---|---|
| F | 93.09 | 412.86 |
| M | 93.36 | 456.18 |

**Insight:** Males have slightly higher premiums and significantly higher average claims than females.

---

### Q6. Customer Count & Average Income by Education Level

**Objective:** Analyze customer distribution and income across education levels, sorted by income descending.

```sql
SELECT Education, 
       COUNT(*) AS `Total Customers`,
       ROUND(AVG(Income), 2) AS `AVG Income`
FROM marketing_customers
GROUP BY Education
ORDER BY `AVG Income` DESC;
```

**Result:**

| Education | Total Customers | AVG Income |
|---|---|---|
| Master | 741 | 44768.19 |
| Doctor | 342 | 42353.13 |
| Bachelor | 2748 | 37426.81 |
| College | 2681 | 37357.17 |
| High School or Below | 2622 | 35583.93 |

**Insight:** Higher education levels correlate with higher average income, as expected.

---

### Q7. Employed vs Unemployed — Average CLV

**Objective:** Compare average CLV between employed and unemployed customers.

```sql
SELECT EmploymentStatus,
       ROUND(AVG(`Customer Lifetime Value`), 2) AS `AVG Customer Lifetime Value`
FROM marketing_customers
WHERE EmploymentStatus IN ('Employed', 'Unemployed')
GROUP BY EmploymentStatus;
```

**Result:**

| Employment Status | AVG CLV |
|---|---|
| Employed | 8219.12 |
| Unemployed | 7636.32 |

**Insight:** Employed customers have a notably higher average CLV than unemployed customers.

---

### Q8. Open Complaints — Customer Count & AVG CLV

**Objective:** Compare customers with zero complaints vs those with open complaints.

```sql
SELECT 
    CASE 
        WHEN `Number of Open Complaints` = 0 THEN 'No Complaints'
        ELSE 'Has Complaints'
    END AS `Complaint Status`,
    COUNT(*) AS `Total Customers`,
    ROUND(AVG(`Customer Lifetime Value`), 2) AS `AVG Customer Lifetime Value`
FROM marketing_customers
GROUP BY `Complaint Status`;
```

**Result:**

| Complaint Status | Total Customers | AVG CLV |
|---|---|---|
| No Complaints | 7252 | 8058.82 |
| Has Complaints | 1882 | 7797.32 |

**Insight:** Customers with no complaints have a higher average CLV than those with open complaints.

---

### Q9. Top 3 Customers by CLV for Each Policy Type

**Objective:** Use Window Functions (RANK + CTE) to find top 3 customers per policy type.

```sql
WITH CTE AS (
    SELECT `Policy Type`, Customer,
           ROUND(`Customer Lifetime Value`, 2) AS `Customer Lifetime Value`,
           RANK() OVER (PARTITION BY `Policy Type` 
                        ORDER BY `Customer Lifetime Value` DESC) AS rnk
    FROM marketing_customers
)
SELECT * FROM CTE
WHERE rnk <= 3
ORDER BY `Policy Type`, `Customer Lifetime Value` DESC;
```

**Result:**

| Policy Type | Customer | CLV | Rank |
|---|---|---|---|
| Corporate Auto | US30122 | 61134.68 | 1 |
| Corporate Auto | CL79250 | 52811.49 | 2 |
| Corporate Auto | KB44286 | 46770.95 | 3 |
| Personal Auto | FQ61281 | 83325.38 | 1 |
| Personal Auto | YC54142 | 74228.52 | 2 |
| Personal Auto | BP23267 | 73225.96 | 3 |
| Special Auto | CP85232 | 44795.47 | 1 |
| Special Auto | GW14109 | 38496.95 | 2 |
| Special Auto | ZI86917 | 38320.82 | 3 |

**Insight:** Personal Auto customers dominate with the highest individual CLV values.

---

### Q10. Response Rate by Renew Offer Type

**Objective:** Calculate what percentage of customers said Yes to each renewal offer type.

```sql
WITH CTE AS (
    SELECT `Renew Offer Type`,
           COUNT(*) AS total_customers,
           SUM(CASE WHEN Response = 'Yes' THEN 1 ELSE 0 END) AS yes_response
    FROM marketing_customers
    GROUP BY `Renew Offer Type`
)
SELECT *, ROUND(yes_response / total_customers * 100, 2) AS percentage
FROM CTE;
```

**Result:**

| Renew Offer Type | Total Customers | Yes Response | Percentage |
|---|---|---|---|
| Offer1 | 3752 | 594 | 15.83% |
| Offer2 | 2926 | 684 | 23.38% |
| Offer3 | 1432 | 30 | 2.09% |
| Offer4 | 1024 | 0 | 0.00% |

**Insight:** Offer2 has the highest response rate at 23.38%. Offer4 had zero responses.

---

### Q11. State with Highest Marketing Response Rate

**Objective:** Find which state has the highest percentage of Yes responses.

```sql
WITH CTE AS (
    SELECT State,
           COUNT(*) AS total_customers,
           SUM(CASE WHEN Response = 'Yes' THEN 1 ELSE 0 END) AS yes_response
    FROM marketing_customers
    GROUP BY State
)
SELECT *, ROUND(yes_response / total_customers * 100, 2) AS percentage
FROM CTE
ORDER BY percentage DESC;
```

**Result:**

| State | Total Customers | Yes Response | Percentage |
|---|---|---|---|
| California | 3150 | 456 | 14.48% |
| Oregon | 2601 | 376 | 14.46% |
| Arizona | 1703 | 243 | 14.27% |
| Nevada | 882 | 124 | 14.06% |
| Washington | 798 | 109 | 13.66% |

**Insight:** California has the highest response rate at 14.48%, while Washington has the lowest.

---

### Q12. AVG CLV by Gender and Marital Status

**Objective:** Analyze CLV across all gender and marital status combinations.

```sql
SELECT Gender, `Marital Status`,
       ROUND(AVG(`Customer Lifetime Value`), 2) AS `AVG Customer Lifetime Value`
FROM marketing_customers
GROUP BY Gender, `Marital Status`;
```

**Result:**

| Gender | Marital Status | AVG CLV |
|---|---|---|
| F | Divorced | 8309.09 |
| M | Divorced | 8168.35 |
| F | Married | 8094.65 |
| M | Married | 8061.67 |
| F | Single | 7972.48 |
| M | Single | 7482.42 |

**Insight:** Divorced females have the highest average CLV. Single males have the lowest.

---

### Q13. Vehicle Class by Highest Average Monthly Premium

**Objective:** Rank vehicle classes by average monthly premium, descending.

```sql
SELECT `Vehicle Class`,
       ROUND(AVG(`Monthly Premium Auto`), 2) AS `AVG Monthly Premium Auto`
FROM marketing_customers
GROUP BY `Vehicle Class`
ORDER BY `AVG Monthly Premium Auto` DESC;
```

**Result:**

| Vehicle Class | AVG Monthly Premium |
|---|---|
| Luxury SUV | 213.18 |
| Luxury Car | 212.12 |
| Sports Car | 121.88 |
| SUV | 120.16 |
| Four-Door Car | 77.42 |
| Two-Door Car | 76.93 |

**Insight:** Luxury vehicles (SUV and Car) have significantly higher premiums than standard vehicles.

---

### Q14. Customers with More Than 5 Policies

**Objective:** Count customers holding more than 5 policies and find their average CLV.

```sql
SELECT COUNT(*) AS `Customer`,
       ROUND(AVG(`Customer Lifetime Value`), 2) AS `AVG Customer Lifetime Value`
FROM marketing_customers
WHERE `Number of Policies` > 5;
```

**Result:**

| Total Customers | AVG CLV |
|---|---|
| 1605 | 7108.54 |

**Insight:** 1605 customers hold more than 5 policies with an average CLV of 7108.54 — lower than the overall average, suggesting high policy count does not necessarily mean high value.

---

## Key Takeaways

- **Oregon** leads in average Customer Lifetime Value among all states.
- **Branch** sales channel generates the highest average CLV.
- **Basic** coverage has the most enrolled customers and highest total claims.
- **Offer2** renewal type has the best marketing response rate (23.38%).
- **Employed** customers significantly outperform unemployed in CLV.
- **Luxury SUVs** carry the highest average monthly premiums.
- **Divorced females** have the highest CLV across gender-marital combinations.
- Customers with **no complaints** have higher CLV than those with open complaints.

---


**Author:** Tahoor Tayyab  
**GitHub:** github.com/tahoortayyab-cell  
**LinkedIn:** linkedin.com/in/tahoor-tayyab

**SQL Project — Marketing Customer Analysis**  
Tool: MySQL Workbench  
Dataset: marketing_customers
