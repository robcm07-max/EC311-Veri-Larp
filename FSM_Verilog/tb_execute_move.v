`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 09:25:25 PM
// Design Name: 
// Module Name: tb_execute_move
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


module tb_execute_move(

    );
    
    reg [2:0] p_pkmn_id, e_pkmn_id;
    reg [1:0] p_move_id, e_move_id, p_boost_lvl, e_boost_lvl;
    reg [7:0] p_hp, e_hp;
    reg [6:0] rnd;
    reg player_move;
    wire [7:0] p_hp_next, e_hp_next;
    wire [1:0] p_boost_next, e_boost_next, result;

    execute_move dut(.rnd(rnd), .p_pkmn_id(p_pkmn_id), .p_move_id(p_move_id),
                     .e_pkmn_id(e_pkmn_id), .e_move_id(e_move_id),
                     .p_boost_lvl(p_boost_lvl), .e_boost_lvl(e_boost_lvl),
                     .p_hp(p_hp), .e_hp(e_hp), .player_move(player_move),
                     .p_hp_next(p_hp_next), .e_hp_next(e_hp_next),
                     .p_boost_next(p_boost_next), .e_boost_next(e_boost_next),
                     .result(result));
//    reg clk;
//    wire [6:0] rand_0_127;
//    wire [7:0] lfsr;
//    // Generate a 100 MHz clock (10 ns period)
//    always #5 clk = ~clk;
    
    initial
    begin
        //clk = 0;
        //Gengar (0) medium move (slot 1) on Snorlax (2)
        p_pkmn_id = 3'd0; p_move_id = 2'd1; p_boost_lvl = 2'd0; p_hp = 8'd200;
        e_pkmn_id = 3'd2; e_move_id = 2'd1; e_boost_lvl = 2'd0; e_hp = 8'd244;
        player_move = 1; rnd = 1;
        
        //each line copies the new hp back in, like the FSM's register does
        #10 e_hp = e_hp_next;       //e_hp -> 166
        #10 e_hp = e_hp_next;       //-> 88
        #10 e_hp = e_hp_next;       //-> 10
        #10 e_hp = e_hp_next;       //-> 0
        
        //miss: heavy move (slot 2, threshold 96) with a roll of 100 does nothing
        #10 e_hp = 8'd244; p_move_id = 2'd2; rnd = 7'd100;     //e_hp_next stays 244, result = 1
    
        //boost (slot 3): stage goes 0 -> 1, result = 2, no damage
        #10 p_move_id = 2'd3; rnd = 7'd0;                      //p_boost_next = 1
    
        //boost at the cap: stage stays 3, result = 3
        #10 p_boost_lvl = 2'd3;                                //p_boost_next = 3
    
        //enemy acts: Snorlax medium on Gengar (player_move = 0), 60 + 122 - 92 = 90
        #10 player_move = 0; p_boost_lvl = 2'd0; e_move_id = 2'd1;   //p_hp_next = 110
    
        #10 $finish;
        end
    
endmodule
