module and_gate(
  input Q1,
  input Q0,
  output wire z);
  
assign z = Q1&Q0;

endmodule 



module mod_8(
  input j,
  input k,
  input clk,reset,
  output reg Q,
  output wire Q_bar);

  always@(posedge clk or negedge reset)begin 
    if(!reset)begin 
      Q<=1'b0;
    end
    else begin
    case({j,k})
      2'b00 : Q <=Q;
      2'b01 :Q <=1'b0;
      2'b10:Q <=1'b1;
      2'b11:Q <=~Q;
      default: Q <= 1'b0;
    endcase
    end
  end 
 assign Q_bar=~Q;
endmodule 
   
  
module top_module(
  input clk,
  input reset,
  output wire Q0,Q1,Q2,
  output wire Q0_bar, Q1_bar,Q2_bar);

  wire z;
  and_gate gt(.Q1(Q1),.Q0(Q0), .z(z));
  mod_8 UT(.clk(clk), .reset(reset), .Q(Q0), .Q_bar(Q0_bar), .j(1'b1), .k(1'b1));
  mod_8 UT1(.clk(clk), .reset(reset), .Q(Q1), .Q_bar(Q1_bar), .j(Q0), .k(Q0));
  mod_8 UUT(.clk(clk), .reset(reset), .Q(Q2), .Q_bar(Q2_bar), .j(z), .k(z));
endmodule 
  
              
        
