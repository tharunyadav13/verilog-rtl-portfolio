class scoreboard;
  int compare_cnt = 0;
  mailbox mon_to_sb;

  function new(mailbox mon_to_sb);
    this.mon_to_sb = mon_to_sb;
  endfunction

  task run();
    transaction mon_tr;
    forever begin
      mon_to_sb.get(mon_tr);

      if (mon_tr.out == (mon_tr.A + mon_tr.B))
        $display("SB  @%0t : MATCH A=%0d B=%0d OUT=%0d",
                 $time, mon_tr.A, mon_tr.B, mon_tr.out);
      else
        $display("SB  @%0t : FAIL  A=%0d B=%0d OUT=%0d EXP=%0d",
                 $time, mon_tr.A, mon_tr.B, mon_tr.out, (mon_tr.A + mon_tr.B));

      compare_cnt++;
    end
  endtask
endclass
