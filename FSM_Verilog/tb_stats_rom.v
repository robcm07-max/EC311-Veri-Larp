'timescale 1ns / 1ps

module tb_stats_rom;

    reg [2:0] id;                       //drive ROM address
    wire reg [7:0] hp;                  //ROM data
    wire reg [7:0] atk, def, spd;       //ROM data

    tb_move_rom DUT (.id(id), .atk(atk), .def(def), .spd(spd));

    integer 1;
    initial begin 
        for(i = 0; 1 < 6; i = i+1) begin
            id = 1;
            #10
        end

        $finish
    end 

endmodule