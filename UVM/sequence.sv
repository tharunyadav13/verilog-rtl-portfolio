
import uvm_pkg::*;
`include "uvm_macros.svh"


class my_sequence extends uvm_sequence #(my_transaction);

  `uvm_object_utils(my_sequence)

  my_transaction tx;

  function new(string name = "my_sequence");
    super.new(name);
  endfunction

  task body();
    repeat (20) begin
      tx = my_transaction::type_id::create("tx");
      start_item(tx);
      assert(tx.randomize());
      finish_item(tx);
    end
  endtask

endclass
