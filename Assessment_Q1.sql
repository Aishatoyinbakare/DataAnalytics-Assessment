/*Question 1: High-Value Customers with Multiple Products*/
SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN sa.plan_id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN sa.plan_id END) AS investment_count,
    round(SUM(sa.confirmed_amount / 100),2) AS total_deposits /*To convert to naira*/
FROM
    users_customuser u
    JOIN 
        savings_savingsaccount sa ON u.id = sa.owner_id
	JOIN 
        plans_plan p ON p.id = sa.plan_id
WHERE (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY
    u.id, u.first_name, u.last_name
HAVING
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN sa.plan_id END) >= 1
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN sa.plan_id END) >= 1
ORDER BY
    total_deposits DESC;

