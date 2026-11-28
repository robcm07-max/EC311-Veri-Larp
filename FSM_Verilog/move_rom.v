`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2026 10:56:50 AM
// Design Name: 
// Module Name: move_rom
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


module move_rom(
    input [2:0] id,
    input [1:0] move_id,
    output reg boost,
    output reg [7:0] power,
    output reg [7:0] threshold
    );
    
    always @(*) begin
        case(id)
            3'd0: begin 
                case(move_id)
                    2'd0: begin boost=1'b0; power=8'd20; threshold=8'd128; end
                    2'd1: begin boost=1'b0; power=8'd40; threshold=8'd115; end
                    2'd2: begin boost=1'b0; power=8'd60; threshold=8'd96; end
                    2'd3: begin boost=1'b1; power=8'd0; threshold=8'd128; end
                    default: begin boost=0; power=0; threshold=0; end
                endcase
                end
            3'd1: begin
                case(move_id)
                    2'd0: begin boost=1'b0; power=8'd45; threshold=8'd128; end
                    2'd1: begin boost=1'b0; power=8'd65; threshold=8'd128; end
                    2'd2: begin boost=1'b0; power=8'd85; threshold=8'd96; end
                    2'd3: begin boost=1'b1; power=8'd0; threshold=8'd128; end
                    default: begin boost=0; power=0; threshold=0; end
                endcase
                end
            3'd2: begin
                case(move_id)
                    2'd0: begin boost=1'b0; power=8'd20; threshold=8'd128; end
                    2'd1: begin boost=1'b0; power=8'd40; threshold=8'd115; end
                    2'd2: begin boost=1'b0; power=8'd60; threshold=8'd96; end
                    2'd3: begin boost=1'b1; power=8'd0; threshold=8'd128; end
                    default: begin boost=0; power=0; threshold=0; end
                endcase
                end 
            3'd3: begin
                case(move_id)
                    2'd0: begin boost=1'b0; power=8'd45; threshold=8'd128; end
                    2'd1: begin boost=1'b0; power=8'd65; threshold=8'd115; end
                    2'd2: begin boost=1'b0; power=8'd85; threshold=8'd96; end
                    2'd3: begin boost=1'b1; power=8'd0; threshold=8'd128; end
                    default: begin boost=0; power=0; threshold=0; end
                endcase
                end 
            3'd4: begin
                case(move_id)
                    2'd0: begin boost=1'b0; power=8'd70; threshold=8'd128; end
                    2'd1: begin boost=1'b0; power=8'd90; threshold=8'd115; end
                    2'd2: begin boost=1'b0; power=8'd110; threshold=8'd96; end
                    2'd3: begin boost=1'b1; power=8'd0; threshold=8'd128; end
                    default: begin boost=0; power=0; threshold=0; end
                endcase
                end 
            3'd5: begin
                case(move_id)
                    2'd0: begin boost=1'b0; power=8'd70; threshold=8'd128; end
                    2'd1: begin boost=1'b0; power=8'd90; threshold=8'd115; end
                    5'd2: begin boost=1'b0; power=8'd110; threshold=8'd96; end
                    2'd3: begin boost=1'b1; power=8'd0; threshold=8'd128; end
                    default: begin boost=0; power=0; threshold=0; end
                endcase
                end
              default: begin boost=0; power=0; threshold=0; end
            endcase
    end
    
endmodule
