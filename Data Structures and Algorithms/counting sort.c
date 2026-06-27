#include <stdio.h>

// Function to perform Counting Sort
void countingSort(int arr[], int n)
{
    int max = arr[0];

    // Find maximum element
    for(int i = 1; i < n; i++)
    {
        if(arr[i] > max)
        {
            max = arr[i];
        }
    }

    // Count array
    int count[max + 1];

    for(int i = 0; i <= max; i++)
    {
        count[i] = 0;
    }

    // Store frequency of each element
    for(int i = 0; i < n; i++)
    {
        count[arr[i]]++;
    }

    int index = 0;

    // Reconstruct sorted array
    for(int i = 0; i <= max; i++)
    {
        while(count[i] > 0)
        {
            arr[index++] = i;
            count[i]--;
        }
    }
}

int main()
{
    int arr[] = {4, 2, 2, 8, 3, 3, 1};

    int n = sizeof(arr) / sizeof(arr[0]);

    countingSort(arr, n);

    printf("Sorted Array:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    return 0;
}