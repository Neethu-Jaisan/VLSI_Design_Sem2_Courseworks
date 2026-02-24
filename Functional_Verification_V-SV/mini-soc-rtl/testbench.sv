// ============================================================
// testbench.sv
// Final Stable Mini SoC Layered Testbench
// Demonstrates layered verification using:
// - Constrained random stimulus
// - Mailbox communication
// - Semaphore control
// - Event signaling
// - Reference-model scoreboard
// ============================================================

`timescale 1ns/1ns   // Time unit = 1ns, precision = 1ns

module tb;

  // ----------------------------------------------------------
  // Clock Generation
  // ----------------------------------------------------------
  bit clk = 0;                 // Declare simulation clock
  always #5 clk = ~clk;        // Toggle every 5ns → 10ns period → 100MHz

  // ----------------------------------------------------------
  // Interface Instance
  // ----------------------------------------------------------
  soc_if vif(clk);             // Instantiate interface and pass clock

  // ----------------------------------------------------------
  // DUT Instance
  // ----------------------------------------------------------
  mini_soc dut(
    .clk   (clk),              // Connect system clock
    .rst_n (vif.rst_n),        // Connect reset
    .addr  (vif.addr),         // Address bus
    .wdata (vif.wdata),        // Write data bus
    .wr_en (vif.wr_en),        // Write enable
    .rd_en (vif.rd_en),        // Read enable
    .rdata (vif.rdata)         // Read data bus
  );

  // ==========================================================
  // Transaction Class
  // Represents one bus transaction
  // ==========================================================

  class soc_txn;

    rand bit [7:0]  addr;      // Memory-mapped address
    rand bit [31:0] wdata;     // Write data
    rand bit        wr_en;     // Write enable
    rand bit        rd_en;     // Read enable

    // Constraint: cannot read and write simultaneously
    constraint valid_rw {
      !(wr_en && rd_en);       // Disallow both active
      wr_en || rd_en;          // At least one must be active
    }

    // Constraint: restrict address to valid register map
    constraint valid_addr {
      addr inside {8'h00,8'h04,8'h08,8'h0C};
    }

  endclass


  // ==========================================================
  // Generator
  // Creates random transactions
  // ==========================================================

  class generator;

    mailbox #(soc_txn) gen2drv;    // Mailbox to send transactions to driver

    function new(mailbox #(soc_txn) m);
      gen2drv = m;                 // Store mailbox handle
    endfunction

    task run();
      soc_txn tx;
      repeat(30) begin             // Generate 30 transactions
        tx = new();                // Create new transaction object
        assert(tx.randomize());    // Randomize using constraints
        gen2drv.put(tx);           // Send transaction to driver
      end
    endtask

  endclass


  // ==========================================================
  // Driver
  // Drives transactions onto DUT interface
  // ==========================================================

  class driver;

    virtual soc_if vif;            // Virtual interface handle
    mailbox #(soc_txn) gen2drv;    // Mailbox from generator
    semaphore bus_lock;            // Controls bus access
    event tx_done;                 // Signals transaction completion

    function new(virtual soc_if vif,
                 mailbox #(soc_txn) m,
                 semaphore s,
                 event e);
      this.vif   = vif;
      gen2drv    = m;
      bus_lock   = s;
      tx_done    = e;
    endfunction

    task run();
      soc_txn tx;

      forever begin
        gen2drv.get(tx);           // Wait and receive transaction

        bus_lock.get();            // Acquire bus access

        // Drive signals using clocking block
        vif.cb.addr  <= tx.addr;
        vif.cb.wdata <= tx.wdata;
        vif.cb.wr_en <= tx.wr_en;
        vif.cb.rd_en <= tx.rd_en;

        @(vif.cb);                 // Wait one clock cycle

        // Deassert control signals after one cycle
        vif.cb.wr_en <= 0;
        vif.cb.rd_en <= 0;

        bus_lock.put();            // Release bus

        -> tx_done;                // Trigger completion event
      end
    endtask

  endclass


  // ==========================================================
  // Monitor
  // Observes DUT activity (passive component)
  // ==========================================================

  class monitor;

    virtual soc_if vif;            // Virtual interface handle
    mailbox #(soc_txn) mon2sb;     // Mailbox to scoreboard

    function new(virtual soc_if vif,
                 mailbox #(soc_txn) m);
      this.vif = vif;
      mon2sb   = m;
    endfunction

    task run();
      soc_txn tx;

      forever begin
        @(posedge vif.clk);        // Sample at clock edge

        if(vif.rd_en) begin        // Capture read transactions only
          tx = new();
          tx.addr  = vif.addr;     // Store read address
          tx.wdata = vif.rdata;    // Store read data
          mon2sb.put(tx);          // Send to scoreboard
        end
      end
    endtask

  endclass


  // ==========================================================
  // Scoreboard
  // RTL-Accurate Reference Model
  // ==========================================================

  class scoreboard;

    mailbox #(soc_txn) mon2sb;     // Input from monitor
    virtual soc_if vif;            // Interface access

    // Reference model registers
    bit [31:0] model_control;
    bit [3:0]  model_gpio;
    bit [31:0] model_counter;
    bit        prev_enable;        // Stores previous cycle enable

    function new(mailbox #(soc_txn) m,
                 virtual soc_if vif);
      mon2sb = m;
      this.vif = vif;

      model_control = 0;
      model_gpio    = 0;
      model_counter = 0;
      prev_enable   = 0;
    endfunction

    task run();

      soc_txn tx;
      bit [31:0] expected;

      forever begin
        @(posedge vif.clk);

        // ------------------------------
        // 1. Check Read Transactions
        // ------------------------------
        if(mon2sb.num() > 0) begin
          mon2sb.get(tx);

          case(tx.addr)
            8'h00: expected = model_control;
            8'h04: expected = {28'b0, model_gpio};
            8'h08: expected = model_counter;
            8'h0C: expected = {24'b0,
                               model_gpio,
                               model_control[0],
                               3'b0};
            default: expected = 32'h0;
          endcase

          $display("Read Addr=%0h Data=%0h",
                    tx.addr, tx.wdata);

          if(expected !== tx.wdata) begin
            $error("Mismatch at Addr=%0h Expected=%0h Got=%0h",
                    tx.addr, expected, tx.wdata);
          end
        end

        // ------------------------------
        // 2. Mirror Write Transactions
        // ------------------------------
        if(vif.wr_en) begin
          case(vif.addr)
            8'h00: model_control = vif.wdata;
            8'h04: model_gpio    = vif.wdata[3:0];
          endcase
        end

        // ------------------------------
        // 3. Cycle-Accurate Counter Model
        // Matches nonblocking behavior
        // ------------------------------
        if(prev_enable)
          model_counter++;

        prev_enable = model_control[0];

      end

    endtask

  endclass


  // ==========================================================
  // Environment
  // Connects all components
  // ==========================================================

  class environment;

    generator  gen;
    driver     drv;
    monitor    mon;
    scoreboard sb;

    mailbox #(soc_txn) gen2drv;
    mailbox #(soc_txn) mon2sb;
    semaphore bus_lock;
    event tx_done;

    function new(virtual soc_if vif);

      gen2drv = new();
      mon2sb  = new();
      bus_lock = new(1);       // Single access semaphore

      gen = new(gen2drv);
      drv = new(vif, gen2drv, bus_lock, tx_done);
      mon = new(vif, mon2sb);
      sb  = new(mon2sb, vif);

    endfunction

    task run();
      fork
        gen.run();   // Start generator
        drv.run();   // Start driver
        mon.run();   // Start monitor
        sb.run();    // Start scoreboard
      join_none
    endtask

  endclass


  // ==========================================================
  // Test Block
  // ==========================================================

  initial begin

    environment env;

    // Apply reset
    vif.rst_n = 0;
    repeat(5) @(posedge clk);
    vif.rst_n = 1;

    // Create and start environment
    env = new(vif);
    env.run();

    #1000;           // Run simulation for 1000ns
    $finish;         // End simulation

  end

endmodule
