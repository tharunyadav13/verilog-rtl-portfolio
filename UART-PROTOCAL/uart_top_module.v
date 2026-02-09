module uart_top #(
  parameter integer CLK_DIV   = 10,
  parameter bit     parity_en  = 1'b1,
  parameter bit     odd_parity = 1'b0
)(
  input  wire clk,
  input  wire rst,     // active-low

  input  wire       cpu_tx_wr,
  input  wire [7:0] cpu_tx_data,
  output wire       tx_fifo_full,

  input  wire       cpu_rx_rd,
  output wire [7:0] cpu_rx_data,
  output wire       rx_fifo_empty,

  output wire tx,
  input  wire rx
);

  wire baud_tick;
  baud_gen #(.CLK_DIV(CLK_DIV)) u_baud (
    .clk(clk), .rst(rst), .baud_tick(baud_tick)
  );

  // TX FIFO
  wire       tx_fifo_empty;
  wire [7:0] tx_fifo_dout;
  wire       tx_fifo_rd_en;

  fifo16x8 u_tx_fifo (
    .clk(clk), .rst(rst),
    .wr_en(cpu_tx_wr),
    .din  (cpu_tx_data),
    .rd_en(tx_fifo_rd_en),
    .dout (tx_fifo_dout),
    .full (tx_fifo_full),
    .empty(tx_fifo_empty)
  );

  // TX glue
  wire       tx_start;
  wire [7:0] tx_data;
  wire       tx_busy;

  tx_fifo_glue u_glue (
    .clk(clk), .rst(rst),
    .tx_busy(tx_busy),
    .tx_fifo_empty(tx_fifo_empty),
    .tx_fifo_dout(tx_fifo_dout),
    .tx_fifo_rd_en(tx_fifo_rd_en),
    .tx_start(tx_start),
    .tx_data(tx_data)
  );

  // TX FSM
  uart_tx #(.parity_en(parity_en), .odd_parity(odd_parity)) u_tx (
    .clk(clk), .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .baud_tick(baud_tick),
    .tx(tx),
    .tx_busy(tx_busy)
  );

  // RX FSM
  wire [7:0] rx_data;
  wire       rx_valid;
  wire       parity_error;
  wire       frame_error;

  // auto-read from receiver to allow continuous frames (we push into RX FIFO)
  reg rx_read_pulse;

  receiver_fsm #(.CLK_DIV(CLK_DIV), .parity_en(parity_en), .odd_parity(odd_parity)) u_rx (
    .clk(clk), .rst(rst),
    .rx(rx),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .rx_read(rx_read_pulse),
    .parity_error(parity_error),
    .frame_error(frame_error)
  );

  // RX FIFO
  wire rx_fifo_full;
  wire rx_wr_en = rx_valid & ~rx_fifo_full;

  fifo16x8 u_rx_fifo (
    .clk(clk), .rst(rst),
    .wr_en(rx_wr_en),
    .din  (rx_data),
    .rd_en(cpu_rx_rd),
    .dout (cpu_rx_data),
    .full (rx_fifo_full),
    .empty(rx_fifo_empty)
  );

  // pulse rx_read for 1 cycle when we successfully push into rx_fifo
  
  always @(posedge clk or negedge rst) begin
    if (!rst) rx_read_pulse <= 1'b0;
    else      rx_read_pulse <= rx_wr_en;
  end

endmodule
