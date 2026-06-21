#include <stdio.h>

// Number of vertices in the graph
int n = 4;

// Adjacency matrix representation of graph
// 1 indicates an edge between vertices
// 0 indicates no edge
int graph[4][4] =
{
    {0,1,1,0},
    {0,0,1,0},
    {1,0,0,1},
    {0,0,0,1}
};

// Function to perform Breadth First Search (BFS)
void bfs(int start)
{
    // Array to keep track of visited vertices
    int visited[4] = {0};

    // Queue used for BFS traversal
    int q[10];

    int front = 0;
    int rear = 0;

    // Mark starting vertex as visited
    visited[start] = 1;

    // Insert starting vertex into queue
    q[rear++] = start;

    // Continue until queue becomes empty
    while(front < rear)
    {
        // Remove front vertex from queue
        int node = q[front++];

        // Print current vertex
        printf("%d ", node);

        // Visit all adjacent vertices
        for(int i = 0; i < n; i++)
        {
            // If edge exists and vertex is unvisited
            if(graph[node][i] && !visited[i])
            {
                // Mark as visited
                visited[i] = 1;

                // Add to queue
                q[rear++] = i;
            }
        }
    }
}

int main()
{
    printf("BFS Traversal:\n");

    // Start BFS from vertex 0
    bfs(0);

    return 0;
}