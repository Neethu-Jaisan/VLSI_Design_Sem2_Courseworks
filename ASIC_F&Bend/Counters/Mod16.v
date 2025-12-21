/*Mod-16 Up Counter with Parallel Load 
Design Code*/ 
module mod16(input clk, 
      input rst, 
      input [3:0]data_in, 
      input [1:0]mode, 
      output reg [3:0]cnt_out); 
 
 
always@(posedge clk or posedge rst) 
begin 
if(rst) 
 cnt_out<=4'd0; 
else 
 begin casex(mode) 
  2'b00:cnt_out<=cnt_out; 
  2'b01:cnt_out<=cnt_out+1; 
  2'b1x:cnt_out<=data_in; 
  //default cnt_out<=4'd0; 
 endcase  
end 
end 
endmodule
