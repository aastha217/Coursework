#include <stdio.h>

#define N 5   // Number of vertices in the graph

// Recursive DFS function to detect a cycle
int dfsCycle(int v,
             int adj[N][N],
             int vis[],
             int parent)
{
    // Mark current vertex as visited
    vis[v] = 1;

    // Traverse all adjacent vertices
    for(int u = 0; u < N; u++)
    {
        // Check if an edge exists
        if(adj[v][u])
        {
            // If adjacent vertex is not visited
            if(!vis[u])
            {
                // Recursively perform DFS
                if(dfsCycle(u, adj, vis, v))
                {
                    return 1;   // Cycle found
                }
            }

            // If adjacent vertex is already visited
            // and is not the parent of current vertex
            // then a cycle exists
            else if(u != parent)
            {
                return 1;
            }
        }
    }

    // No cycle found from this vertex
    return 0;
}

int main()
{
    // Adjacency matrix representation of graph
    int adj[N][N] =
    {
        {0,1,1,0,0},
        {1,0,1,0,0},
        {1,1,0,1,1},
        {0,0,1,0,1},
        {0,0,1,1,0}
    };

    // Visited array
    // Initially all vertices are unvisited
    int vis[N] = {0};

    // Variable to indicate cycle detection
    int cycle = 0;

    // Check every connected component
    for(int i = 0; i < N; i++)
    {
        // Start DFS from unvisited vertex
        if(!vis[i] &&
           dfsCycle(i, adj, vis, -1))
        {
            cycle = 1;
            break;
        }
    }

    // Display result
    if(cycle)
    {
        printf("Cycle detected\n");
    }
    else
    {
        printf("No cycle\n");
    }

    return 0;
}