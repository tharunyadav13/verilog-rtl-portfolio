
// calling all using instantiation .
module barrel_shifter(
  input A,
  input s,
  input [3:0]x,
  input c,
  output wire y0,y1,y2,y3);

  wire z;

  // this all just connect blocks the values we provide that calculate like above instance logics . this are just blocks connecting  
  shift_cntr UT( .A(A), .c(c), .xo(x[0]), .x3(x[3]), .z(z));
  cir_y3  UT1( .s(s), .z(z), .x3(x[3]), .y3(y3));
  y2 UT2(.s(s), .x3(x[3]), .x2(x[2]), .y2(y2));
              y1 ut3(.s(s), .x1(x[1]), .x2(x[2]), .y1(y1));
   y0 ut4( .s(s), .x0(x[0]), .x1(x[1]), .y0(y0));
     endmodule 

                     
  
   `timescale 1ns/1ps

module test_bench;
   reg A;
   reg s;
   reg [3:0]x;
   reg c;
   wire y0, y1, y2,y3;
   
   wire z;
   
  barrel_shifter UTT(.A(A), .s(s), .x(x), .c(c), .y0(y0), .y1(y1), .y2(y2), .y3(y3));
   
  initial begin 
    
    $dumpfile("barrel_shifter.vcd");
    $dumpvars(0, test_bench);
    
    $monitor("time=%t, A=%0b, s=%0b, x=%0b, c=%0b, y0=%b, y1=%b, y2=%b, y3=%b", $time, A, s, x, c, y0, y1, y2, y3);
    
    A=1'b0; s=1'b1; c=1'b1;
    x = 4'b1011;
    
    #2 A=1'b1; s=1'b0; c=1'b1;
     x = {1'b1, 1'b0, 1'b1, 1'b1}; // x3 x2 x1 x0
    
  /*  //If s = 1 (RIGHT SHIFT by 1)

y3 = z

y2 = x3

y1 = x2

y0 = x1

So output becomes: "1101" for second case .
*/
    
    #4 $finish;  // delay showing in wave in ps(pico seconds).
  end 
    endmodule 
