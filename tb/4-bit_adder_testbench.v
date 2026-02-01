// Code your design here

module tb;
  reg [3:0] a;
  reg [3:0] b;
  reg cin;
  wire [3:0] sum;
  wire count;
  
  adder4bit DUT(.a(a), .b(b), .cin(cin), .sum(sum), .count(count));
  
  
  initial begin 
   
    
    $monitor("time=%0t, a=%0b, b=%0b, cin=%0b, .sum=%0b, count=%0b",$time,a,b,cin,sum,count);
    
  #2  a=4'b0100; b=4'b1000;  cin=1'b1;
    #2 a=4'b1101; b=4'b0010; cin=1'b0;
    
    #5 $finish;
  end
endmodule 
    
