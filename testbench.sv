`include "interface.sv"
`include "test.sv"

module tbench_top;
  
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
  initial begin
    reset = 1;
    #5 reset =0;
  end
  
  intf i_intf(clk,reset);
  test t1(i_intf);
  
  spi_ctrl DUT (
    .clk(i_intf.clk),
    .reset(i_intf.reset),
    .cmd_data(i_intf.cmd_data),
    .read_data(i_intf.read_data),
    .en(i_intf.en),
    .ready(i_intf.ready),
    .sink_vld(i_intf.sink_vld),
    .spi_clk(i_intf.spi_clk),
    .spi_di(i_intf.spi_di),
    .spi_enb(i_intf.spi_enb),
    .spi_do(i_intf.spi_do)
   );
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule