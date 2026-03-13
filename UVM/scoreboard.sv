 
import uvm_pkg::*;
`include "uvm_macros.svh"


    class my_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(my_scoreboard)

  uvm_analysis_imp #(my_transaction, my_scoreboard) sb_imp;

  function new(string name = "my_scoreboard", uvm_component parent);
    super.new(name, parent);
    sb_imp = new("sb_imp", this);
  endfunction

  function void write(my_transaction tx);
    bit expected_out;
    bit expected_cout;

    expected_out  = tx.a ^ tx.b ^ tx.cin;
    expected_cout = (tx.a & tx.b) | (tx.b & tx.cin) | (tx.a & tx.cin);

    if ({tx.s, tx.cout} == {expected_out, expected_cout})
      `uvm_info("SCOREBOARD",
                $sformatf("PASS: a=%0d b=%0d cin=%0d s=%0d cout=%0d",
                          tx.a, tx.b, tx.cin, tx.s, tx.cout),
                UVM_LOW)
    else
      `uvm_error("SCOREBOARD",
                 $sformatf("FAIL: a=%0d b=%0d cin=%0d expected_s=%0d expected_cout=%0d got_s=%0d got_cout=%0d",
                           tx.a, tx.b, tx.cin,
                           expected_out, expected_cout,
                           tx.s, tx.cout))
  endfunction

endclass
      
