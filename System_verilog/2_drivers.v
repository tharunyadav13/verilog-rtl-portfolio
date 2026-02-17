interface bus_if (input logic clk);
  logic a,b,y;
endinterface

module DUT (bus_if inf);
  assign inf.y = inf.a & inf.b;
endmodule

class driver2;
  virtual bus_if vif;
  semaphore sem;

  function new(virtual bus_if vif, semaphore sem);
    this.vif = vif;
    this.sem = sem;
  endfunction

  // "Driver 1" task
  task automatic drv1();
    repeat(2) begin
      @(posedge vif.clk);
      sem.get(1);
        vif.a = $urandom_range(0,1);
        vif.b = $urandom_range(0,1);
        #0;  //   we are using continous assignmnet and here we don't add delay then display will print instantly then we get the  y  values previous values . 
        $display("%0t DRV1: a=%0b b=%0b y=%0b", $time, vif.a, vif.b, vif.y);
        #2;
      sem.put(1);
    end
  endtask

  // "Driver 2" task
  task automatic drv2();
    repeat(2) begin
      @(posedge vif.clk);
      sem.get(1);
        vif.a = $urandom_range(0,1);
        vif.b = $urandom_range(0,1);
        #0;  // instead of time delay adding before we can also use the $strobe.  then also we get correct y value . not previous one . 
        $display("%0t DRV2: a=%0b b=%0b y=%0b", $time, vif.a, vif.b, vif.y);
        #2;
      sem.put(1);
    end
  endtask
endclass

module tb;
  logic clk=0;
  always #3 clk=~clk;

  bus_if inf(clk);
  DUT u_dut(inf);

  semaphore lock;
  driver2 d;

 

  initial begin
    inf.a=0; inf.b=0;
    lock = new(1);     // create thread for seaphore 
    d = new(inf, lock);

    fork
      d.drv1();
      d.drv2();
    join

    #10 $finish;
  end
endmodule
