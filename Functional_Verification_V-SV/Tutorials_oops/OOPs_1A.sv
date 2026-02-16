// Code your testbench here
// or browse Examples
// ---------------------
// PART A
// ---------------------

class RegBlock;

  // Properties
  bit [7:0] ctrl_reg;
  bit [7:0] status_reg;
  bit [7:0] regfile [4];

  // Constructor
  function new();
    ctrl_reg   = 8'h01;
    status_reg = 8'h00;
    foreach (regfile[i])
      regfile[i] = i;
  endfunction

  // Write function
  function void write_reg(int addr, bit [7:0] data);
    if (addr inside {[0:3]})
      regfile[addr] = data;
    else
      $display("Invalid Address!");
  endfunction

  // Read function
  function void read_reg(int addr);
    if (addr inside {[0:3]})
      $display("Read: regfile[%0d] = %0h", addr, regfile[addr]);
    else
      $display("Invalid Address!");
  endfunction

  // Display function
  function void display();
    $display("CTRL = %0h | STATUS = %0h", ctrl_reg, status_reg);
    foreach (regfile[i])
      $display("regfile[%0d] = %0h", i, regfile[i]);
  endfunction

endclass


module tb_partA;

  initial begin

    RegBlock rb_h1, rb_h2;

    // Create object
    rb_h1 = new();

    $display("\n--- Initial Values ---");
    rb_h1.display();

    // Update ctrl and status
    rb_h1.ctrl_reg   = 8'hAA;
    rb_h1.status_reg = 8'h55;

    // Update register file
    rb_h1.write_reg(2, 8'hF0);

    $display("\n--- After Modification (rb_h1) ---");
    rb_h1.display();

    // Shallow copy
    rb_h2 = rb_h1;

    // Modify using rb_h2
    rb_h2.write_reg(1, 8'h99);

    $display("\n--- After rb_h2 Modification ---");
    $display("rb_h1 contents:");
    rb_h1.display();

    $display("rb_h2 contents:");
    rb_h2.display();

  end

endmodule
