#include <stdio.h>

int gcd(int a, int b){
  if (a>b) {
    a = a-b; 
    return gcd(a,b);
  }
  if (a<b) {
    b = b-a; 
    return gcd(a,b);
  }
  return a;
}

int main() {
  /* change the next two lines */
  int a = 9; 
  int b = 33; 
  /* call gcd and print the result */
  printf("%d\n",gcd(a,b));
  return 0;
}