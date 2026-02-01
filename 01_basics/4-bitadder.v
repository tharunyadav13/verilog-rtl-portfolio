// Code your testbench here
// or browse Examples

// 4 bit full adder.


module fulladder(
  input a,
  input b,
  input cin,
  output reg sum,
  output reg count);
  
  always@(*)begin 
    
  sum=a^b^cin;
    count=(a & b) | (cin & (a ^ b)); 
  end 
endmodule 
  

module adder4bit(
  input [3:0]a,
  input [3:0]b,
  input cin,
  output  [3:0] sum,
  output  count);
  
  wire [2:0] carry;  // this my temporary storage varaiable .
  
  fulladder dut(.a(a[0]), .b(b[0]), .cin(cin), .sum(sum[0]), .count(carry[0]));
  fulladder dut1(.a(a[1]), .b(b[1]), .cin(carry[0]), .sum(sum[1]), .count(carry[1]));
    fulladder dut2(.a(a[2]), .b(b[2]), .cin(carry[1]),  .sum(sum[2]),  .count(carry[2]));
  fulladder dut3(.a(a[3]), .b(b[3]), .cin(carry[2]), .sum(sum[3]), .count(count)) ;
                     
  endmodule 
                                    
