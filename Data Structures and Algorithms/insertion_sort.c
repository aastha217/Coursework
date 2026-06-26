#include <stdio.h>

// Function to perform Insertion Sort
void insertionSort(int arr[], int n)
{
    for(int i = 1; i < n; i++)
    {
        // Store current element
        int key = arr[i];

        int j = i - 1;

        // Shift larger elements to right
        while(j >= 0 && arr[j] > key)
        {
            arr[j + 1] = arr[j];
            j--;
        }

        // Insert key in correct position
        arr[j + 1] = key;
    }
}

int main()
{
    int arr[] = {12, 11, 13, 5, 6};

    int n = sizeof(arr) / sizeof(arr[0]);

    insertionSort(arr, n);

    printf("Sorted Array:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    return 0;
}