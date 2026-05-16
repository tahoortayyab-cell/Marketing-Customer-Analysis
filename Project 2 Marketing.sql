Create Database Marketing;
use Marketing;
select * from marketing_customers;


-- 1. Which states have the highest average Customer Lifetime Value, and how
 --   many customers does each state have? Sort by average CLV descending.
 
select state, ROUND( avg(`Customer Lifetime Value`),  2) as Customer_Lifetime_Value, 
 count(*) as `total customer`
from marketing_customers
group by state
order by  Customer_Lifetime_Value 
desc;

-- 2. Compare customers who responded Yes to the marketing offer versus No — what is
--  the difference in their average income and average Customer Lifetime Value?

select Response, avg(Income), avg(`Customer Lifetime Value`)
from marketing_customers
group by Response;

-- 3. For each coverage type (Basic, Extended, Premium) — how many customers are enrolled and
--  what is the total claim amount per coverage type?

Select Coverage, count(*) as `Customer Enrolled`,
ROUND( Sum(`Total Claim Amount`) , 2) as `Total Claim Amount`
from marketing_customers
group by Coverage;

-- 4. Which sales channel (Agent, Call Center, Web, Branch) generates 
-- the highest average Customer Lifetime Value?

Select `Sales Channel`, 
ROUND(AVG(`Customer Lifetime Value`) , 2) as `highest avg CLV`
FROM marketing_customers
group by `Sales Channel`
Order by `highest avg CLV` DESC;
 
-- 5. Compare male and female customers — what is the 
--  average Monthly Premium Auto and average Total Claim Amount for each gender?

Select Gender, ROUND(AVG(`Monthly Premium Auto`), 2)
 as ` AVG Monthly Premium Auto`,
ROUND(AVG(`Total Claim Amount`), 2) 
as `AVG Total Claim Amount`
from marketing_customers 
group by Gender;

-- 6. How many customers belong to each education level, and what is
--  their average income? Sort by average income descending.

Select Education, Count(*) as `Total Customers`,
ROUND(AVG(Income) , 2) as `AVG Income`
from marketing_customers 
GROUP BY Education 
ORDER BY `AVG Income`
DESC;

-- 7. What is the average Customer Lifetime Value for Employed 
-- customers compared to Unemployed customers?

Select EmploymentStatus,
 ROUND(AVG(`Customer Lifetime Value`), 2)
 as `AVG Customer Lifetime Value`
from marketing_customers 
WHERE EmploymentStatus IN ('Employed', 'Unemployed') 
GROUP BY EmploymentStatus;

-- 8. How many customers have open complaints, and what is their average Customer Lifetime 
-- Value compared to customers with zero complaints?

Select 
CASE 
WHEN  `Number of Open Complaints` = 0 THEN 'No Complaints'
ELSE 'Has Complaints'
END as `Complaint Status`,
 count(*) as `Total Customers`,
ROUND(AVG(`Customer Lifetime Value`), 2) 
as `AVG Customer Lifetime Value` 
from marketing_customers 
GROUP BY  `Complaint Status`;

-- 9. For each Policy Type, who are the top 3
--  customers by Customer Lifetime Value?

WITH CTE AS(
Select `Policy Type`, Customer,
 ROUND(`Customer Lifetime Value`, 2)
 as `Customer Lifetime Value`,
 RANK() OVER(PARTITION BY `Policy Type`
ORDER BY `Customer Lifetime Value` DESC )
 as rnk
from marketing_customers )
select * from CTE
where rnk<=3
ORDER BY  `Policy Type`, 
`Customer Lifetime Value` DESC;

-- 10. For each Renew Offer Type, what percentage of
 -- customers responded Yes to the marketing offer?

WITH CTE AS (
    SELECT 
        `Renew Offer Type`,
        COUNT(*) AS total_customers,

        SUM(
            CASE 
                WHEN Response='Yes' THEN 1
                ELSE 0
            END
        ) AS yes_response

    FROM marketing_customers
    GROUP BY `Renew Offer Type`
)
SELECT *,
       ROUND(yes_response / total_customers * 100, 2) AS percentage
FROM CTE;

-- 11. Which state has the highest response rate to marketing offers? 

WITH CTE AS (
    SELECT 
        `State`,
        COUNT(*) AS total_customers,

        SUM(
            CASE 
                WHEN Response='Yes' THEN 1
                ELSE 0
            END
        ) AS yes_response

    FROM marketing_customers
    GROUP BY `State`
)
SELECT *,
       ROUND(yes_response / total_customers * 100, 2) AS percentage
FROM CTE
ORDER BY percentage DESC;

-- 12. What is the average Customer Lifetime Value for 
-- each combination of Gender and Marital Status? 

Select Gender, `Marital Status`, 
ROUND(AVG(`Customer Lifetime Value`) , 2) 
 as `AVG Customer Lifetime Value`
FROM marketing_customers
GROUP BY Gender, `Marital Status` ;

-- 13. Which vehicle class has the highest average 
-- Monthly Premium Auto? Sort descending.

Select `Vehicle Class`, 
ROUND(AVG(`Monthly Premium Auto`), 2) as `AVG Monthly Premium Auto`
from marketing_customers 
GROUP BY `Vehicle Class`
ORDER BY `AVG Monthly Premium Auto`
DESC;


-- 14. How many customers have more than 5 policies, 
-- and what is their average Customer Lifetime Value?

Select COUNT(*) as `Customer`,
ROUND(AVG(`Customer Lifetime Value`) , 2) 
as ` AVG Customer Lifetime Value`
from marketing_customers
WHERE `Number of Policies` >5 




















