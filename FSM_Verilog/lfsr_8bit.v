`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 03:48:56 PM
// Design Name: 
// Module Name: lfsr_8bit
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


module lfsr_8bit(
    input clk,
    output [6:0] rand_0_127,
    output reg [7:0] lfsr
    );
    
    // Feedback = XOR of taps 8, 6, 5, 4 (bit indices 7, 5, 4, 3)
    wire feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

    initial lfsr = 8'hFF;
    always @(posedge clk) 
        lfsr <= {lfsr[6:0], feedback}; // shift left, insert feedback
    
    assign rand_0_127 = lfsr[6:0];

endmodule
