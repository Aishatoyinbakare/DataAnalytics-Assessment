/*Question 4: Customer Lifetime Value (CLV) Estimation*/

SELECT
    u.id AS customer_id,
   CONCAT(u.first_name, ' ', u.last_name) AS name,
    TIMESTAMPDIFF(MONTH, MIN(sa.created_on), CURDATE()) AS tenure_months,
    COUNT(sa.id) AS total_transactions,
   ROUND(
    CASE
        WHEN COUNT(sa.id) = 0 OR TIMESTAMPDIFF(MONTH, MIN(sa.created_on), CURDATE()) <= 0 THEN 0
        ELSE (
            (COUNT(sa.id) /
             CASE
                 WHEN TIMESTAMPDIFF(MONTH, MIN(sa.created_on), CURDATE()) <= 0 THEN 1
                 ELSE TIMESTAMPDIFF(MONTH, MIN(sa.created_on), CURDATE())
             END
            ) * 12 * COALESCE(AVG(sa.confirmed_amount / 100), 0) * 0.001
        )
    END,
    2
) AS estimated_clv
FROM
    users_customuser u
JOIN
    savings_savingsaccount sa ON u.id = sa.owner_id
GROUP BY
    u.id, u.first_name, u.last_name
ORDER BY
    estimated_clv DESC;