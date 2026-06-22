#include <stdio.h>

// Function to perform Iterative Binary Search
int binarySearchIter(int arr[], int n, int key)
{
    // Initialize low and high indices
    int low = 0;
    int high = n - 1;

    // Continue searching while valid range exists
    while(low <= high)
    {
        // Find middle index
        int mid = (low + high) / 2;

        // Key found
        if(arr[mid] == key)
            return mid;

        // Search in right half
        else if(arr[mid] < key)
            low = mid + 1;

        // Search in left half
        else
            high = mid - 1;
    }

    // Key not found
    return -1;
}

int main()
{
    int n, key;

    // Input size of array
    printf("Enter size of array: ");
    scanf("%d", &n);

    int arr[50];

    // Input sorted array elements
    printf("Enter sorted array:\n");
    for(int i = 0; i < n; i++)
    {
        scanf("%d", &arr[i]);
    }

    // Input key to search
    printf("Enter key to search: ");
    scanf("%d", &key);

    // Call Binary Search function
    int index = binarySearchIter(arr, n, key);

    // Display result
    if(index != -1)
        printf("Element found at index %d\n", index);
    else
        printf("Element not found\n");

    return 0;
}