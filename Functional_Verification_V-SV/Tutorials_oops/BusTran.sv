// Code your testbench here
// or browse Examples
class BusTran;

  bit [31:0] addr;
  bit [31:0] crc;
  bit [31:0] data[8];

  function void calc_crc();
    crc = addr;
    foreach (data[i])
      crc ^= data[i];
  endfunction

  function void display();
    $display("BusTran addr = %h, crc = %h", addr, crc);
  endfunction

endclass


module tb;

  initial begin
    BusTran b;
    b = new();

    b.addr = 32'h42;
    foreach (b.data[i])
      b.data[i] = i;

    b.calc_crc();
    b.display();
  end

endmodule
