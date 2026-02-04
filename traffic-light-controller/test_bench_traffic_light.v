      
module tb;

  reg clk;
  reg rst;                // active-low reset
  wire green, yellow, RED;

  // DUT instance (uses your module params)
  fsm_traffic_light #(
    .GREEN_TIME(10),
    .YELLOW_TIME(3),
    .RED_TIME(5),
    .clk_freq(10)
  ) DUT (
    .clk(clk),
    .rst(rst),
    .green(green),
    .yellow(yellow),
    .RED(RED)
  );

  // Clock: period = 4 time units (because #2)
  initial clk = 1'b0;
  always #2 clk = ~clk;

    // Monitor outputs every time they change
    $monitor("t=%0t  rst=%b  G=%b  Y=%b  R=%b", $time, rst, green, yellow, RED);

    // Reset
    rst = 1'b0;          // assert reset
    #5;
    rst = 1'b1;          // deassert reset

    
  
    #1600;

    $finish;
  end

endmodule
