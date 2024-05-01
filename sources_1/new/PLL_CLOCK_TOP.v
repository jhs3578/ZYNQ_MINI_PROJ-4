`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/01 15:47:51
// Design Name: 
// Module Name: PLL_CLOCK_TOP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module PLL_CLOCK_TOP(
    output reg [3:0] led, //LED4 --- LED1, 1 on, 0 off
    input clk, // FPGA PL clock, input 50 Mhz
    input rst_n //FPGA reset pin
    );

reg [31:0] cnt;
reg [1:0] led_on_number;

wire clk_out1;
parameter CLOCK_FREQ = 100_000_000;
parameter COUNTER_MAX_CNT = CLOCK_FREQ/2-1; //change time 0.5s
    
//clock pll inst
CLK_WIZ_0 CLK_WIZ_0_inst
(
    // Clock out ports
    .clk_out1(clk_out1),     // output 100mhz
    // Status and control signals
    .resetn(rst_n), // input resetn
    .locked(),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);   
    
always @(posedge clk_out1, negedge rst_n) begin
    if(!rst_n) begin
        cnt <= 32'd0;
        led_on_number <= 2'd0;
    end
    else begin
        cnt <= cnt + 1'b1;
        if(cnt == COUNTER_MAX_CNT) begin//0.5s
            cnt <= 32'd0;
            led_on_number <= led_on_number + 1'b1;
        end
    end
end

always @(*) begin
    case(led_on_number)
        0: led = 4'b0001;
        1: led = 4'b0010;
        2: led = 4'b0100;
        3: led = 4'b1000;
        default: led = 4'b0000;
    endcase
end
endmodule