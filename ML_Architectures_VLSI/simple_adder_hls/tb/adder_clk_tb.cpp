#include <iostream>
#include <ap_int.h>

void adder_clk(ap_int<8>, ap_int<8>, ap_int<9>*);

int main() {
    ap_int<8> a, b;
    ap_int<9> sum;

    a = 5; b = 6;
    adder_clk(a, b, &sum);   // cycle 0
    std::cout << "Cycle 0 sum = " << sum << std::endl;

    adder_clk(a, b, &sum);   // cycle 1
    std::cout << "Cycle 1 sum = " << sum << std::endl;

    return 0;
}
