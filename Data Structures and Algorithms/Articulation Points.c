#include <stdio.h>

// Number of vertices in the graph
int n = 5;

// Adjacency matrix representation of graph
int g[5][5] =
{
    {0,1,1,0,0},
    {1,0,1,1,0},
    {1,1,0,0,0},
    {0,1,0,0,1},
    {0,0,0,1,0}
};

// Global timer used in DFS traversal
int timev;

// Arrays used in Articulation Point Algorithm
int disc[10];     // Discovery time of each vertex
int low[10];      // Lowest reachable discovery time
int parent[10];   // Parent of each vertex in DFS tree
int ap[10];       // Marks articulation points

// DFS function
void dfs(int u)
{
    int children = 0;

    // Assign discovery and low values
    disc[u] = low[u] = ++timev;

    // Visit all adjacent vertices
    for(int v = 0; v < n; v++)
    {
        if(g[u][v])
        {
            // If vertex is not visited
            if(disc[v] == 0)
            {
                parent[v] = u;

                children++;

                // Recursive DFS call
                dfs(v);

                // Case 1:
                // Root vertex with more than one child
                if(parent[u] == -1 &&
                   children > 1)
                {
                    ap[u] = 1;
                }

                // Case 2:
                // Non-root vertex whose child
                // cannot reach an ancestor of u
                if(parent[u] != -1 &&
                   low[v] >= disc[u])
                {
                    ap[u] = 1;
                }

                // Update low value
                if(low[v] < low[u])
                {
                    low[u] = low[v];
                }
            }

            // Back Edge Found
            else if(v != parent[u] &&
                    disc[v] < low[u])
            {
                low[u] = disc[v];
            }
        }
    }
}

int main()
{
    // Initialize arrays
    for(int i = 0; i < n; i++)
    {
        parent[i] = -1;
        disc[i] = 0;
        low[i] = 0;
        ap[i] = 0;
    }

    // Run DFS for all connected components
    for(int i = 0; i < n; i++)
    {
        if(disc[i] == 0)
        {
            dfs(i);
        }
    }

    printf("Articulation Points:\n");

    // Display articulation points
    for(int i = 0; i < n; i++)
    {
        if(ap[i])
        {
            printf("%d ", i);
        }
    }

    return 0;
}