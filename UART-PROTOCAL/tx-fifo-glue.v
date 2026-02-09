module tx_fifo_glue (
  input  wire       clk,
  input  wire       rst,          // active-low

  input  wire       tx_busy,
  input  wire       tx_fifo_empty,
  input  wire [7:0] tx_fifo_dout,

  output reg        tx_fifo_rd_en,
  output reg        tx_start,
  output reg  [7:0] tx_data
);

  reg pending;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      tx_fifo_rd_en <= 1'b0;
      tx_start      <= 1'b0;
      tx_data       <= 8'd0;
      pending       <= 1'b0;
    end else begin
      tx_fifo_rd_en <= 1'b0;
      tx_start      <= 1'b0;

      if (pending) begin
        tx_data  <= tx_fifo_dout;
        tx_start <= 1'b1;
        pending  <= 1'b0;
      end else if (!tx_busy && !tx_fifo_empty) begin
        tx_fifo_rd_en <= 1'b1;
        pending       <= 1'b1;
      end
    end
  end
endmodule



