'timescale 1ns / 1ps

module tb_move_rom(
    
);

    reg [4:0] id;                       //drive ROM address
    wire boost;                          //ROM data
    wire reg [7:0] power, threshold;    //ROM data

    tb_move_rom DUT (.id(id), .boost(boost), .power(power), .threshold(threshold));

    integer 1;
    initial begin 
        for(i = 0; 1 < 24; i = i+1) begin
            id = 1;
            #10
        end

        $finish
    end 

endmodule
