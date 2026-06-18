#include <stdio.h>

// Number of vertices in the graph
int n = 4;

// Adjacency matrix representation of the graph
// 0 indicates no direct edge between vertices
int g[4][4] = {
    {0, 5, 0, 9},
    {0, 0, 2, 0},
    {0, 0, 0, 3},
    {0, 0, 0, 0}
};

// Array to store shortest distances from source vertex
int dist[4];

// Array to track visited vertices
int visited[4];

// Function to implement Dijkstra's Algorithm
void dijkstra()
{
    // Initialize distances as infinity (9999)
    // and mark all vertices as unvisited
    for(int i = 0; i < n; i++)
    {
        dist[i] = 9999;
        visited[i] = 0;
    }

    // Distance from source vertex (0) to itself is 0
    dist[0] = 0;

    // Repeat for all vertices
    for(int k = 0; k < n; k++)
    {
        int u = -1;
        int min = 9999;

        // Find the unvisited vertex with minimum distance
        for(int i = 0; i < n; i++)
        {
            if(!visited[i] && dist[i] < min)
            {
                min = dist[i];
                u = i;
            }
        }

        // Mark the selected vertex as visited
        visited[u] = 1;

        // Update distances of adjacent vertices
        for(int v = 0; v < n; v++)
        {
            // Check if there is an edge from u to v
            // and whether a shorter path is found
            if(g[u][v] &&
               dist[u] + g[u][v] < dist[v])
            {
                dist[v] = dist[u] + g[u][v];
            }
        }
    }
}

int main()
{
    // Call Dijkstra's algorithm
    dijkstra();

    // Display shortest distances from source vertex 0
    printf("Shortest distances from source vertex 0:\n");

    for(int i = 0; i < n; i++)
    {
        printf("%d ", dist[i]);
    }

    return 0;
}