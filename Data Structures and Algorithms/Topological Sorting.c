#include <stdio.h>

// Maximum size of graph = 50 vertices

int n;              // Number of vertices
int a[50][50];      // Adjacency matrix

// Function to perform Topological Sorting
void topo()
{
    int indeg[50];
    int i, j;

    // Calculate indegree of each vertex
    for(i = 0; i < n; i++)
    {
        indeg[i] = 0;

        for(j = 0; j < n; j++)
        {
            // If there is an edge from j to i
            // increase indegree of i
            if(a[j][i] == 1)
            {
                indeg[i]++;
            }
        }
    }

    printf("Topological Order:\n");

    // Repeat n times to process all vertices
    for(i = 0; i < n; i++)
    {
        for(j = 0; j < n; j++)
        {
            // Find a vertex with indegree 0
            if(indeg[j] == 0)
            {
                // Print the vertex
                printf("%d ", j);

                // Mark vertex as processed
                indeg[j] = -1;

                // Reduce indegree of all adjacent vertices
                int k;

                for(k = 0; k < n; k++)
                {
                    if(a[j][k] == 1)
                    {
                        indeg[k]--;
                    }
                }

                break;
            }
        }
    }
}

int main()
{
    int i, j;

    // Input number of vertices
    printf("Enter number of vertices: ");
    scanf("%d", &n);

    printf("Enter adjacency matrix:\n");

    // Input adjacency matrix
    for(i = 0; i < n; i++)
    {
        for(j = 0; j < n; j++)
        {
            scanf("%d", &a[i][j]);
        }
    }

    // Perform Topological Sorting
    topo();

    return 0;
}