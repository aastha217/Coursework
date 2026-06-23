#include <stdio.h>

// Number of keys in the Optimal Binary Search Tree
int n = 3;

// Frequencies (search probabilities) of keys
int p[3] = {3, 2, 4};

// Cost table
// cost[i][j] stores minimum search cost
// for keys from i to j
int cost[3][3];

// Function to construct Optimal BST
void obst()
{
    // Cost of a single key is its frequency
    for(int i = 0; i < n; i++)
    {
        cost[i][i] = p[i];
    }

    // L = Length of subtree
    for(int L = 2; L <= n; L++)
    {
        // Starting index
        for(int i = 0; i <= n - L; i++)
        {
            // Ending index
            int j = i + L - 1;

            // Initialize with infinity
            cost[i][j] = 9999;

            // Calculate sum of frequencies
            int sum = 0;

            for(int k = i; k <= j; k++)
            {
                sum += p[k];
            }

            // Try every key as root
            for(int k = i; k <= j; k++)
            {
                // Cost of left subtree
                int left =
                (k > i)
                ?
                cost[i][k - 1]
                :
                0;

                // Cost of right subtree
                int right =
                (k < j)
                ?
                cost[k + 1][j]
                :
                0;

                // Total cost
                int c =
                left +
                right +
                sum;

                // Store minimum cost
                if(c < cost[i][j])
                {
                    cost[i][j] = c;
                }
            }
        }
    }
}

int main()
{
    // Construct Optimal BST
    obst();

    printf("Minimum Cost of OBST = %d\n",
           cost[0][n - 1]);

    return 0;
}