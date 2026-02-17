//Module and signal defenitions
module tb;
  logic clk;
  logic reset;
  logic en;
  logic [3:0] count;
  logic [3:0] expected_count;

  //module instatiation
  up_counter dut(
    .clk(clk),
    .reset(reset),
    .en(en),
    .count(count));
  
  //clock generation
  always begin
    #5 clk=~clk;
  end
  
  //Stimulus into Tasks
  task apply_reset();
    reset = 1'b1;
    repeat(5) @(posedge clk);
    reset = 1'b0;
  endtask

  
  task enable_counter(int cycles);
    en = 1'b1;
    repeat(cycles) @(posedge clk);
    en = 1'b0;
  endtask

  //tb execution block
  initial begin
    clk=0; 
    expected_count = 0;
    apply_reset();
    enable_counter(10);
    enable_counter(30);
    apply_reset();
    enable_counter(10);
    #50 $finish;
  end
  
  //kernel monitoring
  initial begin
  $monitor("Time=%0t reset=%0b en=%0b count=%0d",
            $time, reset, en, count);
  end
  
  
//Checker
  always @(posedge clk or posedge reset) begin
    if (reset)
        expected_count <= 0;
    else if (en)
        expected_count <= expected_count + 1;
end
always @(posedge clk) begin
  if(!reset) begin
    if (count !== expected_count) begin
        $error("Mismatch! Time=%0t Expected=%0d Got=%0d",
                $time, expected_count, count);
    end
  end
end
  // If reset is high, count must be zero
property reset_behavior;
  @(posedge clk)
    reset |-> (count == 0);
endproperty

assert property (reset_behavior)
  else $error("Count not zero during reset!");

covergroup cg @(posedge clk);
  coverpoint count;
  coverpoint en;
endgroup

cg cov = new();


endmodule
