module shift_cntr(
  input A,
  input c,
  input xo,
  input x3,
  output wire z);

  assign z=(A&~c)&x3|(c&xo);
endmodule 

module  cir_y3(
  input s,
  input z,
  input x3,
  output  wire y3);

  wire  c0, c1,c2;

  and  g1 (c1,s,z);
  not g2(c0,s);
  and g3 (c2,c0,x3);
  or g4(y3,c2,c1);
endmodule 

module  y2(
  input s,
  input x3,
  input x2,
  output wire y2);
   assign y2=s?x3:x2;
endmodule 

module y1(
  input s,
  input x2,
  input x1,
  output wire y1);

  assign y1=s?x2:x1;
endmodule 

module y0(
  input s,
  input x0,
  input x1,
  output wire y0);

  assign y0=s?x1:x0;
endmodule 

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

                     
  
  
