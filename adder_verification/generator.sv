class generator;
  int count = 5;
  mailbox gen_to_drv;

  function new(mailbox gen_to_drv);
    this.gen_to_drv = gen_to_drv;
  endfunction

  task run();
    transaction tr;
    repeat (count) begin
      tr = new();
      assert(tr.randomize()) else $fatal("Randomization failed");
      gen_to_drv.put(tr);
    end
  endtask
endclass
