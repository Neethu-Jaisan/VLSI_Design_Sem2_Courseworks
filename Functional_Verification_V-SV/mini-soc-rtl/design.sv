// ============================================================
// design.sv
// Mini SoC + Interface
// ============================================================


// -------------------------------
// Interface Definition
// -------------------------------
interface soc_if(input bit clk);     // Interface groups all SoC signals together and shares common clock

  logic rst_n;                       // Active-low reset signal

  logic [7:0]  addr;                 // Address bus (8-bit memory-mapped address space)
  logic [31:0] wdata;                // Write data bus (32-bit)
  logic [31:0] rdata;                // Read data bus (32-bit)
  logic wr_en;                       // Write enable signal
  logic rd_en;                       // Read enable signal

  // Clocking block ensures timing-safe driving/sampling in testbench
  clocking cb @(posedge clk);        // All TB transactions synchronized to posedge clk
    output addr, wdata, wr_en, rd_en; // TB drives these signals
    input  rdata;                     // TB samples rdata from DUT
  endclocking

endinterface



// ============================================================
// Mini SoC DUT
// ============================================================

module mini_soc(
    input  logic        clk,         // System clock
    input  logic        rst_n,       // Active-low reset
    input  logic [7:0]  addr,        // Address bus
    input  logic [31:0] wdata,       // Write data input
    input  logic        wr_en,       // Write enable
    input  logic        rd_en,       // Read enable
    output logic [31:0] rdata        // Read data output
);

  // -------------------------------
  // Address Map (Memory Mapped Registers)
  // -------------------------------
  // 0x00 - Control Register
  // 0x04 - GPIO Register
  // 0x08 - Counter Register
  // 0x0C - Status Register


  // -------------------------------
  // Internal Registers
  // -------------------------------
  logic [31:0] control_reg;   // Stores control bits (bit[0] enables counter)
  logic [3:0]  gpio_reg;      // 4-bit GPIO output register
  logic [31:0] counter_reg;   // Free-running counter when enabled
  logic [31:0] status_reg;    // Aggregated status register


  // -------------------------------
  // Counter Logic
  // -------------------------------
  // Sequential logic with asynchronous reset
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)
      counter_reg <= 0;                  // Reset counter to 0
    else if(control_reg[0])              // If enable bit is set
      counter_reg <= counter_reg + 1;    // Increment counter every clock
  end


  // -------------------------------
  // Write Logic
  // -------------------------------
  // Handles memory-mapped write transactions
  always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      control_reg <= 0;                  // Reset control register
      gpio_reg    <= 0;                  // Reset GPIO register
    end
    else if(wr_en) begin                 // If write is enabled
      case(addr)                         // Decode address
        8'h00: control_reg <= wdata;     // Write full 32-bit control register
        8'h04: gpio_reg    <= wdata[3:0];// Write lower 4 bits into GPIO
      endcase
    end
  end


  // -------------------------------
  // Status Register Aggregation
  // -------------------------------
  // Combinational logic that reflects system state
  always_comb begin
    status_reg = {24'b0,                 // Upper 24 bits unused
                  gpio_reg,              // Next 4 bits = GPIO value
                  control_reg[0],        // Next bit = counter enable
                  3'b0};                 // Lower 3 bits unused
  end


  // -------------------------------
  // Read Logic
  // -------------------------------
  // Pure combinational read mux
  always_comb begin
    rdata = 32'h0;                       // Default value when not reading

    if(rd_en) begin                      // Only valid during read cycle
      case(addr)                         // Address decoding
        8'h00: rdata = control_reg;      // Return control register
        8'h04: rdata = {28'b0, gpio_reg};// Return GPIO (zero-extended)
        8'h08: rdata = counter_reg;      // Return counter value
        8'h0C: rdata = status_reg;       // Return status register
      endcase
    end
  end

endmodule
