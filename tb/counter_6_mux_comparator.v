module tb_counter;
  reg D;
   reg clk, reset;
  wire [2:0]Q;
  
  counter_6 DUT(.clk(clk), .reset(reset), .D(D),  .Q(Q));

  always #5 clk=~clk;

  always@(posedge clk)begin
    $display("time=%t,  D=%b, clk=%b, reset=%b, Q=%b", $time,  D, clk, reset, Q);
  end 
  
  initial begin
  //  $monitor("time=%t,  D=%b, clk=%b, reset=%b, Q=%b", $time,  D, clk, reset, Q);
  
     clk=1'b0;
    D=1'b0;
  
    reset=0;
   //   A=3'b000;
    #2 reset=1;
 
   #100 $finish;
 
  end
endmodule 
