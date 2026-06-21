#include <stdio.h>

int n = 4;
int graph[4][4] = {
    {0,1,1,0},
    {0,0,1,0},
    {1,0,0,1},
    {0,0,0,1}
};

void bfs(int start) {
    int visited[4] = {0};
    int q[10], front=0, rear=0;

    visited[start] = 1;
    q[rear++] = start;

    while (front < rear) {
        int node = q[front++];
        printf("%d ", node);

        for (int i = 0; i < n; i++) {
            if (graph[node][i] && !visited[i]) {
                visited[i] = 1;
                q[rear++] = i;
            }
        }
    }
}

int main() {
    bfs(0);
    return 0;
}
