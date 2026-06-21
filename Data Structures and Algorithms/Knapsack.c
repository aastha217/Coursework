#include <stdio.h>

// Number of items
int n = 3;

// Maximum capacity of knapsack
int W = 5;

// Weight of each item
int wt[3] = {2, 3, 4};

// Value (profit) of each item
int val[3] = {3, 4, 5};

// DP table
// Rows    -> Items
// Columns -> Knapsack Capacity
int dp[4][6];

// Function to solve 0/1 Knapsack Problem
void knap()
{
    // Build DP table
    for(int i = 0; i <= n; i++)
    {
        for(int w = 0; w <= W; w++)
        {
            // Base Case:
            // No items or zero capacity
            if(i == 0 || w == 0)
            {
                dp[i][w] = 0;
            }

            // If current item's weight
            // is less than or equal to capacity
            else if(wt[i - 1] <= w)
            {
                // Include current item
                int include =
                val[i - 1] +
                dp[i - 1][w - wt[i - 1]];

                // Exclude current item
                int exclude =
                dp[i - 1][w];

                // Store maximum profit
                dp[i][w] =
                include > exclude ?
                include : exclude;
            }

            // Item cannot be included
            else
            {
                dp[i][w] =
                dp[i - 1][w];
            }
        }
    }
}

int main()
{
    // Solve Knapsack Problem
    knap();

    printf("Maximum Profit = %d\n",
           dp[n][W]);

    return 0;
}