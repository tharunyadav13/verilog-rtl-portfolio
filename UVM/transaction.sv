import uvm_pkg::*;
`include "uvm_macros.svh"

class my_transaction extends uvm_sequence_item;

  rand bit a;
  rand bit b;
  rand bit cin;
  bit s;
  bit cout;

  constraint range_limit {
    a   inside {0,1};
    b   inside {0,1};
    cin inside {0,1};
  }

  `uvm_object_utils_begin(my_transaction)
    `uvm_field_int(a,    UVM_ALL_ON)
    `uvm_field_int(b,    UVM_ALL_ON)
    `uvm_field_int(cin,  UVM_ALL_ON)
    `uvm_field_int(s,    UVM_ALL_ON)
    `uvm_field_int(cout, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "my_transaction");
    super.new(name);
  endfunction

endclass
