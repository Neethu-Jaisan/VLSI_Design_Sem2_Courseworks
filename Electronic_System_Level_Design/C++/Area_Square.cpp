#include <iostream>
using namespace std;
class square
{
    int x;
    public:
    int area (int);
};
int square :: area (int a) 
{
  x = a;
 return x*x;
}
int main() 
{
  square sqr;
 
  cout << "Area of the square is " << sqr.area(4)<<"\n";
  return 0;
}
