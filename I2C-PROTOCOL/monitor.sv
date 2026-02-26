class monitor;

  virtual i2c_if vif;
  mailbox mon_to_sb;

  function new(mailbox mon_to_sb, virtual i2c_if vif);
    this.mon_to_sb = mon_to_sb;
    this.vif       = vif;
  endfunction

  task automatic wait_start();
    bit prev_sda;
    prev_sda = vif.sda_in;
    forever begin
      @(vif.sda_in or vif.scl);
      if (vif.scl == 1'b1 && prev_sda == 1'b1 && vif.sda_in == 1'b0)
        return;
      prev_sda = vif.sda_in;
    end
  endtask

  task automatic wait_stop();
    bit prev_sda;
    prev_sda = vif.sda_in;
    forever begin
      @(vif.sda_in or vif.scl);
      if (vif.scl == 1'b1 && prev_sda == 1'b0 && vif.sda_in == 1'b1)
        return;
      prev_sda = vif.sda_in;
    end
  endtask

  task automatic read_byte(output byte unsigned data);
    data = 8'h00;
    for (int k = 7; k >= 0; k--) begin
      @(posedge vif.scl);
      data[k] = vif.sda_in;
    end
  endtask

  task automatic read_ack(output bit ack);
    bit ackb;
    @(posedge vif.scl);
    ackb = vif.sda_in;
    ack  = (ackb == 1'b0);
  endtask

  task run();
    transaction mon_tr;
    byte unsigned b;
    byte unsigned d;
    bit ack;

    forever begin
      wait_start();

      mon_tr = new();
      mon_tr.write_data = {};   // clear queue safely

      // Address + R/W
      read_byte(b);
      mon_tr.addr = b[7:1];
      mon_tr.rw   = b[0];

      read_ack(ack);
      mon_tr.addr_ack = ack;

      // Only handle write (rw=0) for this check
      if (mon_tr.rw != 1'b0) begin
        wait_stop();
        continue;
      end

      // Register address
      read_byte(mon_tr.reg_addr);
      read_ack(ack);
      mon_tr.reg_ack = ack;

      // Data bytes (we expect 2 bytes in this unit test)
      repeat (2) begin
        read_byte(d);
        read_ack(ack);
        mon_tr.write_data.push_back(d);
      end

      // STOP
      wait_stop();

      mon_to_sb.put(mon_tr);
    end
  endtask

endclass
