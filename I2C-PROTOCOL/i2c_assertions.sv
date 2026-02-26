module i2c_slave_rw_sva (
  input  logic       clk,          
  input  logic       rst_n,

  input  logic       scl,
  input  logic       sda_in,

  input  logic       slave_sda_oe,

  input  logic [2:0] state,
  input  logic [2:0] bit_cnt,
  input  logic [2:0] rd_cnt,
  input  logic       rw,
  input  logic       addr_match,
  input  logic [7:0] reg_ptr,
  input  logic [7:0] tx_data,
  input  logic       data_valid
);

  localparam logic [2:0]
    ST_IDLE       = 3'd0,
    ST_ADDR_BITS  = 3'd1,
    ST_ADDR_ACK   = 3'd2,
    ST_WRITE_BITS = 3'd3,
    ST_WRITE_ACK  = 3'd4,
    ST_READ_BITS  = 3'd5,
    ST_READ_ACK   = 3'd6;

  // START/STOP detection sampled on clk (NOT posedge scl)
  logic sda_prev;
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) sda_prev <= 1'b1;
    else        sda_prev <= sda_in;
  end

  wire start_cond = (scl==1'b1) && (sda_prev==1'b1) && (sda_in==1'b0);
  wire stop_cond  = (scl==1'b1) && (sda_prev==1'b0) && (sda_in==1'b1);

  // SDA must be stable when SCL=1 (except start/stop)
 a_sda_stable_when_scl_high: assert property (@(posedge clk) disable iff (!rst_n)
      (scl && !start_cond && !stop_cond) |-> $stable(sda_in)
);
  // Reset expectations (check on SCL domain)
  a_reset_state_idle: assert property (@(posedge scl) (!rst_n) |-> (state==ST_IDLE))
    else $error("SVA: state not IDLE during reset");

  a_reset_release_sda: assert property (@(negedge scl) (!rst_n) |-> (slave_sda_oe==1'b0))
    else $error("SVA: slave_sda_oe not released during reset");

  // START → go to ADDR_BITS (next SCL edge after START is seen)
  a_start_to_addr_bits: assert property (@(posedge scl) disable iff (!rst_n)
      start_cond |=> (state==ST_ADDR_BITS)
  ) else $error("SVA: START did not lead to ST_ADDR_BITS");

  // STOP forces IDLE
  a_stop_to_idle: assert property (@(posedge scl) disable iff (!rst_n)
      stop_cond |=> (state==ST_IDLE)
  ) else $error("SVA: STOP did not force ST_IDLE");

  // Address bit count increments
  a_addr_bitcnt_incr: assert property (@(posedge scl) disable iff (!rst_n)
      (state==ST_ADDR_BITS && $past(state)==ST_ADDR_BITS && $past(bit_cnt)!=3'd7)
        |-> (bit_cnt == $past(bit_cnt)+3'd1)
  ) else $error("SVA: bit_cnt did not increment in ST_ADDR_BITS");

  // last addr bit → ACK state
  a_addr_last_to_ack: assert property (@(posedge scl) disable iff (!rst_n)
      ($past(state)==ST_ADDR_BITS && $past(bit_cnt)==3'd7) |-> (state==ST_ADDR_ACK)
  ) else $error("SVA: ST_ADDR_BITS(last) did not go to ST_ADDR_ACK");

  // Write bit count increments
  a_write_bitcnt_incr: assert property (@(posedge scl) disable iff (!rst_n)
      (state==ST_WRITE_BITS && $past(state)==ST_WRITE_BITS && $past(bit_cnt)!=3'd7)
        |-> (bit_cnt == $past(bit_cnt)+3'd1)
  ) else $error("SVA: bit_cnt did not increment in ST_WRITE_BITS");

  // last write bit → WRITE_ACK + data_valid pulse
  a_write_last_to_write_ack: assert property (@(posedge scl) disable iff (!rst_n)
      ($past(state)==ST_WRITE_BITS && $past(bit_cnt)==3'd7)
        |-> (state==ST_WRITE_ACK && data_valid==1'b1)
  ) else $error("SVA: write byte did not go to ST_WRITE_ACK or data_valid not 1");

  // WRITE_ACK should go back to WRITE_BITS
  a_write_ack_to_bits: assert property (@(posedge scl) disable iff (!rst_n)
      ($past(state)==ST_WRITE_ACK) |-> (state==ST_WRITE_BITS)
  ) else $error("SVA: ST_WRITE_ACK did not return to ST_WRITE_BITS");

  // During READ_ACK slave must release SDA
  a_release_during_read_ack: assert property (@(negedge scl) disable iff (!rst_n)
      (state==ST_READ_ACK) |-> (slave_sda_oe==1'b0)
  ) else $error("SVA: slave_sda_oe not released in ST_READ_ACK");

  // ACK on address match
  a_drive_addr_ack: assert property (@(negedge scl) disable iff (!rst_n)
      (state==ST_ADDR_ACK && addr_match) |-> (slave_sda_oe==1'b1)
  ) else $error("SVA: did not ACK address when addr_match=1");

  // No ACK on address miss
  a_no_ack_on_addr_miss: assert property (@(negedge scl) disable iff (!rst_n)
      (state==ST_ADDR_ACK && !addr_match) |-> (slave_sda_oe==1'b0)
  ) else $error("SVA: ACKed even though addr_match=0");

  // ACK each write byte
  a_drive_write_ack: assert property (@(negedge scl) disable iff (!rst_n)
      (state==ST_WRITE_ACK) |-> (slave_sda_oe==1'b1)
  ) else $error("SVA: did not ACK write byte in ST_WRITE_ACK");

  // Read drive matches tx_data bit
  a_read_bit_drive_matches_tx: assert property (@(negedge scl) disable iff (!rst_n)
      (state==ST_READ_BITS) |-> (slave_sda_oe == (tx_data[7-rd_cnt]==1'b0))
  ) else $error("SVA: slave_sda_oe != expected tx_data bit");

  // data_valid only when completing byte
  a_data_valid_one_cycle: assert property (@(posedge scl) disable iff (!rst_n)
      data_valid |-> ($past(state)==ST_WRITE_BITS && $past(bit_cnt)==3'd7)
  ) else $error("SVA: data_valid asserted outside write-byte completion");

endmodule
