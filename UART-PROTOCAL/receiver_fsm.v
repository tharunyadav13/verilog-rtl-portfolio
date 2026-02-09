module receiver_fsm #(
  parameter integer CLK_DIV    = 10,
  parameter bit     parity_en  = 1'b1,
  parameter bit     odd_parity = 1'b0
)(
  input  wire       clk,
  input  wire       rst,
  input  wire       rx,

  output reg  [7:0] rx_data,
  output reg        rx_valid,     
  input  wire       rx_read,      

  output reg        parity_error,
  output reg        frame_error
);

  typedef enum logic [2:0] {IDLE, START, DATA, PARITY, STOP} state_t;
  state_t present_state;

  reg [2:0] bit_cnt;
  reg [3:0] clk_cnt;

  reg [7:0] rx_shift;
  reg       rx_parity_bit;
  reg       expected_parity;

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      rx_data         <= 8'd0;
      rx_shift        <= 8'd0;
      rx_valid        <= 1'b0;
      parity_error    <= 1'b0;
      frame_error     <= 1'b0;

      bit_cnt         <= 3'd0;
      clk_cnt         <= 4'd0;
      rx_parity_bit   <= 1'b0;
      expected_parity <= 1'b0;

      present_state   <= IDLE;
    end else begin
      if (rx_valid && rx_read) begin
        rx_valid     <= 1'b0;
        parity_error <= 1'b0;
        frame_error  <= 1'b0;
      end

      case (present_state)

        IDLE: begin
          clk_cnt <= 4'd0;
          bit_cnt <= 3'd0;
          if (!rx_valid && rx == 1'b0)
            present_state <= START;
        end

        START: begin
          if (clk_cnt == (CLK_DIV/2 - 1)) begin
            clk_cnt <= 4'd0;
            if (rx == 1'b0) begin
              rx_shift <= 8'd0;
              present_state <= DATA;
            end else begin
              present_state <= IDLE;
            end
          end else begin
            clk_cnt <= clk_cnt + 1'b1;
          end
        end

        DATA: begin
          if (clk_cnt == (CLK_DIV - 1)) begin
            clk_cnt <= 4'd0;

            rx_shift[bit_cnt] <= rx;

            if (bit_cnt == 3'd7) begin
              bit_cnt <= 3'd0;
              present_state <= (parity_en ? PARITY : STOP);
            end else begin
              bit_cnt <= bit_cnt + 1'b1;
            end
          end else begin
            clk_cnt <= clk_cnt + 1'b1;
          end
        end

        PARITY: begin
          if (clk_cnt == (CLK_DIV - 1)) begin
            clk_cnt       <= 4'd0;
            rx_parity_bit <= rx;

            if (odd_parity) expected_parity <= ~(^rx_shift);
            else            expected_parity <=  (^rx_shift);

            present_state <= STOP;
          end else begin
            clk_cnt <= clk_cnt + 1'b1;
          end
        end

        STOP: begin
          if (clk_cnt == (CLK_DIV - 1)) begin
            clk_cnt <= 4'd0;

            rx_data <= rx_shift;

            if (rx != 1'b1) frame_error <= 1'b1;

            if (parity_en) begin
              if (rx_parity_bit != expected_parity) parity_error <= 1'b1;
            end

            rx_valid      <= 1'b1;
            present_state <= IDLE;

          end else begin
            clk_cnt <= clk_cnt + 1'b1;
          end
        end

        default: present_state <= IDLE;

      endcase
    end
  end
endmodule

