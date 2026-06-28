#include <stdio.h>

int board[10];

int place(int row,int col)
{
    for(int i=1;i<row;i++)
    {
        if(board[i]==col ||
           abs(board[i]-col)
           ==
           abs(i-row))
            return 0;
    }

    return 1;
}

void queen(int row,int n)
{
    if(row>n)
    {
        for(int i=1;i<=n;i++)
        {
            printf("%d ",
                   board[i]);
        }
        printf("\n");

        return;
    }

    for(int col=1;col<=n;col++)
    {
        if(place(row,col))
        {
            board[row]=col;

            queen(row+1,n);
        }
    }
}

int main()
{
    queen(1,4);

    return 0;
}