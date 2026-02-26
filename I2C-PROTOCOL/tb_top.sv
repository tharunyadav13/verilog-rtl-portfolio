`include "interface.sv"
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "i2c_coverage.sv"
`include "environment.sv"
`include "test.sv"
`include "i2c_slave_rw.sv"
`include "i2c_slave_rw_sva.sv"

module tb_top;

  logic clk = 0;
  logic rst_n = 0;
  always #5 clk = ~clk;

  initial begin
    #20 rst_n = 1;
  end

  // Interface
  i2c_if inf(.clk(clk), .rst_n(rst_n));

  // ---------------------------
  // ✅ DUT INSTANCE (REAL SLAVE)
  // ---------------------------
  i2c_slave_rw #(.SLAVE_ADDR(7'h50)) DuT (
    .clk          (clk),
    .rst_n        (rst_n),
    .scl          (inf.scl),
    .sda_in       (inf.sda_in),
    .slave_sda_oe (inf.slave_sda_oe),
    .data_valid   ()
  );

  // -----------------------------------------
  // ✅ BIND SVA TO THAT DUT INSTANCE (DuT)
  // -----------------------------------------
bind tb_top.DuT i2c_slave_rw_sva sva_i (
  .clk          (clk),
  .rst_n        (rst_n),

  .scl          (inf.scl),
  .sda_in       (inf.sda_in),
  .slave_sda_oe (inf.slave_sda_oe),

  .state        (state),
  .bit_cnt      (bit_cnt),
  .rd_cnt       (rd_cnt),
  .rw           (rw),
  .addr_match   (addr_match),
  .reg_ptr    (DuT.reg_ptr), 
  .tx_data      (tx_data),
  .data_valid   (data_valid)
);

  test t;

  initial begin
    // bus idle init (master releases SDA, SCL high)
    inf.scl           = 1'b1;
    inf.master_sda_oe = 1'b0;
    // DO NOT drive inf.slave_sda_oe here (DUT drives it)

    t = new(inf);
    t.run();

    #2000 $finish;
  end

endmodule
