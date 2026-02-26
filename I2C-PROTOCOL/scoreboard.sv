class scoreboard;

  byte unsigned mem[0:255];
  byte unsigned reg_ptr;

  function new();
    foreach (mem[i]) mem[i] = 8'h00;
    mem[8'h00] = 8'hAB;
    mem[8'h01] = 8'h10;
  endfunction

  task do_write(byte unsigned start_reg, byte unsigned data_q[$]);
    reg_ptr = start_reg;

    for (int i = 0; i < data_q.size(); i++) begin
      mem[reg_ptr] = data_q[i];
      reg_ptr++;
    end
  endtask

endclass
