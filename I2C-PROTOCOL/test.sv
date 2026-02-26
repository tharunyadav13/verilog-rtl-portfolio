class test;

  virtual i2c_if vif;
  environment env;

  function new(virtual i2c_if vif);
    this.vif = vif;
    env = new(vif);
  endfunction

  task run();
    env.run();
  endtask

endclass
