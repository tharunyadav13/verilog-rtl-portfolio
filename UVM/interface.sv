
import uvm_pkg::*;
`include "uvm_macros.svh"

interface full_adder(input logic clk);

  logic rst;
  logic a;
  logic b;
  logic cin;
  logic s;
  logic cout;

  property sum_check;
    @(posedge clk) s == (a ^ b ^ cin);
  endproperty

  property carry_check;
    @(posedge clk) cout == ((a & b) | (b & cin) | (a & cin));
  endproperty

  assert property (sum_check)
    else $error("SUM assertion failed at time=%0t", $time);

  assert property (carry_check)
    else $error("COUT assertion failed at time=%0t", $time);

endinterface
