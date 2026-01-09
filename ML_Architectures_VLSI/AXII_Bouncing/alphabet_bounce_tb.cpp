#include <iostream>
#include <hls_stream.h>
#include <ap_int.h>

// DUT declaration (must match top function exactly)
void alphabet_bounce(
    hls::stream<ap_uint<8>> &in_stream,
    hls::stream<ap_uint<8>> &out_stream
);

int main() {
    hls::stream<ap_uint<8>> in_stream;
    hls::stream<ap_uint<8>> out_stream;

    // Test input
    const char input_data[] = {'A','A','B','C','C','Z','Z'};
    const int N = sizeof(input_data) / sizeof(input_data[0]);

    std::cout << "Input  : ";
    for (int i = 0; i < N; i++) {
        std::cout << input_data[i] << " ";
        in_stream.write(ap_uint<8>(input_data[i]));
    }
    std::cout << std::endl;

    // Call DUT once per input (streaming behavior)
    for (int i = 0; i < N; i++) {
        alphabet_bounce(in_stream, out_stream);
    }

    std::cout << "Output : ";
    for (int i = 0; i < N; i++) {
        if (!out_stream.empty()) {
            char out_char = (char) out_stream.read();
            std::cout << out_char << " ";
        }
    }
    std::cout << std::endl;

    return 0;
}
