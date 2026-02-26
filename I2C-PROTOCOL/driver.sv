class driver;

  mailbox gen_to_drv;
  virtual i2c_if vif;
  transaction tr;

  function new(mailbox gen_to_drv, virtual i2c_if vif);
    this.gen_to_drv = gen_to_drv;
    this.vif        = vif;
  endfunction


  // ----------------------------
  // Delay
  // ----------------------------
  task automatic i2c_delay();
    #50;
  endtask


  // ----------------------------
  // START condition
  // ----------------------------
  task automatic i2c_start();
    vif.master_sda_oe <= 1'b0;   // release SDA (HIGH)
    vif.scl           <= 1'b1;
    i2c_delay();

    vif.master_sda_oe <= 1'b1;   // pull SDA LOW
    i2c_delay();

    vif.scl           <= 1'b0;
    i2c_delay();
  endtask


  // ----------------------------
  // STOP condition
  // ----------------------------
  task automatic i2c_stop();
    vif.master_sda_oe <= 1'b1;   // keep SDA LOW
    vif.scl           <= 1'b0;
    i2c_delay();

    vif.scl           <= 1'b1;
    i2c_delay();

    vif.master_sda_oe <= 1'b0;   // release SDA (goes HIGH)
    i2c_delay();
  endtask


  // ----------------------------
  // Write one bit
  // ----------------------------
  task automatic i2c_write_bit(bit b);
    vif.scl <= 1'b0;

    if (b == 1'b0)
      vif.master_sda_oe <= 1'b1;   // pull LOW
    else
      vif.master_sda_oe <= 1'b0;   // release (HIGH)

    i2c_delay();

    vif.scl <= 1'b1;
    i2c_delay();

    vif.scl <= 1'b0;
    i2c_delay();
  endtask


  // ----------------------------
  // Read one bit
  // ----------------------------
  task automatic i2c_read_bit(output bit b);
    vif.scl           <= 1'b0;
    vif.master_sda_oe <= 1'b0;   // release SDA

    i2c_delay();

    vif.scl <= 1'b1;
    i2c_delay();

    b = vif.sda_in;

    vif.scl <= 1'b0;
    i2c_delay();
  endtask


  // ----------------------------
  // Write one byte
  // ----------------------------
  task automatic i2c_write_byte(input byte data, output bit ack);
    bit ackb;   // declaration MUST be first

    for (int k = 7; k >= 0; k--) begin
      i2c_write_bit(data[k]);
    end

    i2c_read_bit(ackb);
    ack = (ackb == 1'b0);
  endtask


  // ----------------------------
  // Main run task
  // ----------------------------
  task run();
    bit ack;   // declaration MUST be before statements

    vif.scl           <= 1'b1;
    vif.master_sda_oe <= 1'b0;

    forever begin
      gen_to_drv.get(tr);

      i2c_start();

      i2c_write_byte({tr.addr, 1'b0}, ack);
      if (!ack) $display("DRV: No ACK on address");

      i2c_write_byte(tr.reg_addr, ack);
      if (!ack) $display("DRV: No ACK on reg_addr");

      foreach (tr.write_data[idx]) begin
        i2c_write_byte(tr.write_data[idx], ack);
        if (!ack)
          $display("DRV: No ACK on data idx %0d", idx);
      end

      i2c_stop();
    end
  endtask

endclass
