// Interface definition for Mini SoC
// This interface groups all bus signals between DUT and Testbench
interface soc_if (input logic clk);

    // -----------------------------
    // Reset signal
    // -----------------------------
    // Active-low reset used by DUT
    logic rst_n;

    // -----------------------------
    // Memory-mapped bus signals
    // -----------------------------
    logic [7:0]  addr;    // Address bus (selects register / peripheral)
    logic [31:0] wdata;   // Write data bus
    logic        wr_en;   // Write enable
    logic        rd_en;   // Read enable
    logic [31:0] rdata;   // Read data from DUT

    // =========================================================
    // Clocking block (for TESTBENCH)
    // =========================================================
    // Purpose:
    // - Synchronizes signal driving and sampling to clock edge
    // - Avoids race conditions between DUT and TB
    // - Used ONLY in testbench (driver/monitor)
    //
    // Direction meanings here are from TESTBENCH perspective
    // =========================================================
    clocking cb @(posedge clk);

        // Signals driven BY testbench
        output addr;
        output wdata;
        output wr_en;
        output rd_en;
        output rst_n;

        // Signals sampled BY testbench
        input  rdata;

    endclocking

    // =========================================================
    // Modport for DUT
    // =========================================================
    // Defines how DUT sees the interface signals
    // This enforces direction correctness
    // =========================================================
    modport DUT (
        input  clk,
        input  rst_n,
        input  addr,
        input  wdata,
        input  wr_en,
        input  rd_en,
        output rdata
    );

    // =========================================================
    // Modport for TESTBENCH
    // =========================================================
    // Testbench accesses signals through clocking block
    // This is what driver/monitor will use
    // =========================================================
modport TB (
    clocking cb,
    input  addr,
    input  wdata,
    input  wr_en,
    input  rd_en,
    input  rst_n,
    input  rdata
);


endinterface
