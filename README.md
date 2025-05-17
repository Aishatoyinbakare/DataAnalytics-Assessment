Per-Question Explanations:

1. High-Value Customers with Multiple Products:

For this question, my goal was to identify those valuable customers who have shown engagement with more than one type of product – specifically, both a savings and an investment plan. I approached this by joining the `users_customuser`, `savings_savingsaccount`, and `plans_plan` tables to link customer information with their account activity and the type of plan.

The key was to count the *distinct* savings plans and investment plans each user holds. I used conditional counting with `CASE` statements inside `COUNT(DISTINCT ...)` to achieve this. Finally, the `HAVING` clause allowed me to filter out only those customers who met the criteria of having at least one distinct savings plan and at least one distinct investment plan. The results were then ordered by their total deposits to highlight the highest-value customers in this cross-selling segment.

2. Transaction Frequency Analysis:

Here, the objective was to segment customers based on how frequently they transact. My approach involved a two-step process using Common Table Expressions (CTEs).

First, I calculated the average number of transactions per customer per month. This required finding the total transaction count and dividing it by the customer's tenure in months (calculated from their first transaction date). I added a small buffer of '+ 1' to the tenure calculation to handle cases where the first transaction might have been in the current month, preventing potential division-by-zero issues.

In the second CTE, I used a `CASE` statement to categorize these average monthly transaction counts into "High Frequency," "Medium Frequency," and "Low Frequency" segments as defined in the task. Finally, I aggregated the results to count the number of customers in each segment and calculated the average transaction frequency for each segment, ordering them by this average.

3. Account Inactivity Alert:

This question focused on identifying accounts that have shown inactivity over a significant period. My approach was to find active users who hold either a savings or an investment plan by joining with the `users_customuser` table and filtering on `u.is_active = 1`, and then determine if they've had any transaction within the last year (365 days).

I used a `LEFT JOIN` from the `plans_plan` table to the `savings_savingsaccount` table, specifically looking for transactions within the last year in the `ON` clause. Then, by grouping by the plan details and using a `HAVING MAX(sa.transaction_date) IS NULL`, I could filter for plans where no transaction was found in that recent period. This effectively flags accounts with no activity in the last year. I also included the overall `last_transaction_date` and `inactivity_days` to provide context on when the account was last active.

4. Customer Lifetime Value (CLV) Estimation:

For this task, I implemented the simplified CLV model provided. The calculation involved several components: account tenure, total transactions, and average profit per transaction.

I calculated the tenure in months from the customer's first transaction. The average profit per transaction was derived by taking 0.1% of the average transaction value. The core CLV formula was then applied, annualizing the monthly transaction rate and multiplying by the average profit.

To make the calculation robust, I included `CASE` statements to handle scenarios where a customer might have zero transactions or zero tenure, assigning a CLV of 0 in such cases to prevent errors. I also used `COALESCE` to handle potential `NULL` values in the average transaction amount. The final CLV was rounded to two decimal places for clarity, and the results were ordered from highest to lowest CLV.

Challenges:

One of the main challenges I encountered was ensuring the "Account Inactivity Alert" query precisely matched the requirement of "no transactions in the last 1 year." Initially, I might have leaned towards finding accounts with a last transaction date older than a year. However, the use of a `LEFT JOIN` combined with checking for the absence of recent transactions in the `HAVING` clause proved to be a more direct and accurate way to identify accounts with no activity within that specific timeframe.

Another area that required careful consideration was handling potential `NULL` values, particularly in the CLV calculation. For instance, when calculating the average transaction amount or the tenure, a customer might have no transactions, leading to `NULL` results from aggregate functions. Using `COALESCE` and `CASE` statements helped to gracefully handle these scenarios and prevent `NULL` values from propagating through the CLV calculation, ensuring a more robust and meaningful output.

Finally, ensuring the grouping and aggregation were correct for each question was crucial. For example, in the cross-selling analysis, it was important to count *distinct* plans per user, requiring the use of `COUNT(DISTINCT ...)`. In the transaction frequency analysis, the two-step CTE approach allowed for a clear separation of the per-user calculation from the overall segmentation and aggregation.
