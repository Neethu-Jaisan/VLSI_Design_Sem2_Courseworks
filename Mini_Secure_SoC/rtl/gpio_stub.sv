module gpio_stub (
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

    logic [31:0] gpio_out;
    logic [31:0] gpio_in;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            gpio_out <= 32'b0;
        else if (sel && wr_en && addr[5:2] == 4'h1)
            gpio_out <= wdata;
    end

    always_comb begin
        rdata = 32'b0;
        if (sel && rd_en) begin
            case (addr[5:2])
                4'h1: rdata = gpio_out;
                4'h2: rdata = gpio_in;
                default: rdata = 32'h0;
            endcase
        end
    end

    assign ready = sel & (wr_en | rd_en);

endmodule
