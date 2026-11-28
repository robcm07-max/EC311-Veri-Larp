`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 03:18:45 PM
// Design Name: 
// Module Name: tb_hp_update
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


module tb_hp_update(

    );
    reg [8:0] damage;
    reg [7:0] hp;
    wire [7:0] new_hp;
    
    hp_update DUT(.damage(damage), .hp(hp), .new_hp(new_hp));
    
    initial 
    begin
    //should be 0, 70, 0
    hp = 120; damage = 150; 
    #10 damage = 50; 
    #10 damage = 120; 
    
    #10 $finish;
    end 
endmodule
