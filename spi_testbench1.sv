`timescale 1ns / 1ps

module tb_spi_ctrl;

    reg clk;
    reg rst;
    reg [23:0] cmd_data;
    wire [7:0] read_data;
    reg en;
    reg ready;
    wire sink_vld;
    wire spi_clk;
    wire spi_enb;
    wire spi_di;
    reg spi_do;

    // Instantiate the Unit Under Test (UUT)
    spi_ctrl uut (
        .clk(clk), 
        .rst(rst), 
        .cmd_data(cmd_data), 
        .read_data(read_data), 
        .en(en), 
        .ready(ready), 
        .sink_vld(sink_vld), 
        .spi_clk(spi_clk), 
        .spi_enb(spi_enb), 
        .spi_di(spi_di), 
        .spi_do(spi_do)
    );

    covergroup testing_ports @(posedge clk);
        c_cmd: coverpoint cmd_data;
        c_read: coverpoint read_data;
        c_en: coverpoint en;
        c_ready: coverpoint ready;
        c_sink: coverpoint sink_vld;
        c_sclk: coverpoint spi_clk;
        c_senb: coverpoint spi_enb;
        c_sdi: coverpoint spi_di;
        c_sdo: coverpoint spi_do;
    endgroup

    testing_ports inst = new();

    initial begin
      	//$dumpfile("dump.vcd"); $dumpvars;

        // Initialize Inputs
        clk = 0;
        rst = 1;
        cmd_data = 24'h0;
        en = 0;
        ready = 0;
        spi_do = 0;

        // Wait for 100 ns for global reset to finish
        #100;

        // De-assert reset
        rst = 0;

      repeat(1000) @(negedge clk);

      $display ("* Functional Coverage = %.2f%% *", inst.get_coverage());
      $display ("* Functional Coverage (cmd_data) = %.2f%% *", inst.c_cmd.get_coverage());
      $display ("* Functional Coverage (read_data) = %.2f%% *", inst.c_read.get_coverage());
      $display ("* Functional Coverage (en) = %.2f%% *", inst.c_en.get_coverage());
      $display ("* Functional Coverage (ready) = %.2f%% *", inst.c_ready.get_coverage());
      $display ("* Functional Coverage (sink_vld) = %.2f%% *", inst.c_sink.get_coverage());
      $display ("* Functional Coverage (spi_clk) = %.2f%% *", inst.c_sclk.get_coverage());
      $display ("* Functional Coverage (spi_enb)  = %.2f%% *", inst.c_senb.get_coverage());
      $display ("* Functional Coverage (spi_di) = %.2f%% *", inst.c_sdi.get_coverage());
      $display ("* Functional Coverage (spi_do) = %.2f%% *", inst.c_sdo.get_coverage());

		$finish;
    end
    always@(clk) begin
            if (clk) begin
                // Randomly toggle spi_do at rising edge of clk
                spi_do = $random & 1'b1; 
              cmd_data = $random & {24{1'b1}};
            end
            if (~clk) begin
                // Randomly set ready at falling edge of clk
                ready = $random & 1'b1; 
                en = $random & 1'b1;
            end
     end
    always #10 clk = ~clk;

endmodule
