`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2026 12:20:43 AM
// Design Name: 
// Module Name: tb_main_fsm
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


module tb_main_fsm(

    );
    reg clk = 0;
    reg reset, confirm;
    reg [3:0] selection;
    wire [3:0] state;
    wire [1:0] moves_done;
    wire player_move;
    wire [7:0] p_hp, e_hp, p_hp_max, e_hp_max;
    wire [2:0] p_id, e_id, p_faint_count, e_faint_count, game_state, arg_a;
    wire [5:0] msg_id;
    wire [4:0] arg_b;

    main_fsm dut(.clk(clk), .reset(reset), .confirm(confirm),
        .selection(selection), .state(state), .moves_done(moves_done),
        .player_move(player_move), .p_hp(p_hp), .e_hp(e_hp),
        .p_hp_max(p_hp_max), .e_hp_max(e_hp_max), .p_id(p_id), .e_id(e_id),
        .p_faint_count(p_faint_count), .e_faint_count(e_faint_count),
        .msg_id(msg_id), .arg_a(arg_a), .arg_b(arg_b), .game_state(game_state));

    always #5 clk = ~clk;

    task press;
        begin
            @(negedge clk) confirm = 1;
            @(negedge clk) confirm = 0;
            repeat (10) @(negedge clk);        //let the automatic states finish
        end
    endtask

    integer i;
    initial
    begin

    reset = 1; confirm = 0; selection = 4'b0010;       //switch 1 = medium move
    #20 reset = 0;

    //keep pressing until the game ends (state 10 = WIN, 11 = LOSE)
    for (i = 0; i < 300 && state != 4'd10 && state != 4'd11; i = i + 1) begin
        press;
        $display("t=%0t state=%0d p_hp=%0d e_hp=%0d msg=%0d faints p=%0d e=%0d",
                 $time, state, p_hp, e_hp, msg_id, p_faint_count, e_faint_count);
    end

    if (state == 4'd10 || state == 4'd11) $display("PASS: game ended");
    else                                  $display("FAIL: game never ended");
    $finish;
    end
endmodule
