#include <stdio.h>
#include <string.h>

// First string
char a[] = "ABC";

// Second string
char b[] = "AC";

// DP table for storing LCS lengths
int dp[10][10];

int main()
{
    // Length of first string
    int n = strlen(a);

    // Length of second string
    int m = strlen(b);

    // Build DP table
    for(int i = 0; i <= n; i++)
    {
        for(int j = 0; j <= m; j++)
        {
            // Base Case:
            // If either string is empty,
            // LCS length is 0
            if(i == 0 || j == 0)
            {
                dp[i][j] = 0;
            }

            // If characters match
            else if(a[i - 1] == b[j - 1])
            {
                dp[i][j] =
                dp[i - 1][j - 1] + 1;
            }

            // If characters do not match
            else
            {
                dp[i][j] =
                dp[i - 1][j] > dp[i][j - 1]
                ?
                dp[i - 1][j]
                :
                dp[i][j - 1];
            }
        }
    }

    printf("Length of Longest Common Subsequence = %d\n",
           dp[n][m]);

    return 0;
}