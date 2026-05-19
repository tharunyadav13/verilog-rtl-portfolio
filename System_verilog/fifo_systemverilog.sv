module fifo_test;

   // Queue acts as FIFO
   int fifo[$];

   // FIFO depth
   int DEPTH = 4;

   // ---------------- WRITE TASK ----------------
   task write(int data);

      if (fifo.size() >= DEPTH) begin
         $display("FIFO FULL -> Cannot write %0d", data);
      end
      else begin
         fifo.push_back(data);
         $display("WRITE : %0d | FIFO = %p", data, fifo);
      end

   endtask

   // ---------------- READ TASK ----------------
   task read();

      int data;

      if (fifo.size() == 0) begin
         $display("FIFO EMPTY");
      end
      else begin
         data = fifo.pop_front();
         $display("READ  : %0d | FIFO = %p", data, fifo);
      end

   endtask


   // ---------------- TESTCASE ----------------
   initial begin

      // Write data
      write(10);
      write(20);
      write(30);
      write(40);

      // FIFO full case
      write(50);

      $display("--------------------------------");

      // Read all data
      read();
      read();
      read();
      read();

      // FIFO empty case
      read();

   end

endmodule
