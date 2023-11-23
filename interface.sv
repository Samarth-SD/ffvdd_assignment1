interface intf(input logic clk, reset);

  logic en, ready, spi_do;
  logic [23:0] cmd_data;
  logic [7:0] read_data;
  logic sink_vld, spi_clk, spi_enb, spi_di;
  
endinterface