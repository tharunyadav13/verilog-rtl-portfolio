
import uvm_pkg::*;
`include "uvm_macros.svh"

class my_driver extends uvm_driver #(my_transaction);

  `uvm_component_utils(my_driver)

  virtual full_adder vif;

  function new(string name = "my_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual full_adder)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Not found the interface from test")
    else
      `uvm_info("DRIVER", "Got the interface from test", UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);

      @(posedge vif.clk);
      vif.a   <= req.a;
      vif.b   <= req.b;
      vif.cin <= req.cin;

      seq_item_port.item_done();
    end
  endtask

endclass
