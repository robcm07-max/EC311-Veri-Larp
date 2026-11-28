`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 04:01:44 PM
// Design Name: 
// Module Name: tb_lfsr_8bit
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


module tb_lfsr_8bit(

    );
    
    reg clk;
    wire [6:0] rand_0_127;
    wire [7:0] lfsr;

    // Instantiate the Device Under Test (DUT)
    lfsr_8bit DUT (.clk(clk), .rand_0_127(rand_0_127), .lfsr(lfsr));

    // Generate a 100 MHz clock (10 ns period)
    always #5 clk = ~clk;

    initial
    begin
        clk = 0;
        #200 $finish;
    end
endmodule
