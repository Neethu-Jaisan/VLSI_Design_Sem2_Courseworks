#include <ap_int.h>

void adder_clk(
    ap_int<8> a,
    ap_int<8> b,
    ap_int<9> *sum
) {
#pragma HLS INTERFACE ap_none port=a
#pragma HLS INTERFACE ap_none port=b
#pragma HLS INTERFACE ap_none port=sum
#pragma HLS INTERFACE ap_ctrl_hs port=return

#pragma HLS LATENCY min=1 max=1

    ap_int<9> temp;
    temp = a + b;
    *sum = temp;
}
