module i2c_slave_rw #(
  parameter logic [6:0] SLAVE_ADDR = 7'h50
)(
  input  logic       clk,          // (not used now, ok to keep)
  input  logic       rst_n,          // active-low reset

  input  logic       scl,
  input  logic       sda_in,

  output logic       slave_sda_oe,   // 1=pull SDA low, 0=release(Z)
  output logic       data_valid
);

  typedef enum logic [2:0] {
    ST_IDLE,
    ST_ADDR_BITS,
    ST_ADDR_ACK,
    ST_WRITE_BITS,
    ST_WRITE_ACK,
    ST_READ_BITS,
    ST_READ_ACK
  } state_t;

  state_t state;

  logic [7:0] shreg;
  logic [2:0] bit_cnt;
  logic       rw;
  logic       addr_match;

  logic [7:0] tx_data;
  logic [2:0] rd_cnt;

  logic [7:0] reg_ptr;
  logic       expect_reg_addr;

  logic [7:0] mem [0:255];
  integer     i;

  // Questa-safe temps
  logic [7:0] rx_byte;
  logic       bit_to_send;

  // ---- START/STOP detection (SCL domain) ----
  logic sda_prev;

  always @(posedge scl or negedge rst_n) begin
    if (!rst_n) sda_prev <= 1'b1;
    else        sda_prev <= sda_in;
  end

  wire start_cond = (scl == 1'b1) && (sda_prev == 1'b1) && (sda_in == 1'b0);
  wire stop_cond  = (scl == 1'b1) && (sda_prev == 1'b0) && (sda_in == 1'b1);

  // ---- FSM: sample on SCL rising edge ----
  always @(posedge scl or negedge rst_n) begin
    if (!rst_n) begin
      state      <= ST_IDLE;
      shreg      <= 8'h00;
      bit_cnt    <= 3'd0;
      rw         <= 1'b0;
      addr_match <= 1'b0;

      data_valid <= 1'b0;

      tx_data <= 8'hA5;
      rd_cnt  <= 3'd0;

      reg_ptr         <= 8'h00;
      expect_reg_addr <= 1'b1;

      for (i = 0; i < 256; i = i + 1)
        mem[i] <= 8'h00;

      mem[8'h00] <= 8'hAB;
      mem[8'h01] <= 8'h10;

      rx_byte <= 8'h00;

    end else begin
      data_valid <= 1'b0;

      // STOP has priority
      if (stop_cond) begin
        state      <= ST_IDLE;
        bit_cnt    <= 3'd0;
        rd_cnt     <= 3'd0;
        shreg      <= 8'h00;
        addr_match <= 1'b0;
      end

      // START (or Re-START)
      else if (start_cond) begin
        state      <= ST_ADDR_BITS;
        shreg      <= 8'h00;
        bit_cnt    <= 3'd0;
        addr_match <= 1'b0;
      end

      else begin
        case (state)

          ST_IDLE: begin
            // wait for START condition
          end

          ST_ADDR_BITS: begin
            shreg <= {shreg[6:0], sda_in};

            if (bit_cnt == 3'd7) begin
              rw         <= sda_in;
              addr_match <= ({shreg[6:0], sda_in}[7:1] == SLAVE_ADDR);
              state      <= ST_ADDR_ACK;
              bit_cnt    <= 3'd0;
            end else begin
              bit_cnt <= bit_cnt + 3'd1;
            end
          end

          ST_ADDR_ACK: begin
            if (addr_match) begin
              if (rw == 1'b0) begin
                state           <= ST_WRITE_BITS;
                shreg           <= 8'h00;
                bit_cnt         <= 3'd0;
                expect_reg_addr <= 1'b1;
              end else begin
                tx_data <= mem[reg_ptr];
                rd_cnt  <= 3'd0;
                state   <= ST_READ_BITS;
              end
            end else begin
              state <= ST_IDLE;
            end
          end

          ST_WRITE_BITS: begin
            shreg <= {shreg[6:0], sda_in};

            if (bit_cnt == 3'd7) begin
              rx_byte = {shreg[6:0], sda_in};

              if (expect_reg_addr) begin
                reg_ptr         <= rx_byte;
                expect_reg_addr <= 1'b0;
              end else begin
                mem[reg_ptr] <= rx_byte;
                reg_ptr      <= reg_ptr + 8'd1;
              end

              data_valid <= 1'b1;
              state      <= ST_WRITE_ACK;
              bit_cnt    <= 3'd0;
            end else begin
              bit_cnt <= bit_cnt + 3'd1;
            end
          end

          ST_WRITE_ACK: begin
            state   <= ST_WRITE_BITS;
            shreg   <= 8'h00;
            bit_cnt <= 3'd0;
          end

          ST_READ_BITS: begin
            if (rd_cnt == 3'd7) begin
              state  <= ST_READ_ACK;
              rd_cnt <= 3'd0;
            end else begin
              rd_cnt <= rd_cnt + 3'd1;
            end
          end

          ST_READ_ACK: begin
            if (sda_in == 1'b0) begin
              reg_ptr <= reg_ptr + 8'd1;
              tx_data <= mem[reg_ptr + 8'd1];
              rd_cnt  <= 3'd0;
              state   <= ST_READ_BITS;
            end else begin
              state <= ST_IDLE;
            end
          end

          default: state <= ST_IDLE;

        endcase
      end
    end
  end

  // ---- Drive SDA on SCL falling edge ----
  always @(negedge scl or negedge rst_n) begin
    if (!rst_n) begin
      slave_sda_oe <= 1'b0;
    end else begin
      slave_sda_oe <= 1'b0;

      if (state == ST_ADDR_ACK) begin
        if (addr_match)
          slave_sda_oe <= 1'b1;  // ACK address
      end
      else if (state == ST_WRITE_ACK) begin
        slave_sda_oe <= 1'b1;    // ACK write bytes
      end
      else if (state == ST_READ_BITS) begin
        bit_to_send  = tx_data[7 - rd_cnt];
        slave_sda_oe <= (bit_to_send == 1'b0);
      end
      else begin
        slave_sda_oe <= 1'b0;
      end
    end
  end

endmodule
