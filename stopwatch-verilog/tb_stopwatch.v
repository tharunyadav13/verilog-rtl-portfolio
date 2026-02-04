

// in output based on time delay we can print hour's or minutes and in seconds .
// based on clk_freq in clok_divider  and delay time (in tb).

module tb;
  reg clk;
  reg rst;
  reg start;
  reg STOP;
  wire rd_en;
  wire [4:0] hour_count;
  wire [5:0] sec_count;
  wire [5:0] min_count;
  
  top_module DUT(.clk(clk), .rst(rst),  .start(start), .STOP(STOP), .rd_en(rd_en),  .min_count(min_count), .hour_count(hour_count), .sec_count(sec_count));

    always #2 clk=~clk;
  
  initial begin 
  
    $monitor("time=%t, clk=%b, rst=%b, start=%b, STOP=%b, rd_en=%b, hour_count=%d, min_count=%d, sec_count=%d", $time , clk, rst,  start, STOP, rd_en, hour_count, min_count, sec_count);
    
   clk=1'b0;
    rst=1'b0;
    start=1'b0;
    STOP=1'b0;
    
    #10 rst=1'b1;
    
   // start pulse
#10 start = 1;
#12 start = 0;   // >= 6 is safe

#120;

// stop pulse
#10 STOP = 1;
#12 STOP = 0;

#20;

// start again
start = 1;
#12 start = 0;  // we use this to keep in the same state in fsm  for long time to run the counters . 
    
    #1500
    
    #200 $finish;
  end 
endmodule 
