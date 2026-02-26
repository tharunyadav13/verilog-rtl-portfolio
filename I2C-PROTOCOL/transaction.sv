class transaction;

  rand bit [6:0] addr;
  rand bit       rw;
  rand bit [7:0] reg_addr;

  rand int unsigned read_len;
  rand byte unsigned write_data[$];

  bit addr_ack;
  bit reg_ack;

  constraint c_addr { addr == 7'h67; }
  constraint c_reg  { reg_addr == 8'h20; }
  constraint c_size { write_data.size() == 2; }
  constraint c_rw   { rw == 1'b0; }
  constraint c_len  { read_len == 0; }

endclass
