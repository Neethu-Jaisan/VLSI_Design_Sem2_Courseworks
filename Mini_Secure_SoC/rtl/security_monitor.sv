module security_monitor (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        sel,
    input  logic [31:0] addr,
    input  logic        valid,
    output logic        security_alert
);

    localparam SEC_BASE = 4'h1; // protect accelerator region

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            security_alert <= 1'b0;
        else if (valid && addr[15:12] == SEC_BASE && !sel)
            security_alert <= 1'b1;
    end

endmodule
