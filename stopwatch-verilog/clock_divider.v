
module clock_divider #(parameter integer clk_freq = 2)
(
  input  wire clk,
  input  wire rst,        // active-low reset
  output reg  tick_1s
);

  reg [4:0] count;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      tick_1s <= 1'b0;
      count   <= 5'd0;
    end else begin
      tick_1s <= 1'b0;                 

      if (count == clk_freq-1) begin   
        tick_1s <= 1'b1;              
        count   <= 5'd0;
      end else begin
        count <= count + 1'b1;
      end
    end
  end
endmodule
