// ==================================================
// COMPLETE OOPS MEGA EVALUATION LAB (FIXED)
// ==================================================


// ============================
// PART-A: Inheritance & Polymorphism
// ============================

class Transaction;

  int id;
  int amount;

  function new(int id, int amount);
    this.id     = id;
    this.amount = amount;
  endfunction

  virtual function void display();
    $display("Transaction -> ID:%0d Amount:%0d", id, amount);
  endfunction

endclass



class CreditTransaction extends Transaction;

  string txn_type;   // renamed

  function new(int id, int amount);
    super.new(id, amount);
    this.txn_type = "CREDIT";
  endfunction

  function void display();
    super.display();
    $display("Type: %s", txn_type);
  endfunction

endclass



class DebitTransaction extends Transaction;

  string txn_type;   // renamed

  function new(int id, int amount);
    super.new(id, amount);
    this.txn_type = "DEBIT";
  endfunction

  function void display();
    super.display();
    $display("Type: %s", txn_type);
  endfunction

endclass



// ============================
// PART-B: Virtual Class
// ============================

virtual class Processor;

  pure virtual function void execute();

endclass



class ALU extends Processor;

  function void execute();
    $display("ALU Executing...");
  endfunction

endclass



// ============================
// PART-C: Shallow vs Deep Copy
// ============================

class RegBlock;

  bit [7:0] regs[4];

  function new();
    foreach (regs[i])
      regs[i] = i;
  endfunction

  function void display();
    foreach (regs[i])
      $display("regs[%0d]=%0d", i, regs[i]);
  endfunction

endclass



class Controller;

  RegBlock rb;

  function new();
    rb = new();
  endfunction

  function void display();
    rb.display();
  endfunction

  function Controller copy();
    Controller temp;
    temp = new();
    temp.rb = new();
    foreach (rb.regs[i])
      temp.rb.regs[i] = this.rb.regs[i];
    return temp;
  endfunction

endclass



// ============================
// TESTBENCH
// ============================

module tb;

  initial begin

    // ===== Declarations =====
    CreditTransaction ct;
    DebitTransaction  dt;
    Transaction t_array[2];

    Processor p;
    ALU alu;

    Controller c1, c2;

    $display("===== PART-A: Polymorphism =====");

    ct = new(1,1000);
    dt = new(2,500);

    t_array[0] = ct;
    t_array[1] = dt;

    foreach (t_array[i])
      t_array[i].display();


    $display("\n===== PART-B: Virtual Class =====");

    alu = new();
    p   = alu;
    p.execute();


    $display("\n===== PART-C: Shallow Copy =====");

    c1 = new();
    c2 = c1;      // shallow copy

    c2.rb.regs[2] = 99;

    $display("c1:");
    c1.display();
    $display("c2:");
    c2.display();


    $display("\n===== PART-C: Deep Copy =====");

    c2 = c1.copy();   // deep copy
    c2.rb.regs[2] = 55;

    $display("c1:");
    c1.display();
    $display("c2:");
    c2.display();

  end

endmodule
