module sr_latch_en (
    input  logic S,
    input  logic R,
    input  logic EN,
    output logic Q
);

always_latch begin
    if (EN) begin
        if (S && !R)
            Q = 1;
        else if (!S && R)
            Q = 0;
        else if (S && R)
            Q = 1'bx;   // invalid condition
    end
    // If EN = 0, Q holds previous value automatically
end

endmodule
