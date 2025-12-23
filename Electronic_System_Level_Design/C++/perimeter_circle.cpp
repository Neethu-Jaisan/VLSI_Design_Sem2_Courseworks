#include <iostream>
using namespace std;

class Circle {
    float r;
public:
    Circle(float radius) {
        r = radius;
    }

    float perimeter() {
        return 2 * 3.14159 * r;
    }
};

int main() {
    Circle c(7);
    cout << "Perimeter of the circle is " << c.perimeter() << endl;
    return 0;
}
