#include <stdio.h>

// Number of vertices in the graph
int n = 3;

// Adjacency matrix representation of the graph
// 999 represents infinity (no direct path)
int d[3][3] = {
    {0,   4, 11},
    {6,   0,  2},
    {3, 999,  0}
};

// Function to implement Floyd-Warshall Algorithm
void floyd()
{
    // k = intermediate vertex
    for(int k = 0; k < n; k++)
    {
        // i = source vertex
        for(int i = 0; i < n; i++)
        {
            // j = destination vertex
            for(int j = 0; j < n; j++)
            {
                // Check whether path through vertex k
                // is shorter than current path
                if(d[i][k] + d[k][j] < d[i][j])
                {
                    d[i][j] =
                    d[i][k] + d[k][j];
                }
            }
        }
    }
}

int main()
{
    // Find shortest paths between all pairs of vertices
    floyd();

    printf("Shortest Distance Matrix:\n");

    // Display final shortest path matrix
    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < n; j++)
        {
            printf("%d ", d[i][j]);
        }

        printf("\n");
    }

    return 0;
}