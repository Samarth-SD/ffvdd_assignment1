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

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;

        
        clk = 0;
        rst = 1;
        cmd_data = 24'h0;
        en = 0;
        ready = 0;
        spi_do = 0;

        
        #10;

        
        rst = 0;
        en = 1;
        cmd_data = 24'h123456;

        repeat (100) @(negedge clk);
        rst = 1;
        en = 0;
        repeat (1) @(negedge clk);
        rst = 0;
        en = 1;
        cmd_data = ~cmd_data;

        repeat (100) @(negedge clk);
        rst = 1;
        en = 0;
        repeat (1) @(negedge clk);
        rst = 0;
        en = 1;
        cmd_data = ~cmd_data;

        repeat (100) @(negedge clk);
        rst = 1;
        en = 0;
        repeat (1) @(negedge clk);
        rst = 0;
        en = 1;
        cmd_data = ~cmd_data;

        repeat (100) @(negedge clk);
        rst = 1;
        en = 0;

        $finish;
    end

    always @(clk) begin
        if (clk) begin
            
            spi_do = $random & 1'b1;
        end
        if (~clk) begin
            
            ready = $random & 1'b1; 
        end
    end

    always #10 clk = ~clk;
endmodule
