// Code your testbench here
// or browse Examples
class RegFile;

  bit [7:0] regs[4];

  function new();
    foreach (regs[i])
      regs[i] = i * 10;
  endfunction

  function void display();
    foreach (regs[i])
      $display("regs[%0d] = %0h", i, regs[i]);
  endfunction

endclass
class MemoryController;

  RegFile rf;

  function new();
    rf = new();
  endfunction

  function void display();
    rf.display();
  endfunction

  // Deep Copy Function
  function MemoryController copy();
    MemoryController temp;
    temp = new();
    temp.rf = new();

    foreach (rf.regs[i])
      temp.rf.regs[i] = this.rf.regs[i];

    return temp;
  endfunction

endclass
module tb_partB;

  initial begin

    MemoryController mc1, mc2;

    $display("\n====== SHALLOW COPY DEMO ======");

    mc1 = new();
    mc2 = mc1;   // shallow copy

    mc2.rf.regs[2] = 8'hAA;

    $display("mc1:");
    mc1.display();

    $display("mc2:");
    mc2.display();

    $display("\n====== DEEP COPY DEMO ======");

    mc2 = mc1.copy();   // deep copy

    mc2.rf.regs[2] = 8'h55;

    $display("mc1:");
    mc1.display();

    $display("mc2:");
    mc2.display();

  end

endmodule
