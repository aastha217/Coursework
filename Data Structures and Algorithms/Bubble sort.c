#include <stdio.h>

// Function to perform Bubble Sort
void bubbleSort(int arr[], int n)
{
    // Perform n-1 passes
    for(int i = 0; i < n - 1; i++)
    {
        // Compare adjacent elements
        for(int j = 0; j < n - i - 1; j++)
        {
            // Swap if elements are in wrong order
            if(arr[j] > arr[j + 1])
            {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int main()
{
    int arr[] = {64, 34, 25, 12, 22, 11, 90};

    int n = sizeof(arr) / sizeof(arr[0]);

    bubbleSort(arr, n);

    printf("Sorted Array:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    return 0;
}