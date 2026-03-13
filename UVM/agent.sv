
import uvm_pkg::*;
`include "uvm_macros.svh"

class my_agent extends uvm_agent;
      
      `uvm_component_utils(my_agent)
      
      my_driver drv;
      my_monitor mon;
      my_sequencer sqr;
      
      function new(string name="my_agent", uvm_component parent);
        super.new(name, parent);
      endfunction
        
      function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv=my_driver::type_id::create("drv", this);
        mon=my_monitor::type_id::create("mon", this);
        sqr=my_sequencer::type_id::create("sqr", this);
      endfunction 
      
      
      function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        drv.seq_item_port.connect(sqr.seq_item_export);
        //Sequencer receives the request and sends the transaction.
   
        /*// driver send requestion so driver is port . 
Sequence
   ↓
Sequencer (seq_item_export)
   ↑
Driver (seq_item_port)
        */
      endfunction 
    endclass 
    
