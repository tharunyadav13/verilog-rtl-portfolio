
import uvm_pkg::*;
`include "uvm_macros.svh"

class my_environment extends uvm_env;

  `uvm_component_utils(my_environment)

  my_agent      agt;
  my_scoreboard sb;

  function new(string name = "my_environment", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agt = my_agent     ::type_id::create("agt", this);
    sb  = my_scoreboard::type_id::create("sb",  this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agt.mon.mon_ap.connect(sb.sb_imp);
  endfunction

endclass
