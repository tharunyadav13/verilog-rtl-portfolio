class car_model;

  string colour;
  real   model;
  int    amount;

  virtual function void display();
    $display("[BASE] colour=%s model=%0.2f amount=%0d", colour, model, amount);
  endfunction

  function new(string colour, real model, int amount);
    this.colour = colour;   // used this keyword  to assign similar . ref model and data type .
    this.model  = model;
    this.amount = amount;
  endfunction

endclass


class demo_cars extends car_model;

  int release_date;

  function new(string colour, real model, int amount, int release_date);
    super.new(colour, model, amount);  // use super method to call parent data types. 
    this.release_date = release_date;
  endfunction

  virtual function void display();
    $display("[DERIVED] colour=%s model=%0.2f amount=%0d release_date=%0d",
             colour, model, amount, release_date);
  endfunction

endclass


module tb;

  initial begin
    demo_cars d;
    car_model c;

    d = new("red", 6.33, 120000, 2025);
    c = new("black", 4.10, 80000);

    c = d;          // base handle points to derived object  both access same memory
  //  c.display();    // polymorphism: calls derived display()
 //   but i use  parent to know more method . from parent to i will call child beacuse in parent is use virtual
    
    d.display();

    $finish;
  end

endmodule
