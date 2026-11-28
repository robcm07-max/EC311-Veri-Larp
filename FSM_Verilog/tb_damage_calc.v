`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 12:34:32 PM
// Design Name: 
// Module Name: tb_damage_calc
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


module tb_damage_calc(

    );
    
    reg [7:0] power, def, atk;
    reg [1:0] boost_lvl;
    wire [8:0] final;
    
    damage_calc DUT(.power(power), .def(def), .atk(atk), 
                    .boost_lvl(boost_lvl), .final(final));
    
    initial 
    begin
    //Wobbuffet heavy bost 0 throiugh 3 vs gengar
    //final should be 105, 125, 145, 165
    power = 8'd110; atk = 8'd87; boost_lvl = 2'd0; def = 8'd92;
    #10 boost_lvl = 2'd1;
    #10 boost_lvl = 2'd2;
    #10 boost_lvl = 2'd3;
    
    //lickitung light vs gengar
    //show min of 1 damage
    #10 power = 8'd45; atk = 8'd84; def = 8'd136; boost_lvl = 2'd0;
    
    #10 $finish;
    end
    
endmodule
