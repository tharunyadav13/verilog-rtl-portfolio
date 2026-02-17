program base_test(add_if inf);
  env ev;
  initial begin
    ev = new(inf);
    ev.agt.gen.count = 5;
    ev.run();
  end
endprogram
