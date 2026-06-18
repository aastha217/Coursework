#include <stdio.h>

// Define infinity value to represent no edge
const int inf = 999999;

// Number of vertices
int n = 4;

// Edge counter for MST
int ne = 1;

// Variable to store minimum cost of MST
int mincost = 0;

// Cost adjacency matrix
int cost[4][4] = {
    {0, 10, 6, 5},
    {10, 0, 0, 15},
    {6, 0, 0, 4},
    {5, 15, 4, 0}
};

// Parent array used in Union-Find data structure
int parent[10] = {0};

// Function to find the root parent of a vertex
int applyfind(int i)
{
    while (parent[i] != 0)
        i = parent[i];

    return i;
}

// Function to perform union of two sets
int applyunion(int i, int j)
{
    // If vertices belong to different sets
    if (i != j)
    {
        parent[j] = i;
        return 1;
    }

    return 0;
}

int main()
{
    int i, j;
    int a, b;      // Stores selected edge vertices
    int u, v;      // Stores root parents
    int min;

    // Replace all 0 values with infinity
    // because 0 indicates no edge
    for (i = 0; i < n; i++)
    {
        for (j = 0; j < n; j++)
        {
            if (cost[i][j] == 0)
            {
                cost[i][j] = inf;
            }
        }
    }

    printf("Minimum Cost Spanning Tree:\n");

    // Continue until MST contains (n-1) edges
    while (ne < n)
    {
        min = inf;
        a = b = -1;

        // Find the minimum cost edge
        for (i = 0; i < n; i++)
        {
            for (j = 0; j < n; j++)
            {
                if (cost[i][j] < min)
                {
                    min = cost[i][j];

                    a = u = i;
                    b = v = j;
                }
            }
        }

        // Find root parents of selected vertices
        u = applyfind(u);
        v = applyfind(v);

        // Add edge only if it does not form a cycle
        if (applyunion(u, v))
        {
            printf("Edge %d: %d -> %d cost: %d\n",
                   ne, a, b, min);

            mincost += min;
        }

        // Remove selected edge from consideration
        cost[a][b] = inf;
        cost[b][a] = inf;

        ne++;
    }

    // Display total cost of MST
    printf("\nMinimum cost = %d\n", mincost);

    return 0;
}