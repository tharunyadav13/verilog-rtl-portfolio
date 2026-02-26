class generator;

  mailbox gen_to_drv;
  transaction tr;

  function new(mailbox gen_to_drv);
    this.gen_to_drv = gen_to_drv;
  endfunction

  task run();
    tr = new();
    if (!tr.randomize())
      $fatal("GEN: Randomization failed");

    $display("GEN: addr=%02h reg=%02h data=%p",
             tr.addr, tr.reg_addr, tr.write_data);

    gen_to_drv.put(tr);
  endtask

endclass
