


module tb;
  wire clk;
  wire rst;
  reg tick_1s;
  
  clock_divider DUT(.clk(clk), .rst(rst), .tick_1s(tick_1s));
  
  always #2 clk=~clk;
  
   initial begin 
     $monitor("time=%t, clk=%b, rst=%b, tick_1s",$time, clk, rst, tick_1s);
     
     clk=1'b0;
     rst=0;
     #3
     rst=1'b1;
     
     #400 $finish;
   end
endmodule 
