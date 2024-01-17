/********************************************************************************************************************
Omri Bareket
216718726
Assingment 1
********************************************************************************************************************/

#include <math.h>
#include <stdio.h>

int main() {
  // Exercise 1- Enchanted binary strings
  printf("Exercise 1:\n");
  printf("Please enter 2 binary strings with 4 digits:\n");
  printf("Binary 1: ");

  unsigned short int bin1;
  scanf("%hd", &bin1);

  printf("Binary 2:\n");
  unsigned short int bin2;
  scanf("%hd", &bin2);
  // Printing the xor of the numbers
  printf("%04hd\n^\n%04hd\n", bin1, bin2);
  printf("--------\n");
  // Converting the numbers into binary and xoring between them
  printf("%d", bin1 / 1000 ^ bin2 / 1000);
  printf("%d", (bin1 / 100) % 10 ^ (bin2 / 100) % 10);
  printf("%d", (bin1 / 10) % 10 ^ (bin2 / 10) % 10);
  printf("%d", bin1 % 10 ^ bin2 % 10);

  printf("\n\n");

  // Exercise 2- The stange case of hexa
  printf("Exercise 2:\n");
  printf("Enter 2 hexadecimal numbers:\n");
  printf("Hex 1: ");

  unsigned int hex1;
  scanf("%X", &hex1);

  printf("Hex 2:");
  unsigned int hex2;
  scanf("%X", &hex2);

  printf("\n");

  int unsigned sum = hex1 + hex2;
  // Printing the calculation of the sum
  printf("%X + %X = %X\n", hex1, hex2, sum);
  printf("The last 4 binary digits of the sum are ");
  // Converting the first hexa digit into binary and Printing the value
  printf("%d", sum % 2);
  sum /= 2;
  printf("%d", sum % 2);
  sum /= 2;
  printf("%d", sum % 2);
  sum /= 2;
  printf("%d", sum % 2);

  printf("\n\n");

  // Exercise 3- The bases exchange of Macnugle
  printf("Exercise 3:\n");
  printf("Choose a base between 2 to 9: ");

  unsigned short int myBase;
  scanf("%hu", &myBase);
  printf("Enter a 5 digit number using that base: ");

  unsigned short int num;
  scanf("%hu", &num);
  unsigned short int num_tmp = num;
  // Claculating and converting between the bases
  unsigned short int decimalValue = (num % 10) * pow(myBase, 0);
  num /= 10;
  decimalValue = decimalValue + (num % 10) * pow(myBase, 1);
  num /= 10;
  decimalValue = decimalValue + (num % 10) * pow(myBase, 2);
  num /= 10;
  decimalValue = decimalValue + (num % 10) * pow(myBase, 3);
  num /= 10;
  decimalValue = decimalValue + (num % 10) * pow(myBase, 4);

  printf("The decimal value of %hu in base %hd is %hu\n", num_tmp, myBase, decimalValue);

  printf("\n");

  // Exercise 4- The choosen bit
  printf("Exercise 4:\n");
  printf("Enter a number: ");

  unsigned int number;
  scanf("%d", &number);
  printf("I want to know the value of bit number:");

  short int bitIndex;
  scanf("%hd", &bitIndex);
  printf("\n");

  // Creating the mask for the bit calculation
  unsigned int mask = pow(2, bitIndex - 1);
  // Claculating the choosen bit
  short int choosenBit = (number & mask) / mask;

  printf("The value of the %hd bit in %d is %hd\n", bitIndex, number, choosenBit);

  // The end
  printf("Congrats! You've found the philosopher's stone!");

  return 0;
}
