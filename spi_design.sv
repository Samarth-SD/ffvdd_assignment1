module spi_ctrl #
(
    parameter SPI_ADDR_WIDTH = 16,
    parameter SPI_CMD_WIDTH = 24,
    parameter SPI_IDLE = 0
)
(
    
    input clk,
    input rst,
    
    
    input [23:0] cmd_data,
    output reg [7:0] read_data,
    input en,
    input ready,
    output reg sink_vld,
    
    
    output reg spi_clk,
    output reg spi_enb,
    output reg spi_di,
    input spi_do
);

localparam [1:0] IDLE = 2'b00,
                 WRITE_ADDR = 2'b01,
                 WRITE_DATA = 2'b10,
                 READ = 2'b11;

localparam SPI_DATA_WIDTH = SPI_CMD_WIDTH - SPI_ADDR_WIDTH;

reg [SPI_CMD_WIDTH-1:0] cmd_data_r;
reg [SPI_ADDR_WIDTH-1:0] cnt;
reg [1:0] state;
reg flag_read;
reg flag_write_addr_update, flag_write_addr_hold, flag_data_update, flag_data_hold;

assign flag_write_addr_update = (cnt < SPI_ADDR_WIDTH && spi_clk == 1'b0) ? 1'b1 : 1'b0;
assign flag_write_addr_hold = (cnt < SPI_ADDR_WIDTH) ? 1'b1 : 1'b0;
assign flag_data_update = (cnt < SPI_DATA_WIDTH && spi_clk == 1'b0) ? 1'b1 : 1'b0;
assign flag_data_hold = (cnt < SPI_DATA_WIDTH) ? 1'b1 : 1'b0;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        spi_clk <= SPI_IDLE;
        spi_enb <= 1'b1;
        spi_di <= 1'b0;
        read_data <= 8'd0;
        sink_vld <= 1'b0;
        state <= IDLE;
        cmd_data_r <= 24'd0;
        cnt <= 16'd0;
        flag_read <= 1'b0;
    end else if (en) begin
        case (state)
            IDLE: begin
                if (ready) begin
                    state <= WRITE_ADDR;
                    spi_enb <= 1'b0;
                    cmd_data_r <= cmd_data;
                    cnt <= 16'd0;
                    flag_read <= !cmd_data[23];
                end
                sink_vld <= 1'b0;
                spi_di <= 1'b0;
                spi_enb <= 1'b1;
            end
            WRITE_ADDR: begin
                spi_enb <= 1'b0;
                if (flag_write_addr_update) begin
                    spi_di <= cmd_data_r[23];
                    cmd_data_r <= {cmd_data_r[22:0], 1'b0};
                    spi_clk <= 1'b1;
                    cnt <= cnt + 1;
                end else if (flag_write_addr_hold) begin
                    spi_clk <= 1'b0;
                end else begin
                    if (flag_read) state <= READ;
                    else state <= WRITE_DATA;
                    cnt <= 16'd0;
                    spi_clk <= 1'b0;
                end
            end
            WRITE_DATA: begin
                if (flag_data_update) begin
                    spi_di <= cmd_data_r[23];
                    cmd_data_r <= {cmd_data_r[22:0], 1'b0};
                    spi_clk <= 1'b1;
                    cnt <= cnt + 1;
                end else if (flag_data_hold) begin
                    spi_clk <= 1'b0;
                end else begin
                    state <= IDLE;
                    spi_clk <= 1'b0;
                    sink_vld <= 1'b1;
                end
            end
            READ: begin
                if (flag_data_update) begin
                    spi_clk <= 1'b1;
                end else if (flag_data_hold) begin
                    spi_clk <= 1'b0;
                    read_data[0] <= spi_do;
                    read_data[7:1] <= read_data[6:0];
                    cnt <= 16'd0;
                end else begin
                    state <= IDLE;
                    sink_vld <= 1'b1;
                end
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule
