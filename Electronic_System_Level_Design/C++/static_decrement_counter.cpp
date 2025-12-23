#include <iostream>
using namespace std;

class Counter
{
public:
    static int count;   // static variable

    void decrement()
    {
        count--;        // decrement the static variable
        cout << "Value is " << count << endl;
    }
};

// definition of static variable
int Counter::count = 10;

int main()
{
    Counter c1;
    Counter c2;
    Counter c3;
    
    c1.decrement();
    c2.decrement();
    c3.decrement();

    return 0;
}
