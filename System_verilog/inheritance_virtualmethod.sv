class vehicle;

virtual function void display();
   $display("bike");
   endfunction 
  end class 


    class  Car extends vehicle 
      virtual function void display();
        $display("ferrari");
      endfunction 

    endclass

    module Test;

      vehicle v;
      car c;
      initial begin 
        c=new();
        v=c;
        v.display();
      end
    endmodule 
        
        
