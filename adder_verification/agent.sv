class agent;
  driver    drv;
  monitor   mon;
  generator gen;

  mailbox gen_to_drv;
  mailbox mon_to_sb;

  function new(virtual add_if vif, mailbox mon_to_sb);
    this.mon_to_sb = mon_to_sb;

    gen_to_drv = new();
    drv = new(gen_to_drv, vif);
    mon = new(mon_to_sb,  vif);
    gen = new(gen_to_drv);
  endfunction

  task run();
    fork
      gen.run();
      drv.run();
      mon.run();
    join_any
    disable fork;
  endtask
endclass
