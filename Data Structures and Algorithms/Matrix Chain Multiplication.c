#include <stdio.h>

// Number of dimensions in the array p[]
// If p has n elements, then there are (n-1) matrices
int n = 4;

// Dimensions array
//
// Matrix A1 = 1 × 2
// Matrix A2 = 2 × 3
// Matrix A3 = 3 × 4
//
int p[4] = {1, 2, 3, 4};

// DP table to store minimum multiplication costs
int m[4][4];

// Function to implement Matrix Chain Multiplication
void mcm()
{
    // Cost of multiplying one matrix is 0
    for(int i = 1; i < n; i++)
    {
        m[i][i] = 0;
    }

    // L = Chain Length
    for(int L = 2; L < n; L++)
    {
        // Starting matrix
        for(int i = 1; i < n - L + 1; i++)
        {
            // Ending matrix
            int j = i + L - 1;

            // Initialize with infinity
            m[i][j] = 9999;

            // Try every possible split point
            for(int k = i; k < j; k++)
            {
                // Cost formula:
                // Cost of left chain
                // + Cost of right chain
                // + Cost of multiplying resulting matrices
                int q =
                m[i][k]
                +
                m[k + 1][j]
                +
                p[i - 1] * p[k] * p[j];

                // Update minimum cost
                if(q < m[i][j])
                {
                    m[i][j] = q;
                }
            }
        }
    }
}

int main()
{
    // Compute minimum multiplication cost
    mcm();

    printf("Minimum Multiplication Cost = %d\n",
           m[1][n - 1]);

    return 0;
}