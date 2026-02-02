
     
module fsm_tb;
  reg din;
  reg clk,rst;
  wire dout;
  
  fsm_1011 DUT(.clk(clk), .rst(rst), .din(din), .dout(dout));
  
  always #5 clk=~clk;
  
          always@(posedge clk)
   
   $display("time=%t, din=%0b, clk=%0b, rst=%0b, dout=%0b", $time,din,clk, rst, dout);
          initial begin 
   
   clk=1'b1;
     rst=0;
      // if din is not initialize it provide X in simulation. 
 #3  rst = 1'b1;     // release reset early

  #2;                 // now we are at t=5 (negedge point if clk starts at 1)

  din = 1'b1;  #10;   // stable at next posedge
  din = 1'b0;  #10;
  din = 1'b1;  #10;
  din = 1'b1;  #10;   
   
  /* simple  to make dout=1; at exact sequence detect
  @(negedge clk) din=1;
  @(negedge clk) din=0;
  @(negedge clk) din=1;
  @(negedge clk) din=1;
  
*/

  #20 $finish;
 end
endmodule  
   
        
       
        
