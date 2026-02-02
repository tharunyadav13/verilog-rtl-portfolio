module fsm_1011(
  input din,
  input clk,rst,
  output reg dout);
  
  typedef enum logic[1:0] {S0, S1, S2,S3}state_t;
 state_t present_state, next_state;
 
  always@(posedge clk or negedge rst)begin
    if(!rst)
      present_state<=S0;
      else
        present_state<=next_state;
  end 
  
     always_comb begin
    next_state = present_state;  // default
      dout =1'b0;
     
       
      case(present_state)
        S0:
          if(din)
          next_state =S1;
    
        S1 :  if(!din) 
          next_state =S2;
        
        S2 : if(din)
          next_state =S3;
          else
            next_state =S0;
     
        S3: if(din) begin
          next_state =S1;
          dout =1'b1;
        end  else 
          next_state<=S2;
       
        
        default :begin
          next_state =S0;
          dout = 1'b0;
        end 
      endcase
     end 
        endmodule 
    
     
        
        
       
        
