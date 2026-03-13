
 module tb_top;

    import uvm_pkg::*;
`include "uvm_macros.svh"

  
  logic clk;

  initial
    clk = 0;

  always #5 clk = ~clk;

  full_adder vif(clk);

  full_adder_DUT DUT(
    .a(vif.a),
    .b(vif.b),
    .cin(vif.cin),
    .s(vif.s),
    .cout(vif.cout)
  );

  initial begin
    uvm_config_db#(virtual full_adder)::set(null, "*", "vif", vif);
    run_test("my_test");
  end

endmodule
