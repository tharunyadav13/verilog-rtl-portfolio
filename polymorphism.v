// Code your testbench here
// or browse Examples


  class original_model;
    
      string car_model;
      int cost;
     real model;
    
      
    function new( string car_model, int cost, real model);
      this.car_model=car_model;
       this.cost=cost;
      this.model=model;
    endfunction 
    
    virtual function  int final_price();   // create  base class method this method i will override in child class .
      return cost;
    endfunction 
    
    
    virtual function void display();
      $display(" presenting the  car_model=%s, cost=%0d, model=%0.2f, final_price=%0d", car_model,cost,model, final_price());
    endfunction 
  endclass
    
    class  electric_model extends original_model;
      
      function new(string car_model, int cost, real model);
        super.new(car_model, cost, model);
      endfunction 
      
     // override tax calculation 
      virtual function int final_price();     // override in child class 
        return cost*3;
      endfunction 
    endclass

class automotive_model extends original_model;
  
  function new(string car_model, int cost, real model);
    super.new(car_model, cost, model);
  endfunction 
  
  virtual function  int final_price();
     return cost*4;
  endfunction 
endclass
  
  module tb;
    
    initial begin 
      
      original_model md;
      automotive_model ot=new("jaguar", 220000, 2.2);  // declare inside the object creation inside new becuase i used constructor inside base class inside i declare arguments in construction.
      electric_model EC=new("BMW", 320000,3.2);
      
      // Polymorphism happens here
     
      md=ot;
      md.display();   // this is for first model child class
      
      
      md=EC;
      md.display();   
     
      $finish;
    end
  endmodule 
      
        
        
      
      
