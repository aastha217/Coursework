#include <stdio.h>

int main()
{
    int arr[] =
    {10,22,9,33,21,50,41,60};

    int n = 8;

    int lis[8];

    for(int i=0;i<n;i++)
    {
        lis[i] = 1;
    }

    for(int i=1;i<n;i++)
    {
        for(int j=0;j<i;j++)
        {
            if(arr[i] > arr[j] &&
               lis[i] < lis[j] + 1)
            {
                lis[i] =
                lis[j] + 1;
            }
        }
    }

    int max = lis[0];

    for(int i=1;i<n;i++)
    {
        if(lis[i] > max)
        {
            max = lis[i];
        }
    }

    printf("LIS Length = %d",
           max);

    return 0;
}