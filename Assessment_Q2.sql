/*Question 2: Transaction Frequency Analysis*/

WITH UserMonthlyTransactions AS (
    SELECT
        u.id AS user_id,
        COUNT(sa.id) / (TIMESTAMPDIFF(MONTH, MIN(sa.transaction_date), CURDATE()) + 1) AS avg_monthly_transactions
    FROM
        users_customuser u
    JOIN
        savings_savingsaccount sa ON u.id = sa.owner_id
    GROUP BY
        u.id
),
FrequencyCategorizedUsers AS (
    SELECT
        CASE
            WHEN umt.avg_monthly_transactions >= 10 THEN 'High Frequency'
            WHEN umt.avg_monthly_transactions BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        umt.user_id
    FROM
        UserMonthlyTransactions umt
)
SELECT
    fcu.frequency_category,
    COUNT(DISTINCT fcu.user_id) AS customer_count,
    round(AVG(umt.avg_monthly_transactions), 2) AS avg_transactions_per_month
FROM
    FrequencyCategorizedUsers fcu
JOIN
    UserMonthlyTransactions umt ON fcu.user_id = umt.user_id
GROUP BY
    fcu.frequency_category
ORDER BY
    avg_transactions_per_month DESC;