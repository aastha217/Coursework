#include <stdio.h>

int n = 5;  
int graph[50][50] = {
    {0, 1, 1, 0, 0},
    {1, 0, 0, 1, 0},
    {1, 0, 0, 1, 1},
    {0, 1, 1, 0, 0},
    {0, 0, 1, 0, 0}
};

int visited[50];

/* Depth-First Search */
void dfs(int node) {
    visited[node] = 1;
    printf("%d ", node);

    for (int i = 0; i < n; i++) {
        if (graph[node][i] == 1 && !visited[i]) {
            dfs(i);
        }
    }
}

int main() {

    for (int i = 0; i < n; i++)
        visited[i] = 0;

    dfs(0);
    return 0;
}
