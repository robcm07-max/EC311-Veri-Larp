`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 03:11:44 PM
// Design Name: 
// Module Name: hp_update
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


module hp_update(
    input [8:0] damage,
    input [7:0] hp,
    output reg [7:0] new_hp
    );
    
    always @(*) begin
        if (damage >= hp) 
            new_hp = 8'd0;
        else 
            new_hp = hp - damage;
     end 
    
endmodule
