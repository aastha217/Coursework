#include <stdio.h>

// Function to perform Recursive Binary Search
int binarySearchRec(int arr[],
                    int low,
                    int high,
                    int key)
{
    // Base Case:
    // Element not found
    if(low > high)
        return -1;

    // Find middle index
    int mid = (low + high) / 2;

    // If key is found
    if(arr[mid] == key)
        return mid;

    // Search in right half
    else if(arr[mid] < key)
        return binarySearchRec(
            arr,
            mid + 1,
            high,
            key
        );

    // Search in left half
    else
        return binarySearchRec(
            arr,
            low,
            mid - 1,
            key
        );
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

    // Input element to search
    printf("Enter key to search: ");
    scanf("%d", &key);

    // Call Recursive Binary Search
    int index =
    binarySearchRec(
        arr,
        0,
        n - 1,
        key
    );

    // Display result
    if(index != -1)
    {
        printf("Element found at index %d\n",
               index);
    }
    else
    {
        printf("Element not found\n");
    }

    return 0;
}