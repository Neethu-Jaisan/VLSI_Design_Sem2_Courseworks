`timescale 1ns/1ps

module tb_alphabet_bounce;

    // Clock & reset
    reg ap_clk;
    reg ap_rst_n;

    // AXI-stream input
    reg  [7:0] in_stream_V_V_TDATA;
    reg        in_stream_V_V_TVALID;
    wire       in_stream_V_V_TREADY;

    // AXI-stream output
    wire [7:0] out_stream_V_V_TDATA;
    wire       out_stream_V_V_TVALID;
    reg        out_stream_V_V_TREADY;

    // DUT instantiation
    alphabet_bounce dut (
        .ap_clk(ap_clk),
        .ap_rst_n(ap_rst_n),
        .in_stream_V_V_TDATA(in_stream_V_V_TDATA),
        .in_stream_V_V_TVALID(in_stream_V_V_TVALID),
        .in_stream_V_V_TREADY(in_stream_V_V_TREADY),
        .out_stream_V_V_TDATA(out_stream_V_V_TDATA),
        .out_stream_V_V_TVALID(out_stream_V_V_TVALID),
        .out_stream_V_V_TREADY(out_stream_V_V_TREADY)
    );

    // Clock generation (10ns period)
    always #5 ap_clk = ~ap_clk;

    initial begin
        // Init
        ap_clk = 0;
        ap_rst_n = 0;
        in_stream_V_V_TDATA  = 8'd0;
        in_stream_V_V_TVALID = 0;
        out_stream_V_V_TREADY = 1;

        // Reset
        #20;
        ap_rst_n = 1;

        // Send characters
        send_char(8'd65); // 'A'
        send_char(8'd66); // 'B'
        send_char(8'd67); // 'C'

        #100;
        $finish;
    end

    // Task to send one AXI-stream byte
    task send_char(input [7:0] data);
    begin
        @(posedge ap_clk);
        in_stream_V_V_TDATA  <= data;
        in_stream_V_V_TVALID <= 1;

        // Wait for handshake
        while (!in_stream_V_V_TREADY)
            @(posedge ap_clk);

        @(posedge ap_clk);
        in_stream_V_V_TVALID <= 0;
    end
    endtask

    // Monitor output
    always @(posedge ap_clk) begin
        if (out_stream_V_V_TVALID && out_stream_V_V_TREADY) begin
            $display("Time %0t : Output = %c (%0d)",
                     $time,
                     out_stream_V_V_TDATA,
                     out_stream_V_V_TDATA);
        end
    end

endmodule
