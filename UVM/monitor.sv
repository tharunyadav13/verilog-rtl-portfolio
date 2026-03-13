
import uvm_pkg::*;
`include "uvm_macros.svh"

class my_monitor extends uvm_monitor;

  `uvm_component_utils(my_monitor)

  virtual full_adder vif;
  uvm_analysis_port #(my_transaction) mon_ap;
  my_transaction tx;

  covergroup fa_cg;
    option.per_instance = 1;

    cp_a : coverpoint tx.a;
    cp_b : coverpoint tx.b;
    cp_c : coverpoint tx.cin;

    abc_cross : cross cp_a, cp_b, cp_c;
  endgroup

  function new(string name = "my_monitor", uvm_component parent);
    super.new(name, parent);
    fa_cg = new();
    mon_ap = new("mon_ap", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(virtual full_adder)::get(this, "", "vif", vif))
      `uvm_fatal("MONITOR", "Unable to get virtual interface")
  endfunction

  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("COV",
      $sformatf("Functional Coverage = %0.2f%%", fa_cg.get_coverage()),
      UVM_LOW)
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);

      tx = my_transaction::type_id::create("tx");

      tx.a    = vif.a;
      tx.b    = vif.b;
      tx.cin  = vif.cin;
      tx.s    = vif.s;
      tx.cout = vif.cout;

      fa_cg.sample();

      `uvm_info("MONITOR",
        $sformatf("Observed: a=%0d b=%0d cin=%0d s=%0d cout=%0d",
                  tx.a, tx.b, tx.cin, tx.s, tx.cout),
        UVM_LOW)

      mon_ap.write(tx);
    end
  endtask

endclass
