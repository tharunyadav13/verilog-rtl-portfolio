

// ---------------- Interface ----------------
interface bus_if (input logic clk);
  logic a;
  logic b;
  logic y;
endinterface


// ---------------- DUT (AND Gate) ----------------
module DUT (bus_if inf);
  assign inf.y = inf.a & inf.b;
endmodule


// ---------------- Driver Class ----------------

class driver;

  virtual bus_if vif;

  function new(virtual bus_if vif);
    this.vif = vif;
  endfunction

  task run();
    repeat (10) begin
      @(posedge vif.clk);
      vif.a = $urandom_range(0,1);
      vif.b = $urandom_range(0,1);

      $display("@%0t a=%0b b=%0b y=%0b",
                $time, vif.a, vif.b, vif.y);

      #5;
    end
  endtask

endclass



module tb;

  logic clk = 0;
  always #3 clk = ~clk;

  bus_if inf(clk);
  DUT u_dut(inf);

  driver d1;
  initial begin
    $dumpfile("and_tb.vcd");   // output file name
    $dumpvars(0, tb);      
 
    inf.a = 0;
    inf.b = 0;

    d1 = new(inf);  // here connecting driver to interface .

    fork
      d1.run();
    join

    #10 $finish;
  end

endmodule
