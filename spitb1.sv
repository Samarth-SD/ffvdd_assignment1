module tb_spi_ctrl;
    reg clk;
    reg rst;
    reg [23:0] cmd_data;
    reg en;
    reg ready;
    wire [7:0] read_data;
    wire sink_vld;
    reg spi_do;
    wire spi_clk;
    wire spi_enb;
    wire spi_di;

    // Instantiate the spi_ctrl module
    spi_ctrl #(
        .SPI_ADDR_WIDTH(16),
        .SPI_CMD_WIDTH(24),
        .SPI_IDLE(0)
    ) uut (
        .clk(clk),
        .rst(rst),
        .cmd_data(cmd_data),
        .en(en),
        .ready(ready),
        .read_data(read_data),
        .sink_vld(sink_vld),
        .spi_clk(spi_clk),
        .spi_enb(spi_enb),
        .spi_di(spi_di),
        .spi_do(spi_do)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    // Initial values
    initial begin
        clk = 0;
        rst = 0;
        cmd_data = 24'b0;
        en = 0;
        ready = 0;
        spi_do = 0;

        // Test Case 1: IDLE to WRITE_ADDR
        // This test case goes from IDLE to WRITE_ADDR state
        $display("Test Case 1: IDLE to WRITE_ADDR");
        rst = 1;
        #10 rst = 0;
        cmd_data = 24'b101010101010101010101010;
        en = 1;
        ready = 1;
        #100;
        en = 0;

        // Test Case 2: IDLE to WRITE_DATA
        // This test case goes from IDLE to WRITE_DATA state
        $display("Test Case 2: IDLE to WRITE_DATA");
        cmd_data = 24'b110110110110110110110110;
        en = 1;
        ready = 1;
        #100;
        en = 0;

        // Test Case 3: IDLE to READ
        // This test case goes from IDLE to READ state
        $display("Test Case 3: IDLE to READ");
        cmd_data = 24'b111111111111111111111111;
        en = 1;
        ready = 1;
        #100;
        en = 0;

        // Test Case 4: WRITE_ADDR to WRITE_DATA
        // This test case goes from WRITE_ADDR to WRITE_DATA state
        $display("Test Case 4: WRITE_ADDR to WRITE_DATA");
        cmd_data = 24'b101010101010101010101010;
        en = 1;
        ready = 1;
        #50;
        ready = 0;
        #50;
        ready = 1;
        #50;
        en = 0;

        // Test Case 5: WRITE_DATA to IDLE
        // This test case goes from WRITE_DATA to IDLE state
        $display("Test Case 5: WRITE_DATA to IDLE");
        cmd_data = 24'b110110110110110110110110;
        en = 1;
        ready = 1;
        #100;
        en = 0;

        // Test Case 6: READ to IDLE
        // This test case goes from READ to IDLE state
        $display("Test Case 6: READ to IDLE");
        cmd_data = 24'b111111111111111111111111;
        en = 1;
        ready = 1;
        #50;
        ready = 0;
        #50;
        ready = 1;
        #50;
        en = 0;

        $finish;
    end
endmodule
