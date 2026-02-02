
// complete code depend on top module and work with negedge. 
module tb_mod8;
  reg clk;
  reg j,k;
  reg reset;
  wire Q0,Q1,Q2;
  wire Q1_bar, Q2_bar, Q0_bar;

  top_module DUT(.clk(clk), .reset(reset), .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q0_bar(Q0_bar), .Q1_bar(Q1_bar), .Q2_bar(Q2_bar));
  
  always #5 clk=~clk;

 initial begin 
   $monitor("time=%t, clk=%0b, reset=%0b,  Q2=%0b, Q1=%b, Q0=%b",$time,clk,reset,Q2,Q1,Q0,);
  
  clk=1'b1;
   
    $dumpfile("mod8_negedge.vcd");   // VCD file name
  $dumpvars(0, tb_mod8); 
 
   
   reset=1'b0; // reset is active low it come back to original state.
   
   #2 reset=1'b1;
 
   // we cannot drive this signals because we already  used this wires in Dut we are connecting them.
  // the Q0, Q1,Q2 are output of DUT . we cannot drive them .
   #75 $finish;
 end
endmodule 

//in tb 
/* 
to print only negedge use always@(negedge clk)begin
$display();
*/

   

              
        
