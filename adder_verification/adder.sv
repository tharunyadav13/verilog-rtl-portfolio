module Adder(add_if inf);
  always_ff @(posedge inf.clk or negedge inf.reset) begin
    if (!inf.reset) inf.out <= '0;
    else            inf.out <= inf.A + inf.B;
  end
endmodule
