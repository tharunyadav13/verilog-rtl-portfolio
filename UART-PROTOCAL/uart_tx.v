
module uart_tx #(
  parameter bit parity_en  = 1'b1,
  parameter bit odd_parity = 1'b0
)(
  input  wire       clk,
  input  wire       rst,        
  input  wire       tx_start,
  input  wire [7:0] tx_data,
  input  wire       baud_tick,
  output reg        tx,
  output reg        tx_busy
);

  typedef enum logic [2:0] {IDLE, START, DATA, PARITY, STOP} state_t;
  state_t present_state;

  reg [2:0] bit_cnt;
  reg [7:0] data_store;
  reg       parity_bit;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      present_state <= IDLE;
      tx            <= 1'b1;
      tx_busy       <= 1'b0;
      bit_cnt       <= 3'd0;
      data_store    <= 8'd0;
      parity_bit    <= 1'b0;
    end else begin
      case (present_state)

        IDLE: begin
          tx      <= 1'b1;
          tx_busy <= 1'b0;
          bit_cnt <= 3'd0;

          if (tx_start) begin
            tx_busy    <= 1'b1;
            data_store <= tx_data;

            if (parity_en) begin
              if (odd_parity) parity_bit <= ~(^tx_data);
              else            parity_bit <=  (^tx_data);
            end else begin
              parity_bit <= 1'b0;
            end

            present_state <= START;
          end
        end

        START: begin
          tx_busy <= 1'b1;
          if (baud_tick) begin
            tx            <= 1'b0;
            present_state <= DATA;
          end
        end

        DATA: begin
          tx_busy <= 1'b1;
          if (baud_tick) begin
            tx <= data_store[bit_cnt];
            if (bit_cnt == 3'd7) begin
              bit_cnt <= 3'd0;
              if (parity_en) present_state <= PARITY;
              else           present_state <= STOP;
            end else begin
              bit_cnt <= bit_cnt + 1'b1;
            end
          end
        end

        PARITY: begin
          tx_busy <= 1'b1;
          if (baud_tick) begin
            tx            <= parity_bit;
            present_state <= STOP;
          end
        end

        STOP: begin
          tx_busy <= 1'b1;
          if (baud_tick) begin
            tx            <= 1'b1;
            present_state <= IDLE;
          end
        end

        default: present_state <= IDLE;

      endcase
    end
  end
endmodule
