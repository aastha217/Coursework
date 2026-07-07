/*
Table: activity

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| user_id      | int     |
| action_date  | date    |
| action       | varchar |
+--------------+---------+
(user_id, action_date, action) is the primary key (unique value) for this table.
Each row represents a user performing a specific action on a given date.
Write a solution to identify behaviorally stable users based on the following definition:

A user is considered behaviorally stable if there exists a sequence of at least 5 consecutive days such that:
The user performed exactly one action per day during that period.
The action is the same on all those consecutive days.
If a user has multiple qualifying sequences, only consider the sequence with the maximum length.
Return the result table ordered by streak_length in descending order, then by user_id in ascending order.

The result format is in the following example.

 

Example:

Input:

activity table:

+---------+-------------+--------+
| user_id | action_date | action |
+---------+-------------+--------+
| 1       | 2024-01-01  | login  |
| 1       | 2024-01-02  | login  |
| 1       | 2024-01-03  | login  |
| 1       | 2024-01-04  | login  |
| 1       | 2024-01-05  | login  |
| 1       | 2024-01-06  | logout |
| 2       | 2024-01-01  | click  |
| 2       | 2024-01-02  | click  |
| 2       | 2024-01-03  | click  |
| 2       | 2024-01-04  | click  |
| 3       | 2024-01-01  | view   |
| 3       | 2024-01-02  | view   |
| 3       | 2024-01-03  | view   |
| 3       | 2024-01-04  | view   |
| 3       | 2024-01-05  | view   |
| 3       | 2024-01-06  | view   |
| 3       | 2024-01-07  | view   |
+---------+-------------+--------+
Output:

+---------+--------+---------------+------------+------------+
| user_id | action | streak_length | start_date | end_date   |
+---------+--------+---------------+------------+------------+
| 3       | view   | 7             | 2024-01-01 | 2024-01-07 |
| 1       | login  | 5             | 2024-01-01 | 2024-01-05 |
+---------+--------+---------------+------------+------------+
Explanation:

User 1:
Performed login from 2024-01-01 to 2024-01-05 on consecutive days
Each day has exactly one action, and the action is the same
Streak length = 5 (meets minimum requirement)
The action changes on 2024-01-06, ending the streak
User 2:
Performed click for only 4 consecutive days
Does not meet the minimum streak length of 5
Excluded from the result
User 3:
Performed view for 7 consecutive days
This is the longest valid sequence for this user
Included in the result
The Results table is ordered by streak_length in descending order, then by user_id in ascending order

*/

WITH cte AS (
    SELECT
        *,
        LAG(action) OVER(PARTITION BY user_id
                    ORDER BY action_date) AS previous_action
    FROM activity
),
cte1 AS (
    SELECT
        *,
        CASE WHEN action <> cte.previous_action
             THEN 1 ELSE 0 END AS change_check
    FROM cte
),
cte2 AS (
    SELECT
        *,
        SUM(change_check) OVER(PARTITION BY user_id
                          ORDER BY action_date) AS streak_group
    FROM cte1
),
result AS (
    SELECT
        user_id,
        action,
        COUNT(*) AS streak_length,
        MIN(action_date) AS start_date,
        MAX(action_date) AS end_date
    FROM cte2
    GROUP BY user_id, action, streak_group
    HAVING COUNT(*) >= 5
),
streak_rank AS (
    SELECT 
        *,
        ROW_NUMBER() OVER(PARTITION BY user_id
                     ORDER BY streak_length DESC) AS rn
    FROM result
)
SELECT
    user_id,
    action,
    streak_length,
    start_date,
    end_date
FROM streak_rank
WHERE rn = 1 -- Longest streak if multiple streaks exist
ORDER BY 3 DESC, 1;



