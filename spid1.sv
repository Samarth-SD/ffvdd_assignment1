module spi_ctrl
#(
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
    input reg spi_do
);

localparam SPI_DATA_WIDTH = SPI_CMD_WIDTH - SPI_ADDR_WIDTH;
reg [1:0] state; 
reg [23:0] cmd_data_r;  
reg [15:0] cnt;  
reg flag_read;  
reg flag_write_addr_update; 
reg flag_write_addr_hold; 
reg flag_data_update;  
reg flag_data_hold;  

always @ (posedge clk or posedge rst or posedge en or posedge ready)
begin
    if (rst)
    begin
        spi_clk <= SPI_IDLE;
        spi_enb <= 1'b1;
        spi_di <= 1'b0;
        read_data <= 8'd0;
        sink_vld <= 1'b0;
        state <= 2'b00; 
        cmd_data_r <= 24'd0;
        cnt <= 16'd0;
        flag_read <= 1'b0;
        flag_write_addr_update <= 1'b0;
        flag_write_addr_hold <= 1'b0;
        flag_data_update <= 1'b0;
        flag_data_hold <= 1'b0;
    end
    else if (en)
    begin
        case (state)
            2'b00: 
            begin
                if (ready)
                begin
                    state <= 2'b01;  
                    spi_enb <= 1'b0;
                    cmd_data_r <= cmd_data;
                    cnt <= 16'd0;
                    flag_read <= !cmd_data[23];
                end
                else
                begin
                    sink_vld <= 1'b0;
                    spi_di <= 1'b0;
                    spi_enb <= 1'b1;
                end
            end

            2'b01: 
            begin
                spi_enb <= 1'b0;
                if (flag_write_addr_update)
                begin
                    spi_di <= cmd_data_r[23];
                    cmd_data_r <= {cmd_data_r[22:0], 1'b0};
                    spi_clk <= 1'b1;
                    cnt <= cnt + 1;
                end
                else if (flag_write_addr_hold)
                begin
                    spi_clk <= 1'b0;
                end
                else
                begin
                    if (flag_read)
                        state <= 2'b11;  
                    else
                        state <= 2'b10; 
                    cnt <= 16'd0;
                    spi_clk <= 1'b0;
                end
            end

            2'b10: 
            begin
                if (flag_data_update)
                begin
                    spi_di <= cmd_data_r[23];
                    cmd_data_r <= {cmd_data_r[22:0], 1'b0};
                    spi_clk <= 1'b1;
                    cnt <= cnt + 1;
                end
                else if (flag_data_hold)
                begin
                    spi_clk <= 1'b0;
                end
                else
                begin
                    state <= 2'b00; 
                    spi_clk <= 1'b0;
                    sink_vld <= 1'b1;
                end
            end

            2'b11: 
            begin
                if (flag_data_update)
                begin
                    spi_clk <= 1'b1;
                end
                else if (flag_data_hold)
                begin
                    spi_clk <= 1'b0;
                    read_data[0] <= spi_do;
                    read_data[7:1] <= read_data[6:0];
                    cnt <= cnt + 1;
                end
                else
                begin
                    state <= 2'b00;  
                    sink_vld <= 1'b1;
                end
            end

            default: state <= 2'b00; 
        endcase
    end
end

endmodule
