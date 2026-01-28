// ------------------------------------------------------------
// Mini SoC Top Module
// ------------------------------------------------------------
// This module represents the DUT (Design Under Test)
// It connects to the testbench using a SystemVerilog interface
// via the DUT modport
// ------------------------------------------------------------
module soc_top (
    // Interface connection using DUT modport
    // This enforces signal direction correctness
    soc_if.DUT sif
);

    // --------------------------------------------------------
    // Internal registers
    // --------------------------------------------------------

    // Control register (written by software / testbench)
    logic [31:0] ctrl_reg;

    // Status register (reflects internal state)
    logic [31:0] status_reg;

    // Counter register (simple peripheral)
    logic [31:0] counter_reg;

    // --------------------------------------------------------
    // Address decode signals
    // --------------------------------------------------------
    // These act like chip-selects for memory-mapped registers
    logic sel_ctrl;
    logic sel_status;
    logic sel_counter;

    // --------------------------------------------------------
    // Address Decoder (Combinational Logic)
    // --------------------------------------------------------
    // Decodes address and selects the appropriate register
    // This is memory-mapped I/O logic
    // --------------------------------------------------------
    always_comb begin
        // Default: no selection
        sel_ctrl    = 1'b0;
        sel_status  = 1'b0;
        sel_counter = 1'b0;

        // Decode based on address
        case (sif.addr)
            8'h00: sel_ctrl    = 1'b1; // Control register
            8'h04: sel_status  = 1'b1; // Status register
            8'h08: sel_counter = 1'b1; // Counter register
            default: ; // No match
        endcase
    end

    // --------------------------------------------------------
    // Control Register Logic (Sequential)
    // --------------------------------------------------------
    // - Reset clears control register
    // - Write occurs when wr_en is high and address matches
    // --------------------------------------------------------
    always_ff @(posedge sif.clk or negedge sif.rst_n) begin
        if (!sif.rst_n)
            ctrl_reg <= 32'h0;                 // Reset value
        else if (sif.wr_en && sel_ctrl)
            ctrl_reg <= sif.wdata;             // Write operation
    end

    // --------------------------------------------------------
    // Counter Peripheral Logic (Sequential)
    // --------------------------------------------------------
    // - Counter increments when enabled by ctrl_reg[0]
    // - Demonstrates inter-block communication
    // --------------------------------------------------------
    always_ff @(posedge sif.clk or negedge sif.rst_n) begin
        if (!sif.rst_n)
            counter_reg <= 32'h0;               // Reset counter
        else if (ctrl_reg[0])
            counter_reg <= counter_reg + 1'b1; // Increment
    end

    // --------------------------------------------------------
    // Status Register Logic (Combinational)
    // --------------------------------------------------------
    // Status reflects internal signals
    // Here: bit[0] shows whether counter is enabled
    // --------------------------------------------------------
    always_comb begin
        status_reg = 32'h0;        // Default
        status_reg[0] = ctrl_reg[0];
    end

    // --------------------------------------------------------
    // Read Data Mux (Combinational)
    // --------------------------------------------------------
    // Routes selected register data onto rdata bus
    // --------------------------------------------------------
    always_comb begin
        sif.rdata = 32'h0;         // Default read value

        if (sif.rd_en) begin
            if (sel_ctrl)
                sif.rdata = ctrl_reg;
            else if (sel_status)
                sif.rdata = status_reg;
            else if (sel_counter)
                sif.rdata = counter_reg;
        end
    end

endmodule
