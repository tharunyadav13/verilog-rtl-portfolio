class transaction;
  rand bit [3:0] A, B;
       bit [4:0] out;

  constraint range { A inside {[0:15]}; B inside {[0:15]}; }
endclass
