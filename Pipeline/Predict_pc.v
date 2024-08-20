module Predict_pc(
    input [3:0] f_icode,
    input [63:0] f_valC,
    input [63:0] f_valP,
    output reg[63:0] f_predPC
);
    always @(*) begin 
        if (f_icode == 7 || f_icode == 8) begin
            f_predPC <= f_valC;
        end
        else begin
            f_predPC <= f_valP;
        end
    end
endmodule