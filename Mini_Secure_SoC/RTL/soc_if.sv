interface soc_if (input logic clk);

    // Global signals
    logic rst_n;

    // Simple memory-mapped bus signals
    logic [7:0]  addr;
    logic [31:0] wdata;
    logic        wr_en;
    logic        rd_en;
    logic [31:0] rdata;

endinterface
