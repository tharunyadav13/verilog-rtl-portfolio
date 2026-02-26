class agent;

  virtual i2c_if vif;

  mailbox gen_to_drv;
  mailbox mon_to_sb;

  generator gen;
  driver    drv;
  monitor   mon;

  function new(mailbox mon_to_sb, virtual i2c_if vif);
    this.vif       = vif;
    this.mon_to_sb = mon_to_sb;

    gen_to_drv = new();

    gen = new(gen_to_drv);
    drv = new(gen_to_drv, vif);
    mon = new(mon_to_sb, vif);
  endfunction

  task run();
    // TB init (use blocking)
    vif.scl           = 1'b1;
    vif.master_sda_oe = 1'b0;

    fork
      drv.run();
      mon.run();
      gen.run();   // one transaction
    join_none
  endtask

endclass
