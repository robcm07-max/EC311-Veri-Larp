import csv

with open("stats.csv") as f, open("stats_rom.v", "w") as out:
    out.write("module stats_rom(input [2:0] id, output reg [8:0] hp,\n")
    out.write("                 output reg [7:0] atk, def, spd);\n")
    out.write("  always @(*) begin\n    case (id)\n")
    for r in csv.DictReader(f):
        out.write(f"      3'd{r['id']}: begin hp=9'd{r['hp']}; atk=8'd{r['atk']}; "
                  f"def=8'd{r['def']}; spd=8'd{r['spd']}; end\n")
    out.write("      default: begin hp=0; atk=0; def=0; spd=0; end\n")
    out.write("    endcase\n  end\nendmodule\n")

with open("moves.csv") as f, open("move_rom.v", "w") as out:
    out.write("module move_rom(input [4:0] id, output reg boost,\n")
    out.write("                output reg [7:0] power, threshold);\n")
    out.write("  always @(*) begin\n    case (id)\n")
    for r in csv.DictReader(f):
        out.write(f"      5'd{r['move_id']}: begin boost=1'b{r['boost']}; "
                  f"power=8'd{r['power']}; threshold=8'd{r['threshold']}; end\n")
    out.write("      default: begin boost=0; power=0; threshold=0; end\n")
    out.write("    endcase\n  end\nendmodule\n")