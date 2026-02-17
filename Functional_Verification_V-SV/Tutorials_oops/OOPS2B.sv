// ==========================================
// OOPS-2 Evaluation Lab Solution
// ==========================================

// ------------------------------
// PART-A: Inheritance & Polymorphism
// ------------------------------

class Device;

  int device_id;

  function new(int device_id);
    this.device_id = device_id;
  endfunction

  virtual function void display();
    $display("Generic Device -> ID: %0d", device_id);
  endfunction

endclass



class UART extends Device;

  function new(int device_id);
    super.new(device_id);
  endfunction

  function void display();
    $display("UART Device -> ID: %0d", device_id);
  endfunction

endclass



class SPI extends Device;

  function new(int device_id);
    super.new(device_id);
  endfunction

  function void display();
    $display("SPI Device -> ID: %0d", device_id);
  endfunction

endclass



class I2C extends Device;

  function new(int device_id);
    super.new(device_id);
  endfunction

  function void display();
    $display("I2C Device -> ID: %0d", device_id);
  endfunction

endclass



// ------------------------------
// PART-B: Virtual Class
// ------------------------------

virtual class Controller;
  pure virtual function void operate();
endclass



class MemoryController extends Controller;

  function void operate();
    $display("Memory Controller Operating...");
  endfunction

endclass



// ------------------------------
// TESTBENCH
// ------------------------------

module tb;

  initial begin

    // ==========================
    // DECLARE EVERYTHING FIRST
    // ==========================

    UART uart1;
    SPI  spi1;
    I2C  i2c1;

    Device dev_array[3];

    Controller ctrl;
    MemoryController mc;

    // ==========================
    // NOW EXECUTE STATEMENTS
    // ==========================

    $display("---- PART-A: Polymorphism ----");

    uart1 = new(101);
    spi1  = new(202);
    i2c1  = new(303);

    dev_array[0] = uart1;
    dev_array[1] = spi1;
    dev_array[2] = i2c1;

    foreach (dev_array[i])
      dev_array[i].display();


    $display("\n---- PART-B: Virtual Class ----");

    mc   = new();
    ctrl = mc;

    ctrl.operate();

  end

endmodule
