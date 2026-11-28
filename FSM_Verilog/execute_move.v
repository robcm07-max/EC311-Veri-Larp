`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 06:54:22 PM
// Design Name: 
// Module Name: execute_move
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


module execute_move(
    input [6:0] rnd,
    input [2:0] p_pkmn_id,
    input [1:0] p_move_id,
    input [2:0] e_pkmn_id,
    input [1:0] e_move_id,
    input [1:0] p_boost_lvl,
    input [1:0] e_boost_lvl,
    input [7:0] p_hp,              //CURRENT hp, read from the FSM's registers
    input [7:0] e_hp,
    input player_move,       //player's turn flag
    output [7:0] p_hp_next,         //what each hp should become
    output [7:0] e_hp_next,
    output [1:0] p_boost_next,
    output [1:0] e_boost_next,
    output [1:0] result             //0 hit, 1 miss, 2 attack up, 3 attack maxed
    );
    
    wire [7:0] p_hp_max, e_hp_max;
    wire [7:0] p_atk, p_def, p_spd, e_atk, e_def, e_spd;
        
    //player pokemon info
    stats_rom p_active(.id(p_pkmn_id), .hp(p_hp_max), .atk(p_atk), .def(p_def), .spd(p_spd));
    //enemy pokemon info
    stats_rom e_active(.id(e_pkmn_id), .hp(e_hp_max), .atk(e_atk), .def(e_def), .spd(e_spd));
    
    //muxes to based on who is currently attacking
    //set when comparing speed
    wire [2:0] a_pkmn_id = player_move ? p_pkmn_id : e_pkmn_id;
    wire [1:0] a_move = player_move ? p_move_id : e_move_id;
    wire [7:0] a_atk = player_move ? p_atk : e_atk;
    wire [1:0] a_boost = player_move ? p_boost_lvl : e_boost_lvl;
    wire [7:0] d_def = player_move ? e_def : p_def;
    wire [7:0] d_hp = player_move ? e_hp : p_hp;
    
    wire is_boost;
    wire [7:0] power, threshold;
    move_rom mrom(.id(a_pkmn_id), .move_id(a_move), .boost(is_boost), .power(power), .threshold(threshold));
    
    //calculate damage and hp
    wire [8:0] dmg;
    damage_calc dc(.power(power), .def(d_def), .atk(a_atk), .boost_lvl(a_boost), .final(dmg));
    wire [7:0] d_hp_after;
    hp_update hu(.damage(dmg), .hp(d_hp), .new_hp(d_hp_after));
    
    
    //outcome of this one action
    wire hit = (rnd < threshold);
    wire at_cap = (a_boost == 2'd3);

    wire [7:0] d_hp_next = (!is_boost && hit) ? d_hp_after : d_hp;     //only a hit lowers hp
    wire [1:0] a_boost_next = is_boost ? (at_cap ? a_boost : a_boost + 2'd1) : a_boost;

    assign result = is_boost ? (at_cap ? 2'd3 : 2'd2)
                             : (hit    ? 2'd0 : 2'd1);

    //DEMUXES: send the results back to the correct side, leave the other side unchanged
    assign e_hp_next    = player_move ? d_hp_next    : e_hp;
    assign p_hp_next    = player_move ? p_hp         : d_hp_next;
    assign p_boost_next = player_move ? a_boost_next : p_boost_lvl;
    assign e_boost_next = player_move ? e_boost_lvl  : a_boost_next;


endmodule
