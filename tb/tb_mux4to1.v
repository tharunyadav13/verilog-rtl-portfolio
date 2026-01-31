`timescale  1ns/1ps 

module tb_mux;
  reg a,b,c,d;
  reg [1:0] sel;
  wire  dout;

  mux4_1 dut(.a(a), .b(b), .c(c), .d(d), .sel(sel), .dout(dout));

  initial begin 
     
    $monitor("$time=%0t, a=%0b, b=%0b, c=%0b, d=%0b, sel=%0b dout=%0b",$time,a,b,c,d,dout);

     a=1'b1;
    b=1'b1;
    c=1'b0;
    d=1'b1;
   #10 sel=2'b01;
   #20  sel=2'b11;

  #50  $finish;
  end 
endmodule 
