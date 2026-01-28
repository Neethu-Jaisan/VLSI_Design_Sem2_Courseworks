// ------------------------------------------------------------
// Driver Class
// ------------------------------------------------------------
// The driver takes a transaction object
// and drives the corresponding signals onto the DUT interface
//
// Think of it as the "bus master"
// ------------------------------------------------------------
class driver;

    // --------------------------------------------------------
    // Virtual interface handle
    // --------------------------------------------------------
    // This allows the class to access interface signals
    // 'virtual' because classes are not static like modules
    // --------------------------------------------------------
    virtual soc_if.TB vif;

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    // Receives interface handle from testbench
    // --------------------------------------------------------
    function new(virtual soc_if.TB vif);
        this.vif = vif;
    endfunction

    // --------------------------------------------------------
    // Drive task
    // --------------------------------------------------------
    // Converts a transaction into pin-level activity
    // --------------------------------------------------------
    task drive(transaction tr);

        // ----------------------------------------------------
        // Wait for clock edge using clocking block
        // ----------------------------------------------------
        // Ensures proper synchronization with DUT
        // ----------------------------------------------------
        @(vif.cb);

        // ----------------------------------------------------
        // Drive address and data
        // ----------------------------------------------------
        vif.cb.addr  <= tr.addr;
        vif.cb.wdata <= tr.data;

        // ----------------------------------------------------
        // Drive control signals based on transaction type
        // ----------------------------------------------------
        if (tr.write) begin
            vif.cb.wr_en <= 1'b1;
            vif.cb.rd_en <= 1'b0;
        end
        else begin
            vif.cb.wr_en <= 1'b0;
            vif.cb.rd_en <= 1'b1;
        end

        // ----------------------------------------------------
        // Hold signals for one cycle
        // ----------------------------------------------------
        @(vif.cb);

        // ----------------------------------------------------
        // Deassert control signals after transaction
        // ----------------------------------------------------
        vif.cb.wr_en <= 1'b0;
        vif.cb.rd_en <= 1'b0;

    endtask

endclass
