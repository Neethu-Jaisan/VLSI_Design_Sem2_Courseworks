// ---------------------------------------------
// OOPS-2 Evaluation Lab Complete Code
// ---------------------------------------------

// =====================
// PART-A
// =====================

class Packet;

  int pkt_id;
  int pkt_size;

  // Constructor
  function new(int pkt_id, int pkt_size);
    this.pkt_id   = pkt_id;
    this.pkt_size = pkt_size;
  endfunction

  // Virtual method
  virtual function void display();
    $display("Packet -> ID: %0d Size: %0d", pkt_id, pkt_size);
  endfunction

endclass



class DataPacket extends Packet;

  int payload;

  // Constructor
  function new(int pkt_id, int pkt_size, int payload);

    super.new(pkt_id, pkt_size);   // call parent constructor
    this.payload = payload;        // use this

  endfunction

  // Override method
  function void display();

    super.display();               // call parent method
    $display("Payload: %0d", payload);

  endfunction

endclass



// =====================
// PART-B
// =====================

virtual class Processor;

  pure virtual function void execute();

endclass



class ALUProcessor extends Processor;

  function void execute();
    $display("ALU Processor Executing...");
  endfunction

endclass



// =====================
// TESTBENCH
// =====================

module tb;

  initial begin

    // Declare ALL variables first
    Packet        p;
    DataPacket    dp;
    Processor     pr;
    ALUProcessor  alu;

    $display("---- PART-A ----");

    dp = new(1, 128, 999);
    p  = dp;            // Polymorphism

    p.display();        // Calls child version (because virtual)

    $display("\n---- PART-B ----");

    alu = new();
    pr  = alu;          // Polymorphism with virtual class

    pr.execute();

  end

endmodule
