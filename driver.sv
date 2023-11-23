class driver;
  
  int no_transactions;
  bit [7:0] rd;
  virtual intf vif;
  mailbox gen2driv;
  mailbox driv2scb;
  function new(virtual intf vif,mailbox gen2driv, driv2scb);
    this.vif = vif;
    this.gen2driv = gen2driv;
    this.driv2scb = driv2scb;
  endfunction
  
  task reset;
    wait(vif.reset);
    $display("[ DRIVER ] ----- Reset Started -----");
    vif.cmd_data <= 0;
    vif.ready <= 0;
    vif.en <= 0;
    vif.spi_do <= 0;
    wait(!vif.reset);
    $display("[ DRIVER ] ----- Reset Ended   -----");
  endtask
  
  task main;
    forever begin
      transaction trans;
      gen2driv.get(trans);
      @(posedge vif.clk);
      vif.en <= 1;
      vif.cmd_data <= trans.cmd_data;
      vif.spi_do <= 1'b0;
      @(posedge vif.clk);
      vif.ready <= 1;
      repeat(16*2) begin
        @(posedge vif.clk);
	    trans.read_data <= vif.read_data;
	    trans.sink_vld <= vif.sink_vld;
        trans.spi_clk <= vif.spi_clk;
        trans.spi_enb <= vif.spi_enb;
        trans.spi_di <= vif.spi_di;
        //trans.display("[ Driver ]");
      end
      repeat(8*2) begin
        @(posedge vif.clk);
        vif.spi_do <= $random & 1'b1;
        rd = {rd[6:0],vif.spi_do};
        @(posedge vif.clk);
	  	trans.read_data <= vif.read_data;
	  	trans.sink_vld <= vif.sink_vld;
      	trans.spi_clk <= vif.spi_clk;
      	trans.spi_enb <= vif.spi_enb;
      	trans.spi_di <= vif.spi_di;
      	//trans.display("[ Driver ]");
      end
      @(posedge vif.clk);
      driv2scb.put(rd);
      vif.ready <= 0;
      vif.en <= 0;
      trans.display("[ Driver ]");
      no_transactions++;
    end
  endtask
  
endclass