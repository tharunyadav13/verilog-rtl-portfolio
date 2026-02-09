
module tb_uart;
  
  reg clk = 0;
  reg rst = 0;  // active-low

  reg        cpu_tx_wr;
  reg [7:0]  cpu_tx_data;
  wire       tx_fifo_full;

  reg        cpu_rx_rd;
  wire [7:0] cpu_rx_data;
  wire       rx_fifo_empty;

  wire tx;
  wire rx;

  assign rx = tx; // loopback

  uart_top #(
    .CLK_DIV(10),
    .parity_en(1'b1),
    .odd_parity(1'b0)   // even parity
  ) dut (
    .clk(clk), .rst(rst),
    .cpu_tx_wr(cpu_tx_wr),
    .cpu_tx_data(cpu_tx_data),
    .tx_fifo_full(tx_fifo_full),
    .cpu_rx_rd(cpu_rx_rd),
    .cpu_rx_data(cpu_rx_data),
    .rx_fifo_empty(rx_fifo_empty),
    .tx(tx),
    .rx(rx)
  );

  always #5 clk = ~clk;

  initial begin
    $dumpfile("uart_parity_fifo.vcd");
    $dumpvars(0, tb_uart);

    cpu_tx_wr   = 0;
    cpu_tx_data = 8'h00;
    cpu_rx_rd   = 0;

    #200 rst = 1;                 // release reset

    // send 0x65 (ASCII 'e')
    #100;
    cpu_tx_data = 8'h65;
    cpu_tx_wr   = 1;
    #100;
    cpu_tx_wr   = 0;

    // wait for TX+RX (start + 8 data + parity + stop = 11 bits)
    #6000;

    // read back from RX FIFO
    if (!rx_fifo_empty) begin
      cpu_rx_rd = 1;
      #100;
      cpu_rx_rd = 0;
    end

    #15000;
    $display("CPU READ DATA = %h", cpu_rx_data);
    $finish;
  end
endmodule
