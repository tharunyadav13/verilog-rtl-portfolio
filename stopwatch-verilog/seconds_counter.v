

module seconds_counter(
  input  wire       clk,
  input  wire       rst,      // active-low
  input  wire       tick_1s,
  input  wire       rd_en,
  output reg  [5:0] sec_count,
  output reg        sec_roll
);

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      sec_count <= 6'd0;
      sec_roll  <= 1'b0;
    end else begin
      sec_roll <= 1'b0;  // default

      if (tick_1s && rd_en) begin
        if (sec_count == 6'd59) begin
          sec_count <= 6'd0;
          sec_roll  <= 1'b1;
        end else begin
          sec_count <= sec_count + 6'd1;
        end
      end
    end
  end
endmodule

