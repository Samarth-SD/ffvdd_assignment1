
class generator;
  
  rand transaction trans;
  int  repeat_count;
  mailbox gen2driv;
  event ended;
  function new(mailbox gen2driv);
    this.gen2driv = gen2driv;
  endfunction
  
  task main();
    repeat(repeat_count) begin
    trans = new();
    if( !trans.randomize() ) $fatal("Gen:: trans randomization failed");
      //trans.cg.sample();
      trans.display("[ Generator ]");
      gen2driv.put(trans);
    end
    -> ended;
  endtask
  /*task display_cov();
    wait(ended.triggered);
      $display ("* Functional Coverage = %.2f%% *", trans.cg.get_coverage());
      $display ("* Functional Coverage (cmd_data) = %.2f%% *", trans.cg.c_cmd.get_coverage());
      $display ("* Functional Coverage (read_data) = %.2f%% *", trans.cg.c_read.get_coverage());
      $display ("* Functional Coverage (sink_vld) = %.2f%% *", trans.cg.c_sink.get_coverage());
      $display ("* Functional Coverage (spi_clk) = %.2f%% *", trans.cg.c_sclk.get_coverage());
      $display ("* Functional Coverage (spi_enb)  = %.2f%% *", trans.cg.c_senb.get_coverage());
      $display ("* Functional Coverage (spi_di) = %.2f%% *", trans.cg.c_sdi.get_coverage());
  endtask*/
endclass