module move_rom(input [4:0] id, output reg boost,
                output reg [7:0] power, threshold);
  always @(*) begin
    case (id)
      5'd0: begin boost=1'b0; power=8'd20; threshold=8'd128; end
      5'd1: begin boost=1'b0; power=8'd40; threshold=8'd115; end
      5'd2: begin boost=1'b0; power=8'd60; threshold=8'd96; end
      5'd3: begin boost=1'b1; power=8'd0; threshold=8'd128; end
      5'd4: begin boost=1'b0; power=8'd45; threshold=8'd128; end
      5'd5: begin boost=1'b0; power=8'd65; threshold=8'd128; end
      5'd6: begin boost=1'b0; power=8'd85; threshold=8'd96; end
      5'd7: begin boost=1'b1; power=8'd0; threshold=8'd128; end
      5'd8: begin boost=1'b0; power=8'd20; threshold=8'd128; end
      5'd9: begin boost=1'b0; power=8'd40; threshold=8'd115; end
      5'd10: begin boost=1'b0; power=8'd60; threshold=8'd96; end
      5'd11: begin boost=1'b1; power=8'd0; threshold=8'd128; end
      5'd12: begin boost=1'b0; power=8'd45; threshold=8'd128; end
      5'd13: begin boost=1'b0; power=8'd65; threshold=8'd115; end
      5'd14: begin boost=1'b0; power=8'd85; threshold=8'd96; end
      5'd15: begin boost=1'b1; power=8'd0; threshold=8'd128; end
      5'd16: begin boost=1'b0; power=8'd70; threshold=8'd128; end
      5'd17: begin boost=1'b0; power=8'd90; threshold=8'd115; end
      5'd18: begin boost=1'b0; power=8'd110; threshold=8'd96; end
      5'd19: begin boost=1'b1; power=8'd0; threshold=8'd128; end
      5'd20: begin boost=1'b0; power=8'd70; threshold=8'd128; end
      5'd21: begin boost=1'b0; power=8'd90; threshold=8'd115; end
      5'd22: begin boost=1'b0; power=8'd110; threshold=8'd96; end
      5'd23: begin boost=1'b1; power=8'd0; threshold=8'd128; end
      default: begin boost=0; power=0; threshold=0; end
    endcase
  end
endmodule
