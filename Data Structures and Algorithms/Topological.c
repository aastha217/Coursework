#include <stdio.h>

#define MAX 50

int n;
int graph[MAX][MAX];

int visited[MAX];
int stack[MAX];
int top = -1;

// DFS Function
void dfs(int v)
{
    // Mark current vertex as visited
    visited[v] = 1;

    // Visit all adjacent vertices
    for(int i = 0; i < n; i++)
    {
        if(graph[v][i] && !visited[i])
        {
            dfs(i);
        }
    }

    // Push vertex onto stack after visiting all neighbours
    stack[++top] = v;
}

// Function to perform Topological Sort
void topologicalSort()
{
    // Perform DFS for all vertices
    for(int i = 0; i < n; i++)
    {
        if(!visited[i])
        {
            dfs(i);
        }
    }

    printf("Topological Order:\n");

    // Print vertices from stack
    while(top >= 0)
    {
        printf("%d ", stack[top--]);
    }
}

int main()
{
    printf("Enter number of vertices: ");
    scanf("%d", &n);

    printf("Enter adjacency matrix:\n");

    for(int i = 0; i < n; i++)
    {
        for(int j = 0; j < n; j++)
        {
            scanf("%d", &graph[i][j]);
        }
    }

    topologicalSort();

    return 0;
}