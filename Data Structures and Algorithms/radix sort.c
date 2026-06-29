#include <stdio.h>

// Function to find the largest element in the array
int getMax(int arr[], int n)
{
    int max = arr[0];

    for(int i = 1; i < n; i++)
    {
        if(arr[i] > max)
        {
            max = arr[i];
        }
    }

    return max;
}

// Counting Sort for a specific digit place
void countSort(int arr[], int n, int exp)
{
    int output[100];
    int count[10] = {0};

    // Count occurrences of digits
    for(int i = 0; i < n; i++)
    {
        count[(arr[i] / exp) % 10]++;
    }

    // Convert count array into cumulative count
    for(int i = 1; i < 10; i++)
    {
        count[i] += count[i - 1];
    }

    // Build output array
    for(int i = n - 1; i >= 0; i--)
    {
        int digit = (arr[i] / exp) % 10;

        output[count[digit] - 1] = arr[i];

        count[digit]--;
    }

    // Copy sorted values back to original array
    for(int i = 0; i < n; i++)
    {
        arr[i] = output[i];
    }
}

// Radix Sort Function
void radixSort(int arr[], int n)
{
    // Find maximum number
    int max = getMax(arr, n);

    // Apply counting sort for every digit
    for(int exp = 1; max / exp > 0; exp *= 10)
    {
        countSort(arr, n, exp);
    }
}

int main()
{
    int arr[] = {170, 45, 75, 90, 802, 24, 2, 66};

    int n = sizeof(arr) / sizeof(arr[0]);

    radixSort(arr, n);

    printf("Sorted Array:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", arr[i]);
    }

    return 0;
}