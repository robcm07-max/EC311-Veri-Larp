`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 10:58:48 AM
// Design Name: 
// Module Name: tb_stats_rom
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


module tb_stats_rom(

    );
        
    reg [2:0] id;                       //drive ROM address
    wire [7:0] hp;                      //ROM data
    wire [7:0] atk, def, spd;           //ROM data

    stats_rom DUT (.id(id), .hp(hp), .atk(atk), .def(def), .spd(spd));

    integer i;
    initial begin 
        for(i = 0; i < 6; i = i+1) begin
            id = i;
            #5;
        end

        $finish;
    end 

endmodule
