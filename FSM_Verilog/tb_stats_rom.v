'timescale 1ns / 1ps

module tb_stats_rom(
    
);

    reg [2:0] id;                       //drive ROM address
    wire [7:0] hp;                      //ROM data
    wire [7:0] atk, def, spd;           //ROM data

    stats_rom DUT (.id(id), .atk(atk), .def(def), .spd(spd));

    integer i;
    initial begin 
        for(i = 0; i < 6; i = i+1) begin
            id = i;
            #10;
        end

        $finish;
    end 

endmodule
