class scoreboard;
  mailbox driv2scb;
  mailbox mon2scb;
  bit [7:0] rd;
  int no_transactions;
  
  function new(mailbox mon2scb, driv2scb);
    this.mon2scb = mon2scb;
    this.driv2scb = driv2scb;
  endfunction
  
  task main;
    transaction trans;
    forever begin
      driv2scb.get(rd);
      mon2scb.get(trans);
      if(trans.cmd_data[23])
        if(trans.read_data == 8'd0)
          $display("WRITE_DATA is as Expected");
      	else
          $error("WRITE: INCORRECT!\nExpected: %8b",rd);
      else
        if(trans.read_data == rd)
          $display("READ_DATA is as Expected");
      	else
          $error("READ: INCORRECT!\nExpected: %8b",rd);
      no_transactions++;
      trans.display("[ Scoreboard ]");
    end
  endtask
  
endclass