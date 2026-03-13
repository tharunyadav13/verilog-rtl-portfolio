import uvm_pkg::*;
`include "uvm_macros.svh"

class my_test extends uvm_test;

  `uvm_component_utils(my_test)

  my_environment env;

  function new(string name = "my_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = my_environment::type_id::create("env", this);
  endfunction
  
 

  task run_phase(uvm_phase phase);
    my_sequence seq;

    phase.raise_objection(this);

    seq = my_sequence::type_id::create("seq");
    seq.start(env.agt.sqr);

    phase.drop_objection(this);
  endtask

endclass
    
