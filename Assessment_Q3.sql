/*Question 3: Account Inactivity Alert*/

SELECT
    p.id AS plan_id,
    p.owner_id,
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS 'type',
    DATE(MAX(sa.transaction_date)) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(sa.transaction_date)) AS days_inactive
FROM
    plans_plan p
LEFT JOIN
    savings_savingsaccount sa ON p.id = sa.plan_id
JOIN
    users_customuser u ON p.owner_id = u.id  -- Join to check active users
WHERE
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)
AND u.is_active = 1
GROUP BY
    p.id, p.owner_id, type
HAVING
    days_inactive > 365
ORDER BY
    days_inactive DESC;