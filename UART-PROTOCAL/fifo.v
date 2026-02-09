module fifo16x8 (
  input  wire       clk,
  input  wire       rst,        // active-low

  input  wire       wr_en,
  input  wire [7:0] din,

  input  wire       rd_en,
  output reg  [7:0] dout,

  output wire       full,
  output wire       empty
);
  reg [7:0] mem [0:15];
  reg [3:0] wr_ptr, rd_ptr;
  reg [4:0] count;

  assign empty = (count == 0);
  assign full  = (count == 16);

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      wr_ptr <= 4'd0;
      rd_ptr <= 4'd0;
      count  <= 5'd0;
      dout   <= 8'd0;
    end else begin
      if (wr_en && !full) begin
        mem[wr_ptr] <= din;
        wr_ptr <= wr_ptr + 1'b1;
      end

      if (rd_en && !empty) begin
        dout <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1'b1;
      end

      case ({(wr_en && !full), (rd_en && !empty)})
        2'b10: count <= count + 1'b1;
        2'b01: count <= count - 1'b1;
        default: count <= count;
      endcase
    end
  end
endmodule

