#include <stdio.h>

// Number of items
int n = 2;

// Weight of each item
float wt[2] = {10, 20};

// Value (profit) of each item
float val[2] = {60, 100};

// Array to store fraction of each item selected
float x[2] = {0};

// Capacity of knapsack
int W = 25;

int main()
{
    int i = 0;

    // Select items while capacity remains
    while(i < n && W > 0)
    {
        // If entire item can fit into knapsack
        if(wt[i] <= W)
        {
            // Take complete item
            x[i] = 1;

            // Reduce remaining capacity
            W -= wt[i];
        }
        else
        {
            // Take only required fraction
            x[i] = (float)W / wt[i];

            // Knapsack becomes full
            W = 0;
        }

        i++;
    }

    // Calculate total profit obtained
    float total =
        x[0] * val[0] +
        x[1] * val[1];

    printf("Maximum Profit = %.2f\n", total);

    return 0;
}