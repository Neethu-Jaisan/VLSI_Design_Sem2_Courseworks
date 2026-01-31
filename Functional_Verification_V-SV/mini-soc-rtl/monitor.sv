// ------------------------------------------------------------
// Monitor Class
// ------------------------------------------------------------
// The monitor passively observes DUT activity
// It does NOT drive any signals
//
// Think of it as a "bus sniffer"
// ------------------------------------------------------------
`include "transaction.sv"

class monitor;

    // --------------------------------------------------------
    // Virtual interface handle
    // --------------------------------------------------------
    // Allows the monitor to sample interface signals
    // Uses TB modport to access clocking block
    // --------------------------------------------------------
    virtual soc_if.TB vif;

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    function new(virtual soc_if.TB vif);
        this.vif = vif;
    endfunction

    // --------------------------------------------------------
    // Observe task
    // --------------------------------------------------------
    // Continuously monitors read transactions
    // --------------------------------------------------------
    task observe();

        // Infinite loop to keep monitoring
        forever begin

            // ------------------------------------------------
            // Wait for clocking block event
            // ------------------------------------------------
            // Ensures clean sampling without race conditions
            // ------------------------------------------------
            @(vif.cb);

            // ------------------------------------------------
            // Detect read transaction
            // ------------------------------------------------
            if (vif.rd_en) begin

                // ------------------------------------------------
                // Display observed read information
                // ------------------------------------------------
                $display("[%0t] READ : addr=0x%0h data=0x%0h",
                         $time, vif.addr, vif.rdata);
            end

        end
    endtask

endclass
