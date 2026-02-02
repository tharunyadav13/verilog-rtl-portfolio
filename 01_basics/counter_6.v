module counter_6(
  //input [2:0]A,
  input D,
  input clk,reset,
  output reg [2:0] Q);

  wire [2:0]count;
   assign count=Q; // here assign q value to count so that new count value will e increment in  13 line .

  always @(posedge clk or negedge reset)begin
    if(!reset)begin
    Q<=3'b0;
    end else 
      Q<=(Q==3'b110)?3'b0:count+3'b001;
    end
endmodule 
