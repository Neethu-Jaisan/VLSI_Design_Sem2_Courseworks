//==========================================================
// Testbench for up_counter
// Demonstrates:
// - Clock generation
// - Modular tasks
// - Self-checking reference model
// - Assertions (SVA)
// - Functional coverage
// - Constrained random stimulus
//==========================================================

module tb;

  // -----------------------------
  // Signal Declarations
  // -----------------------------
  logic clk;
  logic reset;
  logic en;
  logic [3:0] count;

  // Reference model variable
  logic [3:0] expected_count;

  // -----------------------------
  // DUT Instantiation
  // -----------------------------
  up_counter dut (
    .clk(clk),
    .reset(reset),
    .en(en),
    .count(count)
  );

  // -----------------------------
  // Clock Generation (10 time unit period)
  // -----------------------------
  always #5 clk = ~clk;

  // -----------------------------
  // Apply Asynchronous Reset
  // -----------------------------
  task apply_reset();
    reset = 1'b1;
    repeat(5) @(posedge clk);   // Hold reset for 5 cycles
    reset = 1'b0;
  endtask

  // -----------------------------
  // Randomized Enable Control
  // Randomly enables counter for
  // random number of clock cycles
  // -----------------------------
  task random_enable();
    int cycles;

    // Constrained random: cycles between 1 and 20
    assert(std::randomize(cycles) with { cycles inside {[1:20]}; });

    en = 1'b1;
    repeat(cycles) @(posedge clk);
    en = 1'b0;

    // Wait random idle cycles
    assert(std::randomize(cycles) with { cycles inside {[1:10]}; });
    repeat(cycles) @(posedge clk);
  endtask

  // -----------------------------
  // Testbench Execution
  // -----------------------------
  initial begin
    clk = 0;
    reset = 0;
    en = 0;
    expected_count = 0;

    // Apply initial reset
    apply_reset();

    // Run multiple random tests
    repeat(10) begin
      random_enable();
    end

    // Apply reset again mid-simulation
    apply_reset();

    // More randomized stimulus
    repeat(10) begin
      random_enable();
    end

    #50 $finish;
  end

  // -----------------------------
  // Monitor (For Visibility)
  // -----------------------------
  initial begin
    $monitor("Time=%0t reset=%0b en=%0b count=%0d",
              $time, reset, en, count);
  end

  // -----------------------------
  // Reference Model (Scoreboard)
  // Matches DUT behavior exactly
  // -----------------------------
  always @(posedge clk or posedge reset) begin
    if (reset)
      expected_count <= 0;
    else if (en)
      expected_count <= expected_count + 1;
  end

  // -----------------------------
  // Self-Checking Logic
  // -----------------------------
  always @(posedge clk) begin
    if (!reset) begin
      if (count !== expected_count) begin
        $error("Mismatch! Time=%0t Expected=%0d Got=%0d",
                $time, expected_count, count);
      end
    end
  end

  // -----------------------------
  // Assertion: During reset, count must be zero
  // -----------------------------
  property reset_behavior;
    @(posedge clk)
      reset |-> (count == 0);
  endproperty

  assert property (reset_behavior)
    else $error("Count not zero during reset!");

  // -----------------------------
  // Functional Coverage
  // -----------------------------
  covergroup counter_cg @(posedge clk);

    // Cover all counter values
    coverpoint count {
      bins all_vals[] = {[0:15]};
    }

    // Cover enable high and low
    coverpoint en {
      bins en_high = {1};
      bins en_low  = {0};
    }

    // Cross coverage
    cross count, en;

  endgroup

  counter_cg cg = new();

endmodule
