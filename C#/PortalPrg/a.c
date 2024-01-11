/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>

int main()
{
    printf("Exercise 1:\n");
    printf("Please enter 2 binary strings with 4 digits:\n");
    printf("Binary 1: ");
    
    short int bin1;
    scanf("%hd", &bin1);
    
    printf("Binary 2: ");
    short int bin2;
    scanf("%hd", &bin2);
    
    printf("%hd\n^\n%hd\n", bin2, bin2);
    printf("--------\n");
    
    printf("%d", bin1/1000 ^ bin2/100);
    printf("%d", (bin1/100)%10 ^ (bin2/100)%10);
    printf("%d", (bin1/10)%10 ^ (bin2/10)%10);
    printf("%d", bin1%10 ^ bin2%10);
    
    return 0;
}
