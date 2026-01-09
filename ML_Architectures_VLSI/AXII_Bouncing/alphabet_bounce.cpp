#include <hls_stream.h>
#include <ap_int.h>

void alphabet_bounce(
    hls::stream<ap_uint<8>> &in_stream,
    hls::stream<ap_uint<8>> &out_stream
) {
#pragma HLS INTERFACE axis port=in_stream
#pragma HLS INTERFACE axis port=out_stream
#pragma HLS INTERFACE ap_ctrl_none port=return
#pragma HLS PIPELINE II=1

    static ap_uint<8> prev_char;
    static bool prev_valid = false;

    ap_uint<8> curr_char;
    ap_uint<8> out_char;

    if (!in_stream.empty()) {
        curr_char = in_stream.read();

        if (!prev_valid || curr_char == prev_char) {
            if (curr_char == 'Z')
                out_char = ap_uint<8>('A');
            else
                out_char = curr_char + ap_uint<8>(1);
        } else {
            out_char = curr_char;
        }

        out_stream.write(out_char);

        prev_char  = curr_char;
        prev_valid = true;
    }
}
