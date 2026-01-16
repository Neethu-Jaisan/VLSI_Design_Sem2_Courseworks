module ctrl_regs (
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

    logic [31:0] ctrl_reg;
    logic [31:0] status_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ctrl_reg   <= 32'b0;
            status_reg <= 32'b0;
        end
        else if (sel && wr_en) begin
            case (addr[5:2])
                4'h0: ctrl_reg <= wdata;
                default: ;
            endcase
        end
    end

    always_comb begin
        rdata = 32'b0;
        if (sel && rd_en) begin
            case (addr[5:2])
                4'h0: rdata = ctrl_reg;
                4'h1: rdata = status_reg;
                default: rdata = 32'h0;
            endcase
        end
    end

    assign ready = sel & (wr_en | rd_en);

endmodule
