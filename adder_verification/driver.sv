class driver;
  virtual add_if vif;
  mailbox gen_to_drv;

  function new(mailbox gen_to_drv, virtual add_if vif);
    this.gen_to_drv = gen_to_drv;
    this.vif        = vif;
  endfunction

  task run();
    transaction tr;
    forever begin
      gen_to_drv.get(tr);
      @(posedge vif.clk);
      vif.A <= tr.A;
      vif.B <= tr.B;
      $display("DRV @%0t : A=%0d B=%0d", $time, tr.A, tr.B);
    end
  endtask
endclass
