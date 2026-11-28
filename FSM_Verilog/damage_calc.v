`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 12:09:26 PM
// Design Name: 
// Module Name: damage_calc
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


module damage_calc(
    input [7:0] power, def, atk,
    input [1:0] boost_lvl,
    output reg [8:0] final
    );
    
    reg [5:0] extra_dam;
    always @(*) begin
        case (boost_lvl)
            2'd0: extra_dam = 6'd0;
            2'd1: extra_dam = 6'd20;
            2'd2: extra_dam = 6'd40;
            2'd3: extra_dam = 6'd60;
        endcase
    end 
    
    wire [8:0] before_def = power + extra_dam + atk;
    always @(*) begin
        if(before_def > def) 
            final = before_def - def;
        else 
            final = 9'd1;
    end 
    
endmodule
