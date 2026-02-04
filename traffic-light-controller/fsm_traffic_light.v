

module fsm_traffic_light #( parameter integer GREEN_TIME=10,
  parameter integer clk_freq=10,
                           parameter integer YELLOW_TIME=3,
                           parameter integer RED_TIME=5)
  (
  input clk,
  input rst,
  output reg green,
  output reg yellow,
  output reg RED);
  
   wire tick_1s;
 clock_divider #(.clk_freq(clk_freq)) u_div (
  .clk(clk),
  .rst(rst),
  .tick_1s(tick_1s)
);


  // FSM states
  typedef enum logic [1:0] {S_GREEN, S_YELLOW, S_RED} state_t;
  state_t current_state, next_state;
  
  reg [3:0] sec_count;
  
  
  always@(*)begin
     next_state = current_state;
    case (current_state)
      S_GREEN:  if (sec_count == GREEN_TIME-1)  
        next_state = S_YELLOW;
       else 
        next_state=S_GREEN;
      
      
      S_YELLOW: if (sec_count == YELLOW_TIME-1) 
        next_state = S_RED;
      else 
        next_state=S_YELLOW;
      
      S_RED:    if (sec_count == RED_TIME-1)    
        next_state = S_GREEN;
       else 
        next_state=S_RED;
         
      default:  next_state = S_GREEN;
    endcase
  end 
    
     always @(posedge clk or negedge rst) begin
    if (!rst) begin
      current_state     <= S_GREEN;
      sec_count <= 4'd0;
    end else if (tick_1s) begin
      if (next_state != current_state) begin
        current_state     <= next_state;
        sec_count <= 4'd0;          // reset seconds when state changes
      end else begin
        sec_count <= sec_count + 4'd1;
      end
    end
  end
  
  //setting default first becuase if S_Green in below case(current_state) then Green become high what about yellow and red so  making default first .

  always@(*) begin
  green  = 1'b0;
  yellow = 1'b0;
  RED    = 1'b0;

  
    case(current_state)
      S_GREEN : green=1'b1;
      S_YELLOW :yellow=1'b1;
      S_RED:RED=1'b1;
      default: ;
        endcase
  end 
      endmodule 
