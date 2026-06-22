#include <stdio.h>

int binarySearchIter(int arr[], int n, int key) {
    int low = 0, high = n - 1;

    while(low <= high) {
        int mid = (low + high) / 2;

        if(arr[mid] == key)
            return mid;    
        else if(arr[mid] < key)
            low = mid + 1;
        else
            high = mid - 1;
    }
    return -1;

int main() {
    int n, key;
    printf("Enter size of array: ");
    scanf("%d", &n);

    int arr[50];
    printf("Enter sorted array:\n");
    for(int i = 0; i < n; i++)
        scanf("%d", &arr[i]);

    printf("Enter key to search: ");
    scanf("%d", &key);

    int index = binarySearchIter(arr, n, key);

    if(index != -1) printf("Found at index %d\n", index);
    else printf("Not found\n");

    return 0;
}
