#include <stdio.h>

// Function to perform Selection Sort
void selectionSort(int arr[], int n)
{
    for(int i = 0; i < n - 1; i++)
    {
        // Assume current element is minimum
        int minIndex = i;

        // Find smallest element
        for(int j = i + 1; j < n; j++)
        {
            if(arr[j] < arr[minIndex])
            {
                minIndex = j;
            }
        }

        // Swap smallest element with current position
        int temp = arr[i];
        arr[i] = arr[minIndex];
        arr[minIndex] = temp;
    }
}

int main()
{
    int arr[] = {29, 10, 14, 37, 13};

    int n = sizeof(arr) / sizeof(arr[0]);

    selectionSort(arr, n);

    printf("Sorted Array:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    return 0;
}