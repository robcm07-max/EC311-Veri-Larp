'timescale 1ns / 1ps

module tb_move_rom(
    
);

    reg [4:0] id;                       //drive ROM address
    wire boost;                         //ROM data
    wire [7:0] power, threshold;        //ROM data

    move_rom DUT (.id(id), .boost(boost), .power(power), .threshold(threshold));

    integer i;
    initial begin 
        for(i = 0; i < 24; i = i+1) begin
            id = i;
            #10;
        end

        $finish;
    end 

endmodule
