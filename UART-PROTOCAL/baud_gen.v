module baud_gen #(
  parameter integer CLK_DIV = 10   // how many clk cycles per baud tick (your style)
)(
  input  wire clk,
  input  wire rst,                 
  output reg  baud_tick
);

  reg [3:0] clk_count;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      baud_tick <= 1'b0;
      clk_count <= 4'd0;
    end else begin
      baud_tick <= 1'b0;                 // default
      if (clk_count == (CLK_DIV-1)) begin
        baud_tick <= 1'b1;               // 1-cycle pulse
        clk_count <= 4'd0;
      end else begin
        clk_count <= clk_count + 1'b1;
      end
    end
  end

endmodule

