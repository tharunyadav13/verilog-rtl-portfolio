bind i2c_slave_rw i2c_slave_rw_sva #(.SLAVE_ADDR(7'h67)) sva_i (
  .clk          (clk),
  .rst_n        (rst_n),
  .scl          (scl),
  .sda_in       (sda_in),
  .slave_sda_oe (slave_sda_oe),

  .state        (state),
  .bit_cnt      (bit_cnt),
  .rd_cnt       (rd_cnt),
  .rw           (rw),
  .addr_match   (addr_match),
  .reg_ptr      (reg_ptr),
  .tx_data      (tx_data),
  .data_valid   (data_valid)
);
