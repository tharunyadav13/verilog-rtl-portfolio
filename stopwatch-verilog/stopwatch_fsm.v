module stopwatch_fsm(
  input clk,
  input rst,
  input start,
  input STOP,
  output reg rd_en);
  
  typedef enum logic[1:0] { IDLE, RUN, pause}state_t;
  state_t current_state, next_state;
  
  always@(posedge clk or negedge rst)begin
    if(!rst)begin
      current_state<=IDLE;
    end else 
        current_state<=next_state; 
    end
    
    
    always @(*) begin
    next_state  = current_state;
    rd_en = 1'b0;              // here i writen default so need of writing else inside the case .
 
    
    case(current_state)
      IDLE:  begin 
         rd_en =1'b0;
        if(start)
         next_state =RUN;
      end 
      
      RUN: begin
        rd_en =1'b1;
        if(STOP)
          next_state =pause;
      end 
      
      pause: begin
        rd_en=1'b0;
        if(start)
        next_state =RUN;
      end 
      
      default : begin
        rd_en=0;
        next_state= IDLE;
      end 
      
    endcase
  end
endmodule 
