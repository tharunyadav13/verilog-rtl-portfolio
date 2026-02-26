class environment;

  agent        agt;
  scoreboard   sb;
  i2c_coverage cov;

  mailbox mon_to_sb;
  int unsigned tx_count;

  function new(virtual i2c_if vif);
    mon_to_sb = new();
    sb        = new();
    cov       = new();
    agt       = new(mon_to_sb, vif);
    tx_count  = 0;
  endfunction

  task run();
    fork
      agt.run();

      forever begin
        transaction st;

        mon_to_sb.get(st);
        tx_count++;

        // Coverage sampling
        cov.sample(st);   // sample the coverage in environment. to detect how muh perecentage of work .

        // Scoreboard update (WRITE only)
        if (st.rw == 1'b0) begin
          sb.do_write(st.reg_addr, st.write_data);
        end

        $display("COV: after %0d transactions, coverage = %0.2f%%",
                 tx_count, cov.get_cov());
      end
    join_none
  endtask

endclass
