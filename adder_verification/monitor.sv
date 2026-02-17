class monitor;
  virtual add_if vif;
  mailbox mon_to_sb;

  function new(mailbox mon_to_sb, virtual add_if vif);
    this.mon_to_sb = mon_to_sb;
    this.vif       = vif;
  endfunction

  task run();
    forever begin
      transaction mon_tr;

      wait (vif.reset == 1'b1);

      @(posedge vif.clk);
      mon_tr = new();
      mon_tr.A = vif.A;
      mon_tr.B = vif.B;

      @(posedge vif.clk);      
      mon_tr.out = vif.out;

      mon_to_sb.put(mon_tr);
      $display("MON @%0t : A=%0d B=%0d OUT=%0d", $time, mon_tr.A, mon_tr.B, mon_tr.out);
    end
  endtask
endclass
