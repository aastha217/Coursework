#include <stdio.h>
#include <string.h>

int main()
{
    char text[100];
    char pattern[100];

    printf("Enter text: ");
    gets(text);

    printf("Enter pattern: ");
    gets(pattern);

    int n = strlen(text);
    int m = strlen(pattern);

    // Check every possible position
    for(int i = 0; i <= n - m; i++)
    {
        int j;

        for(j = 0; j < m; j++)
        {
            if(text[i + j] != pattern[j])
                break;
        }

        if(j == m)
            printf("Pattern found at index %d\n", i);
    }

    return 0;
}