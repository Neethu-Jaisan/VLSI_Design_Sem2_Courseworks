//Ripple Carry Adder using 4 full Adders from Half adders 
Design Code for Half Adder 
module half_adder(input a, 
    input b, 
    output sum, 
    output carry); 
  assign sum = a^b; 
  assign carry= a&b; 
 
endmodule 
 
//Design Code for Full Adder using half adder 
module fa_ha(input a, 
      input b, 
      input cin, 
      output sum, 
      output carry); 
 wire s1,c1,c2; 
 half_adder h1(a,b,s1,c1); 
 half_adder h2(cin,s1,sum,c2); 
 or a1(carry,c1,c2); 
endmodule 
//Design Code for Ripple Carry Adder (Top Module) 
module rca_fa_ha(input [3:0] a,b, 
   input cin,clk,rst, 
    output reg [3:0]sum, 
         output reg carry); 
 
 wire [3:0]c,s; 
  
 fa_ha f1(a[0],b[0],cin,s[0],c[0]); 
  
 genvar i; 
 generate 
 for(i=1;i<4;i=i+1) 
 begin 
 fa_ha fag(a[i],b[i],c[i-1],s[i],c[i]); 
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
