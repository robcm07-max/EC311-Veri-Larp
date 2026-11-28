`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 09:47:28 PM
// Design Name: 
// Module Name: main_fsm
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


module main_fsm(
    input clk,
    input reset,
    input confirm,         //press button to continue
    input [3:0] selection,      //will be switches corresponding to moves
    output reg [3:0] state,
    output reg [1:0] moves_done,
    output reg player_move,      
    
                        //message stuff 
                        //values for the display
                        output reg [7:0] p_hp, e_hp,
                        output [7:0] p_hp_max, e_hp_max,
                        output [2:0] p_id, e_id,
                        output reg [2:0] p_faint_count, e_faint_count,
                        //message interface (list in the rules spec)
                        output reg [5:0] msg_id,
                        output reg [2:0] arg_a,         //creature id
                        output reg [4:0] arg_b,         //move id
                        output reg [2:0] game_state     //0 title, 1 menu, 2 message, 3 win, 4 lose
);
parameter TEAM_N = 3;
    
    //constants for the sake of simplicity 
    //localparam basically lets you make constants
    //states
    localparam[3:0] 
        TITLE = 4'd0,
        SEND_ENEMY = 4'd1,
        SEND_PLAYER  = 4'd2,
        MOVE_SELECTION = 4'd3,
        DETERMINE_ORDER = 4'd4,
        MOVE_USED = 4'd5,
        EXECUTE_MOVE = 4'd6,
        FAINT_CHECK = 4'd7,
        FAINTED = 4'd8,
        SEND_NEXT = 4'd9,
        WIN = 4'd10,
        LOSE = 4'd11,
        MOVE_RESULT = 4'd12;
    
    //result codes from execute_move
    localparam [1:0] R_HIT = 2'd0, R_MISS = 2'd1, R_UP = 2'd2, R_MAXED = 2'd3;
    
                    //more message stuff 
                    //message ids (rules spec, section 8)
                    localparam [5:0]
                        MSG_NONE = 0,          MSG_TITLE = 1,
                        MSG_ENEMY_SENDS = 2,   MSG_PLAYER_SENDS = 3,   MSG_MENU_PROMPT = 4,
                        MSG_PLAYER_USED = 5,   MSG_ENEMY_USED = 6,
                        MSG_PLAYER_MISSED = 7, MSG_ENEMY_MISSED = 8,
                        MSG_PLAYER_ATK_UP = 9, MSG_ENEMY_ATK_UP = 10,
                        MSG_PLAYER_ATK_MAX = 11, MSG_ENEMY_ATK_MAX = 12,
                        MSG_PLAYER_FAINTED = 13, MSG_ENEMY_FAINTED = 14,
                        MSG_WIN = 15,          MSG_LOSE = 16;

    //team order: slot 0 is the rightmost 3 bits
    localparam [17:0] P_TEAM = {3'd5, 3'd4, 3'd3, 3'd2, 3'd1, 3'd0};   //player: 0,1,2,...
    localparam [17:0] E_TEAM = {3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5};   //enemy: 5,4,3,...

    //using next stage in order to use button confirmation 
    //registers that hold the battle
    reg [1:0] p_boost, e_boost;         //attack stages
    reg [1:0] p_move, e_move;           //move chosen this round
    reg [1:0] result;                   //outcome of the last move
    reg [3:0] next_state;
    //starting arrow
    initial begin
        state = TITLE;  
        moves_done = 2'd0;  
        player_move = 1'b0;
        p_hp = 8'd0;  
        e_hp = 8'd0;  
        p_faint_count = 3'd0; 
        e_faint_count = 3'd0;
        p_boost = 2'd0;  
        e_boost = 2'd0;  
        p_move = 2'd0;  
        e_move = 2'd0;  
        result = R_HIT;
    end
    
    //which creature is out: the faint count is also the team index, since
    //creatures go in order and never come back
    wire [2:0] p_idx = (p_faint_count >= TEAM_N) ? (TEAM_N - 1) : p_faint_count;
    wire [2:0] e_idx = (e_faint_count >= TEAM_N) ? (TEAM_N - 1) : e_faint_count;
    assign p_id = P_TEAM[p_idx*3 +: 3];
    assign e_id = E_TEAM[e_idx*3 +: 3];
    
    //stats of the creatures out (max hp for the bars, speed for the order)
    wire [7:0] p_spd, e_spd;
    stats_rom p_stats(.id(p_id), .hp(p_hp_max), .atk(), .def(), .spd(p_spd));
    stats_rom e_stats(.id(e_id), .hp(e_hp_max), .atk(), .def(), .spd(e_spd));

    //random numbers: accuracy rolls and the enemy's move pick
    wire [6:0] rnd_full;
    lfsr_8bit rng(.clk(clk), .rand_0_127(rnd_full), .lfsr());
    
    //your execute_move: pure logic, shows what the registers WOULD become
    wire [7:0] p_hp_next, e_hp_next;
    wire [1:0] p_boost_next, e_boost_next, res;
    execute_move dut(.rnd(rnd_full), .p_pkmn_id(p_id), .p_move_id(p_move),
                     .e_pkmn_id(e_id), .e_move_id(e_move),
                     .p_boost_lvl(p_boost), .e_boost_lvl(e_boost),
                     .p_hp(p_hp), .e_hp(e_hp), .player_move(player_move),
                     .p_hp_next(p_hp_next), .e_hp_next(e_hp_next),
                     .p_boost_next(p_boost_next), .e_boost_next(e_boost_next),
                     .result(res));

    //has the creature that was just hit fainted?
    wire fainted_flag = player_move ? (e_hp == 8'd0) : (p_hp == 8'd0);
    
    //which switch is on picks the slot (lowest one wins)
    wire [1:0] sel_move = selection[0] ? 2'd0 :
                          selection[1] ? 2'd1 :
                          selection[2] ? 2'd2 : 2'd3;
    always @(*)
        begin
            next_state = state;
            case(state)
                TITLE: next_state<=SEND_ENEMY;
                SEND_ENEMY: begin
                    if (moves_done == 2'd0) next_state<=SEND_PLAYER;
                    else next_state<=MOVE_SELECTION; 
                end
                SEND_PLAYER: next_state<=MOVE_SELECTION;
                MOVE_SELECTION: begin 
                    if (selection != 4'd0) next_state<=DETERMINE_ORDER; //reset moves_done and player
                    else next_state<=MOVE_SELECTION;
                end
                DETERMINE_ORDER: next_state<=MOVE_USED; //compare speed and set player flag
                MOVE_USED: next_state<=EXECUTE_MOVE; //based on player flag, send message
                EXECUTE_MOVE: next_state<=MOVE_RESULT; //based on player flag do move (already done), also increase moves_done
                FAINT_CHECK: begin
                    if (!fainted_flag && moves_done < 2) next_state<=MOVE_USED;
                    else if (!fainted_flag && moves_done == 2) next_state<=MOVE_SELECTION;
                    else next_state<=FAINTED;
                    //based on player flag check if the pokemon hp = 0 and raise flag
                end
                FAINTED: next_state<=SEND_NEXT; //increase corresponding faint count based on player flag
                SEND_NEXT: begin
                    if (p_faint_count == TEAM_N) next_state<=LOSE;
                    else if (e_faint_count == TEAM_N) next_state<=WIN;
                    else if (player_move) next_state<=SEND_ENEMY;
                    else next_state<=SEND_PLAYER;
                end
                WIN: next_state<=TITLE;   
                LOSE: next_state<=TITLE;  
                MOVE_RESULT: next_state<=FAINT_CHECK;
                default: next_state<=TITLE;
            endcase
        end
    //output control
    //also contantly checking
    always @(*)
    begin
        msg_id = MSG_NONE;  arg_a = 3'd0;  arg_b = 5'd0;  game_state = 3'd2;
        case (state)
            TITLE:          begin msg_id = MSG_TITLE; game_state = 3'd0; end
            SEND_ENEMY:     begin msg_id = MSG_ENEMY_SENDS;  arg_a = e_id; end
            SEND_PLAYER:    begin msg_id = MSG_PLAYER_SENDS; arg_a = p_id; end
            MOVE_SELECTION: begin msg_id = MSG_MENU_PROMPT;  arg_a = p_id; game_state = 3'd1; end
            MOVE_USED: begin
                msg_id = player_move ? MSG_PLAYER_USED : MSG_ENEMY_USED;
                arg_a  = player_move ? p_id : e_id;
                arg_b  = player_move ? {p_id, p_move} : {e_id, e_move};
            end
            MOVE_RESULT: begin
                arg_a = player_move ? p_id : e_id;
                case (result)
                    R_MISS:   msg_id = player_move ? MSG_PLAYER_MISSED  : MSG_ENEMY_MISSED;
                    R_UP:     msg_id = player_move ? MSG_PLAYER_ATK_UP  : MSG_ENEMY_ATK_UP;
                    R_MAXED:  msg_id = player_move ? MSG_PLAYER_ATK_MAX : MSG_ENEMY_ATK_MAX;
                    default:  msg_id = MSG_NONE;
                endcase
            end
            FAINTED: begin      //player_move says who ACTED, so the other side fainted
                msg_id = player_move ? MSG_ENEMY_FAINTED : MSG_PLAYER_FAINTED;
                arg_a  = player_move ? e_id : p_id;
            end
            WIN:  begin msg_id = MSG_WIN;  game_state = 3'd3; end
            LOSE: begin msg_id = MSG_LOSE; game_state = 3'd4; end
        endcase
    end
    
    //states that move on by themselves; all others wait for confirm
    wire auto_state = (state == DETERMINE_ORDER) || (state == EXECUTE_MOVE) ||
                      (state == FAINT_CHECK)     || (state == SEND_NEXT)    ||
                      (state == MOVE_RESULT && result == R_HIT);
    wire advance = confirm || auto_state;

    //only change on push confirm
    always @(posedge clk, posedge reset) 
        begin
            state <= next_state;

            //what happens when this state is LEFT
            case (state)
                TITLE: begin                          //start a new game
                    moves_done <= 2'd0;
                    p_boost <= 2'd0;  
                    e_boost <= 2'd0;
                    p_hp <= p_hp_max;  
                    e_hp <= e_hp_max;
                end
                MOVE_SELECTION: begin                 //latch both moves, start the round
                    p_move <= sel_move;
                    e_move <= rnd_full[9:8];
                    moves_done <= 2'd0;
                end
                DETERMINE_ORDER:                      //faster goes first, tie goes to the player
                    player_move <= (p_spd >= e_spd);
                EXECUTE_MOVE: begin                   //save the outcome of this move
                    p_hp <= p_hp_next;  
                    e_hp <= e_hp_next;
                    p_boost <= p_boost_next;  
                    e_boost <= e_boost_next;
                    result <= res;
                    moves_done <= moves_done + 2'd1;
                end
                FAINT_CHECK:                          //nobody fainted and one move left: other side acts
                    if (!fainted_flag && moves_done < 2'd2)
                        player_move <= ~player_move;
                FAINTED:                              //count the creature that went down
                    if (player_move) e_faint_count <= e_faint_count + 3'd1;
                    else             p_faint_count <= p_faint_count + 3'd1;
                SEND_NEXT:                            //load the next creature at full hp
                    if (p_faint_count != TEAM_N && e_faint_count != TEAM_N) begin
                        if (player_move) begin e_hp <= e_hp_max; e_boost <= 2'd0; end
                        else             begin p_hp <= p_hp_max; p_boost <= 2'd0; end
                    end
                WIN, LOSE: begin                      //get ready for a new game
                    p_faint_count <= 3'd0;  e_faint_count <= 3'd0;
                end
            endcase
        end 
    
endmodule
