class Animal;
  protected string species;  // Protected variable
  function void set_species(string s);
    species = s;
  endfunction
  function string get_species();
     $display("Species: %s", species);
  endfunction
endclass
// Child class
class Dog extends Animal;
  function void show_species();
    $display("Species: %s", species);  //  allowed because it's protected
  endfunction
endclass
// Test module
module test;
 initial begin
    Dog d = new();
   // d.species = "Canine";  Not allowed - species is protected
   d.set_species("Canine"); //  Set using base class method
   d.show_species();       // Display using child class method
 end
endmodule
