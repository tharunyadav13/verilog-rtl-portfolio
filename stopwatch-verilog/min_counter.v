

module min_counter(
  input  wire       clk,
  input  wire       rst,      // active-low
  input  wire       sec_roll, // 1-cycle pulse from seconds
  input  wire       rd_en,    // run enable (same as seconds)
  output reg  [5:0] min_count,
  output reg        min_roll  // 1-cycle pulse when minutes rolls 59->0
);

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      min_count <= 6'd0;
      min_roll  <= 1'b0;
    end else begin
      min_roll <= 1'b0; // default

      if (sec_roll && rd_en) begin
        if (min_count == 6'd59) begin
          min_count <= 6'd0;
          min_roll  <= 1'b1;
        end else begin
          min_count <= min_count + 6'd1;
        end
      end
    end
  end

endmodule

