//Design Code for Ripple Carry Adder (Top Module) 
module rca_4fa(input [3:0]a,b, 
        input cin, 
        input rst,clk, 
        output reg [3:0]sum, 
        output reg carry); 
 
 wire [3:0]c,s; 
 full_adder f1(a[0],b[0],cin,s[0],c[0]); 
 genvar i; 
 generate 
 for(i=1;i<4;i=i+1) 
 begin 
 full_adder fag(a[i],b[i],c[i-1],s[i],c[i]); 
 end 
 endgenerate 
  
 
always@(posedge clk or posedge rst) 
begin 
 if(rst) begin 
 sum<=4'b0; 
 carry<=1'b0; 
 end 
 else begin 
 sum <={s[3],s[2],s[1],s[0]}; 
 carry<=c[3]; 
 end 
end 
endmodule
