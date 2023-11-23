class monitor;
  
  virtual intf vif;
  mailbox mon2scb;
  
  function new(virtual intf vif,mailbox mon2scb);
    this.vif = vif;
    this.mon2scb = mon2scb;
  endfunction
  
  task main;
    forever begin
      transaction trans;
      trans = new();
      @(posedge vif.en);
      trans.cmd_data   = vif.cmd_data;
      @(posedge vif.sink_vld);
      trans.read_data <= vif.read_data;
	  trans.sink_vld <= vif.sink_vld;
      trans.spi_clk <= vif.spi_clk;
      trans.spi_enb <= vif.spi_enb;
      trans.spi_di <= vif.spi_di;
      @(posedge vif.clk);
      mon2scb.put(trans);
      trans.display("[ Monitor ]");
    end
  endtask
  
endclass