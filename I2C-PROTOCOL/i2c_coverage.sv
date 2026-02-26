class i2c_coverage;

  bit [6:0] addr;
  bit       rw;
  byte      reg_addr;

  bit       addr_ack;
  bit       reg_ack;

  int unsigned write_len;
  byte         first_wdata;

  covergroup cg_i2c;
    option.per_instance = 1;

    cp_addr: coverpoint addr {
      bins good_addr  = {7'h50};
      bins other_addr = default;
    }

    cp_rw: coverpoint rw {
      bins write = {0};
      bins read  = {1};
    }

    cp_addr_ack: coverpoint addr_ack { bins ACK={1}; bins NACK={0}; }
    cp_reg_ack : coverpoint reg_ack  { bins ACK={1}; bins NACK={0}; }

    cp_reg: coverpoint reg_addr iff (addr_ack==1) {
      bins dev_id   = {8'h00};
      bins version  = {8'h01};
      bins cfg_20   = {8'h20};
      bins low_regs = {[8'h02:8'h0F]};
      bins mid_regs = {[8'h10:8'h7F]};
      bins hi_regs  = {[8'h80:8'hFF]};
    }

    cp_wlen: coverpoint write_len iff (rw==0) {
      illegal_bins len0 = {0};
      bins len1   = {1};
      bins len2   = {2};
      bins len3_4 = {[3:4]};
      bins len5_8 = {[5:8]};
      bins len9_16 = {[9:16]};
      bins len17_plus = {[17:$]};
    }

    cp_first: coverpoint first_wdata iff (rw==0) {
      bins zero   = {8'h00};
      bins ones   = {8'hFF};
      bins aa     = {8'hAA};
      bins fifty5 = {8'h55};
      bins other  = default;
    }

    x_rw_ack : cross cp_rw,  cp_addr_ack;
    x_reg_len: cross cp_reg, cp_wlen;

  endgroup

  function new();
    cg_i2c = new();
  endfunction

  function void sample(transaction tr);
    addr     = tr.addr;
    rw       = tr.rw;
    reg_addr = tr.reg_addr;

    addr_ack = tr.addr_ack;
    reg_ack  = tr.reg_ack;

    write_len = tr.write_data.size();

    if (write_len > 0)
      first_wdata = tr.write_data[0];
    else
      first_wdata = 8'h00;

    cg_i2c.sample();
  endfunction

  function real get_cov();
    return cg_i2c.get_coverage();
  endfunction

endclass
