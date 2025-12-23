#include <iostream>
using namespace std;

class Division
{
    int a, b;          // data members

public:
    // Constructor
    Division(int x, int y)
    {
        a = x;
        b = y;
    }

    // Function to divide two numbers
    float divide()
    {
        return (float)a / b;
    }
};

int main()
{
    Division d(10, 2);   // object creation
    cout << "Division is " << d.divide() << endl;
    return 0;
}
