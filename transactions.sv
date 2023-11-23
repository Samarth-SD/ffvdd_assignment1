class transaction;
  randc bit [23:0] cmd_data;
  bit [7:0] read_data;
  bit sink_vld, spi_clk, spi_enb, spi_di;
  
  /*covergroup cg;
    c_cmd: coverpoint cmd_data;
    c_read: coverpoint read_data;
    c_sink: coverpoint sink_vld;
    c_sclk: coverpoint spi_clk;
    c_senb: coverpoint spi_enb;
    c_sdi: coverpoint spi_di;
  endgroup
  
  function new();
    cg = new();
  endfunction*/

  function void display(string name);
    $display("-------------------------");
    $display("- %s ",name);
    $display("-------------------------");
    $display("- cmd_data = %24b -", cmd_data);
    $display("- read_data = %8b, sink_vld = %1b, spi_clk = %1b, spi_enb = %1b, spi_di = %1b -", read_data, sink_vld, spi_clk, spi_enb, spi_di);
    $display("-------------------------");
  endfunction
endclass
