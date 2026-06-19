#include <stdio.h>

// Number of vertices in the graph
int n = 4;

// Number of edges in the graph
int e = 5;

// Source vertices of edges
int u[5] = {0, 0, 1, 2, 3};

// Destination vertices of edges
int v[5] = {1, 2, 2, 3, 1};

// Edge weights
int w[5] = {4, 3, 1, 2, 5};

// Array to store shortest distances
int dist[4];

// Function to implement Bellman-Ford Algorithm
void bellman()
{
    // Initialize all distances as infinity
    for(int i = 0; i < n; i++)
    {
        dist[i] = 9999;
    }

    // Distance from source vertex (0) to itself is 0
    dist[0] = 0;

    // Relax all edges (n-1) times
    for(int i = 0; i < n - 1; i++)
    {
        for(int j = 0; j < e; j++)
        {
            // Check if a shorter path exists
            if(dist[u[j]] + w[j] < dist[v[j]])
            {
                dist[v[j]] =
                dist[u[j]] + w[j];
            }
        }
    }
}

int main()
{
    // Call Bellman-Ford Algorithm
    bellman();

    printf("Shortest distances from source vertex 0:\n");

    // Display shortest distances
    for(int i = 0; i < n; i++)
    {
        printf("%d ", dist[i]);
    }

    return 0;
}