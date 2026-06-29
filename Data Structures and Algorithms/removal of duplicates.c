#include <stdio.h>

int main()
{
    int arr[] =
    {1,1,2,2,3,4,4,5};

    int n = 8;

    int j = 0;

    // Remove duplicates
    for(int i=1;i<n;i++)
    {
        if(arr[i] != arr[j])
        {
            arr[++j] = arr[i];
        }
    }

    printf("Array Without Duplicates:\n");

    for(int i=0;i<=j;i++)
    {
        printf("%d ",arr[i]);
    }

    return 0;
}