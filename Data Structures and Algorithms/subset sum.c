#include <stdio.h>

int main()
{
    int set[] = {3,34,4,12,5,2};

    int sum = 9;

    int n = 6;

    int dp[7][10];

    for(int i=0;i<=n;i++)
    {
        dp[i][0] = 1;
    }

    for(int j=1;j<=sum;j++)
    {
        dp[0][j] = 0;
    }

    for(int i=1;i<=n;i++)
    {
        for(int j=1;j<=sum;j++)
        {
            if(set[i-1] <= j)
            {
                dp[i][j] =
                dp[i-1][j] ||
                dp[i-1][j-set[i-1]];
            }
            else
            {
                dp[i][j] =
                dp[i-1][j];
            }
        }
    }

    if(dp[n][sum])
        printf("Subset Exists");
    else
        printf("Subset Does Not Exist");

    return 0;
}