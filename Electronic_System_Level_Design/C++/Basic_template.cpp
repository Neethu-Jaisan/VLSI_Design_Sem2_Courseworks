#include <iostream>          // Header file for input/output operations
using namespace std;         // Allows use of cout, cin without std::

/* 
   Class Declaration
   A class is a blueprint that contains data (variables) 
   and functions (methods)
*/
class ClassName
{
    // -----------------------------
    // Data Members (Variables)
    // These store values inside the object
    // -----------------------------
    int a, b;

public:
    // -----------------------------
    // Constructor
    // Same name as class
    // Automatically called when object is created
    // Used to initialize data members
    // -----------------------------
    ClassName(int x, int y)
    {
        a = x;              // Assign value to data member
        b = y;
    }

    // -----------------------------
    // Member Function
    // Performs operation using data members
    // -----------------------------
    int operation()
    {
        return a + b;       // Change logic as required
    }

    // -----------------------------
    // Destructor (Optional)
    // Called automatically when object is destroyed
    // Used for cleanup
    // -----------------------------
    ~ClassName()
    {
        // Cleanup code (optional)
    }
};  // End of class (semicolon is mandatory)

/*
   Main Function
   Program execution starts here
*/
int main()
{
    // -----------------------------
    // Object Creation
    // Constructor is called automatically
    // -----------------------------
    ClassName obj(10, 5);

    // -----------------------------
    // Function Call using object
    // -----------------------------
    cout << "Result is " << obj.operation() << endl;

    return 0;               // Indicates successful program termination
}

class Counter
{
public:
    static int count;       // Static variable (shared by all objects)

    void decrement()
    {
        count--;            // Decrement static variable
        cout << count << endl;
    }
};

// Static variable definition (mandatory)
int Counter::count = 10;
