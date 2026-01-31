module mux4_1(
   input  a,
  input b, 
  input c,
  input d,
  input [1:0] sel,  // sel output decide 
  output reg dout);

  always@(*)begin  // sensitivity list 
    case(sel)
      2'b00: dout=a;
      2'b01: dout=b;
      2'b10: dout=c;
      2'b11: dout=d;
      default : dout=1'b0;  // defalut value if not any value assign 
    endcase
    end
    endmodule 


// one line 4:1 mux;

// assign dout=(sel==2'b00)?a:(sel==2'b01)?b:(sel==2'b10)?c:d;
