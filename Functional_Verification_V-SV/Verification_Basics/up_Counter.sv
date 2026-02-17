// Code your design here
module up_counter (
    input  clk,
    input  reset,
    input  en,
    output reg [3:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 4'b0000;
    else if (en)
        count <= count + 1;
end

endmodule
// Code your testbench here
// or browse Examples
module tb;
  logic clk;
  logic reset;
  logic en;
  logic [3:0] count;
  
  up_counter dut(
    .clk(clk),
    .reset(reset),
    .en(en),
    .count(count));
  always begin
    #5 clk=~clk;
  end
  
  initial begin
    clk=0;
	reset=1'b1;
    en=1'b0;
    #100 reset=1'b0;
    #10 en=1'b1;
    #50 en=1'b0;
    #20 en=1'b1;
    #10 en=1'b0;
    #50 $finish;
  end
  initial begin
  $monitor("Time=%0t reset=%0b en=%0b count=%0d",
            $time, reset, en, count);
end

endmodule
