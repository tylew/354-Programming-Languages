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
