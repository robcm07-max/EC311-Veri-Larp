`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 10:58:29 AM
// Design Name: 
// Module Name: tb_move_rom
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


module tb_move_rom(

    );
    reg [2:0] id;
    reg [1:0] move_id;                  //drive ROM address
    wire boost;                         //ROM data
    wire [7:0] power, threshold;        //ROM data

    move_rom DUT (.move_id(move_id), .boost(boost), .power(power), .threshold(threshold), .id(id));

    integer i;
    integer j;
    initial begin 
        for(i = 0; i < 6; i = i+1) begin
            id = i;
            for(j = 0; j < 4; j = j+1) begin
                move_id = j;
                #10;
            end
        end

        $finish;
    end 

endmodule
