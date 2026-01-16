module memory_stub (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        sel,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    input  logic        wr_en,
    input  logic        rd_en,
    output logic [31:0] rdata,
    output logic        ready
);

    logic [31:0] mem [0:255];

    always_ff @(posedge clk) begin
        if (sel && wr_en)
            mem[addr[9:2]] <= wdata;
    end

    always_comb begin
        if (sel && rd_en)
            rdata = mem[addr[9:2]];
        else
            rdata = 32'b0;
    end

    assign ready = sel & (wr_en | rd_en);

endmodule
