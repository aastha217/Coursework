#include <stdio.h>

// Function to heapify a subtree
void heapify(int arr[], int n, int i)
{
    int largest = i;

    int left = 2 * i + 1;
    int right = 2 * i + 2;

    // Check left child
    if(left < n &&
       arr[left] > arr[largest])
    {
        largest = left;
    }

    // Check right child
    if(right < n &&
       arr[right] > arr[largest])
    {
        largest = right;
    }

    // Swap and heapify again if needed
    if(largest != i)
    {
        int temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;

        heapify(arr, n, largest);
    }
}

// Heap Sort Function
void heapSort(int arr[], int n)
{
    // Build Max Heap
    for(int i = n/2 - 1; i >= 0; i--)
    {
        heapify(arr, n, i);
    }

    // Extract elements one by one
    for(int i = n - 1; i > 0; i--)
    {
        int temp = arr[0];
        arr[0] = arr[i];
        arr[i] = temp;

        heapify(arr, i, 0);
    }
}

int main()
{
    int arr[] = {12, 11, 13, 5, 6, 7};

    int n = sizeof(arr) / sizeof(arr[0]);

    heapSort(arr, n);

    printf("Sorted Array:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    return 0;
}