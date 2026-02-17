module tb_top;
  bit clk = 0;
  always #5 clk = ~clk;

  add_if inf(clk);

  Adder DUT(inf);
  base_test t1(inf);

  initial begin
    inf.reset = 0;
    #10;
    inf.reset = 1;
   // we not use $finish becuase it is transaction based termination .
    //Simulation ends when:
//Scoreboard received all expected transactions
  end
endmodule
