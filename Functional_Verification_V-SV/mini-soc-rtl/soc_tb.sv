// ------------------------------------------------------------
// Testbench Top
// ------------------------------------------------------------
// This module:
// - Generates clock
// - Instantiates interface
// - Connects DUT
// - Creates driver and monitor
// - Applies reset
// - Sends transactions
// ------------------------------------------------------------
module soc_tb;

    // --------------------------------------------------------
    // Clock generation
    // --------------------------------------------------------
    logic clk;

    // Initialize clock
    initial clk = 0;

    // Toggle clock every 5 time units
    always #5 clk = ~clk;

    // --------------------------------------------------------
    // Interface instantiation
    // --------------------------------------------------------
    soc_if sif(clk);

    // --------------------------------------------------------
    // DUT instantiation
    // --------------------------------------------------------
    soc_top dut (
        .sif(sif)
    );

    // --------------------------------------------------------
    // Driver, Monitor, Transaction handles
    // --------------------------------------------------------
    driver       drv;
    monitor      mon;
    transaction  tr;

    // --------------------------------------------------------
    // Test sequence
    // --------------------------------------------------------
    initial begin

        // -----------------------------------------------
        // Initialize interface signals
        // -----------------------------------------------
        sif.cb.addr  = '0;
        sif.cb.wdata = '0;
        sif.cb.wr_en = 0;
        sif.cb.rd_en = 0;
        sif.cb.rst_n = 0;   // Assert reset

        // Hold reset for few cycles
        repeat (2) @(posedge clk);

        // Deassert reset
        sif.cb.rst_n = 1;

        // -----------------------------------------------
        // Create class objects
        // -----------------------------------------------
        drv = new(sif);
        mon = new(sif);
        tr  = new();

        // -----------------------------------------------
        // Start monitor in parallel
        // -----------------------------------------------
        fork
            mon.observe();
        join_none

        // =================================================
        // TEST 1: Enable counter via control register
        // =================================================
        tr.addr  = 8'h00;        // Control register
        tr.data  = 32'h1;        // Enable bit
        tr.write = 1'b1;
        drv.drive(tr);

        // Wait few cycles for counter increment
        repeat (5) @(posedge clk);

        // =================================================
        // TEST 2: Read counter value
        // =================================================
        tr.addr  = 8'h08;        // Counter register
        tr.write = 1'b0;
        drv.drive(tr);

        // =================================================
        // TEST 3: GPIO write
        // =================================================
        tr.addr  = 8'h0C;        // GPIO register
        tr.data  = 32'hA;        // 4'b1010
        tr.write = 1'b1;
        drv.drive(tr);

        // =================================================
        // TEST 4: GPIO readback
        // =================================================
        tr.addr  = 8'h0C;        // GPIO register
        tr.write = 1'b0;
        drv.drive(tr);

        // -----------------------------------------------
        // Finish simulation
        // -----------------------------------------------
        repeat (5) @(posedge clk);
        $finish;

    end

endmodule
