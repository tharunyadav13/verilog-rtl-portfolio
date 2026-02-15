
class Animal;
  
  local string name;
  
  function void set_speices(string n);
    name=n;
  endfunction 
  
  
  function void display();
       $display("Species: %s", species);
  endfunction
endclass


module tb;
  
  initial begin 
    Animal A;
    
    A=new();
    A.set_speices("DOG");
    A.display();
    end
endmodule 
    
