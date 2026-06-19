#include <stdio.h>

// Program to find Minimum Spanning Tree (MST)
// using Prim's Algorithm

int main()
{
    // Number of vertices
    int n = 4;

    // Adjacency matrix representation of graph
    // 0 indicates no direct edge
    int g[4][4] =
    {
        {0,4,0,6},
        {4,0,5,0},
        {0,5,0,7},
        {6,0,7,0}
    };

    // key[] stores minimum edge weight
    // required to connect a vertex to MST
    int key[10];

    // parent[] stores MST structure
    int parent[10];

    // mst[] tracks whether a vertex
    // is already included in MST
    int mst[10];

    // Initialize arrays
    for(int i = 0; i < n; i++)
    {
        key[i] = 9999;   // Infinity
        mst[i] = 0;      // Not included in MST
    }

    // Start from vertex 0
    key[0] = 0;

    // Root node has no parent
    parent[0] = -1;

    // Repeat for (n-1) edges
    for(int i = 0; i < n - 1; i++)
    {
        int u = -1;

        // Find vertex with minimum key value
        // that is not yet included in MST
        for(int j = 0; j < n; j++)
        {
            if(!mst[j] &&
              (u == -1 || key[j] < key[u]))
            {
                u = j;
            }
        }

        // Include selected vertex in MST
        mst[u] = 1;

        // Update adjacent vertices
        for(int v = 0; v < n; v++)
        {
            // Check:
            // 1. Edge exists
            // 2. Vertex not already in MST
            // 3. Edge weight is smaller than current key
            if(g[u][v] &&
               !mst[v] &&
               g[u][v] < key[v])
            {
                parent[v] = u;
                key[v] = g[u][v];
            }
        }
    }

    printf("Edges in Minimum Spanning Tree:\n");

    // Print MST edges
    for(int i = 1; i < n; i++)
    {
        printf("%d - %d : %d\n",
               parent[i],
               i,
               g[i][parent[i]]);
    }

    return 0;
}