module control(
    // Inputs
    input [3:0] D_icode,
    input [3:0] d_srcA,
    input [3:0] d_srcB,
    input [3:0] E_icode,
    input [3:0] E_dstM,
    input e_Cnd,
    input [3:0] M_icode,
    input [2:0] m_stat,
    input [2:0] W_stat,

    // Outputs
    output reg W_stall,
    output reg M_bubble,
    output reg E_bubble,
    output reg D_bubble,
    output reg D_stall,
    output reg F_stall
);
    // Hazard conditions
    wire Ret = (D_icode == 9 || E_icode == 9 || M_icode == 9);
    wire LU_Haz = ((E_icode == 5 || E_icode == 11) && (E_dstM == d_srcA || E_dstM == d_srcB));
    wire Miss_Pred = (E_icode == 7 && e_Cnd == 0);

    // Control logic
    always @(*) begin
        F_stall = (Ret && (LU_Haz || Miss_Pred)) || LU_Haz || (Ret && Miss_Pred) || Ret ? 1 : 0;
        D_stall = (LU_Haz && Ret) || LU_Haz ? 1 : 0;
        D_bubble = (D_stall == 0) ? (Ret && Miss_Pred) || Ret || Miss_Pred ? 1 : 0 : 0;
        E_bubble = (LU_Haz && Ret) || (Ret && Miss_Pred) || LU_Haz || Miss_Pred ? 1 : 0;
        M_bubble = (m_stat >= 2 && m_stat <= 4) || (W_stat >= 2 && W_stat <= 4) ? 1 : 0;
        W_stall = (W_stat >= 2 && W_stat <= 4) ? 1 : 0;
    end

endmodule
