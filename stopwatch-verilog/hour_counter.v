

module hour_counter(
  input  wire       clk,
  input  wire       rst,       // active-low reset
  input  wire       min_roll,  // pulse every 60 minutes
  output reg  [4:0] hour_count // 0 to 23
);

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      hour_count <= 5'd0;
    end else begin
      if (min_roll) begin
        if (hour_count == 5'd23)
          hour_count <= 5'd0;
        else
          hour_count <= hour_count + 5'd1;
      end
    end
  end

endmodule


