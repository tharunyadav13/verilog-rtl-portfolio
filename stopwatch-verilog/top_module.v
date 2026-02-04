
module top_module(
  input clk,
  input rst,
  input start,
  input STOP,
  output wire rd_en,
  output wire [4:0]hour_count,
  output wire [5:0]sec_count,
  output wire [5:0]min_count);
  
 // internal wires
  wire tick_1s;
  wire sec_roll;
  wire min_roll;
  
  // calling instantiation
  
  clock_divider DUT (.clk(clk), .rst(rst), .tick_1s(tick_1s));
  
  seconds_counter DUT1 (.clk(clk), .rst(rst), .tick_1s(tick_1s), .rd_en(rd_en), .sec_count(sec_count), .sec_roll(sec_roll));
  
  min_counter DUT2(.clk(clk),   .rst(rst), .sec_roll(sec_roll), .rd_en(rd_en), .min_count(min_count), .min_roll(min_roll));
  
  hour_counter DUT3(.clk(clk), .rst(rst), .min_roll(min_roll), .hour_count(hour_count));
  
  stopwatch_fsm DUT4 (
    .clk(clk),
    .rst(rst),
    .start(start),
    .STOP(STOP),
    .rd_en(rd_en));
  
endmodule
