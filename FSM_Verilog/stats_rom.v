module stats_rom(input [2:0] id, output reg [8:0] hp,
                 output reg [7:0] atk, def, spd);
  always @(*) begin
    case (id)
      3'd0: begin hp=9'd200; atk=8'd112; def=8'd92; spd=8'd140; end
      3'd1: begin hp=9'd174; atk=8'd84; def=8'd104; spd=8'd59; end
      3'd2: begin hp=9'd244; atk=8'd122; def=8'd94; spd=8'd59; end
      3'd3: begin hp=9'd153; atk=8'd96; def=8'd76; spd=8'd119; end
      3'd4: begin hp=9'd256; atk=8'd87; def=8'd87; spd=8'd62; end
      3'd5: begin hp=9'd150; atk=8'd84; def=8'd78; spd=8'd89; end
      default: begin hp=0; atk=0; def=0; spd=0; end
    endcase
  end
endmodule
