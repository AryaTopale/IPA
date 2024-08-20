module pc_select(
    // Inputs
    input [63:0] F_predPC,
    input [3:0] M_icode,
    input M_Cnd,
    input [63:0] M_valA,
    input [3:0] W_icode,
    input [63:0] W_valM,

    // Outputs
    output reg[63:0] f_pc
);

    always @(*) begin
        
        if (M_icode == 7 && M_Cnd == 0) begin

            f_pc <= M_valA;
        end
        else if (W_icode == 9) begin
            
            f_pc <= W_valM;
        end
        else begin

            f_pc <= F_predPC;
        end
    end
endmodule