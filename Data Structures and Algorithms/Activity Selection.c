#include <stdio.h>

// Number of activities
int n = 4;

// Start times of activities
int s[4] = {1, 3, 0, 5};

// Finish times of activities
// Activities are assumed to be sorted
// according to their finish times
int f[4] = {2, 4, 6, 7};

// Function to perform Activity Selection
void activity()
{
    // Select the first activity
    int last = 0;

    printf("Selected Activities:\n");

    // Print first selected activity
    printf("%d ", 0);

    // Check remaining activities
    for(int i = 1; i < n; i++)
    {
        // Select activity if its start time
        // is greater than or equal to the
        // finish time of previously selected activity
        if(s[i] >= f[last])
        {
            printf("%d ", i);

            // Update last selected activity
            last = i;
        }
    }
}

int main()
{
    // Call Activity Selection Algorithm
    activity();

    return 0;
}