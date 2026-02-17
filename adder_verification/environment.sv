class env;
  agent      agt;
  scoreboard sb;
  mailbox    mon_to_sb;

  function new(virtual add_if vif);
    mon_to_sb = new();
    agt = new(vif, mon_to_sb);
    sb  = new(mon_to_sb);
  endfunction

  task run();
    fork
      agt.run();
      sb.run();
    join_none

    wait (sb.compare_cnt == agt.gen.count);
    $display("TEST DONE: compared %0d transactions", sb.compare_cnt);
    $finish;
  endtask
endclass
