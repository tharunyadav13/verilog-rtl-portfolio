interface i2c_if (
  input  logic clk,
  input  logic rst_n
);

  logic scl;
  tri1  sda;

  logic master_sda_oe;
  logic slave_sda_oe;

  assign sda = (master_sda_oe || slave_sda_oe) ? 1'b0 : 1'bz;

  logic sda_in;
  assign sda_in = sda;

endinterface
