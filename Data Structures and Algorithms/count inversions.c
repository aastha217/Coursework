#include <stdio.h>

int main()
{
    int arr[] = {8,4,2,1};

    int n = 4;

    int count = 0;

    // Check every pair
    for(int i=0;i<n;i++)
    {
        for(int j=i+1;j<n;j++)
        {
            if(arr[i] > arr[j])
            {
                count++;
            }
        }
    }

    printf("Inversions = %d",
           count);

    return 0;
}