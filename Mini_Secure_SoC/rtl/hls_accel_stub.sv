module hls_accel_stub (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        sel,
    input  logic [31:0] addr,
    input  logic [31:0] wdata,
    input  logic        wr_en,
    input  logic        rd_en,
    output logic [31:0] rdata,
    output logic        ready,
    output logic        irq
);

    logic start;
    logic done;
    logic [31:0] data_in;
    logic [31:0] data_out;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start <= 1'b0;
            done  <= 1'b0;
            irq   <= 1'b0;
        end
        else if (sel && wr_en && addr[5:2] == 4'h0) begin
            start <= wdata[0];
            done  <= 1'b0;
            irq   <= 1'b0;
        end
        else if (start) begin
            // fake computation
            data_out <= data_in + 1;
            done     <= 1'b1;
            irq      <= 1'b1;
            start    <= 1'b0;
        end
    end

    always_comb begin
        rdata = 32'b0;
        if (sel && rd_en) begin
            case (addr[5:2])
                4'h1: rdata = {31'b0, done};
                4'h3: rdata = data_out;
                default: rdata = 32'h0;
            endcase
        end
    end

    assign ready = sel & (wr_en | rd_en);

endmodule
