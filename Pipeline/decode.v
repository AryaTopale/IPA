module decode(
    input clk,

    // Inputs from D register
    input [2:0] D_stat,
    input [3:0] D_icode,
    input [3:0] D_ifun,
    input [3:0] D_rA,
    input [3:0] D_rB,
    input [63:0] D_valC,
    input [63:0] D_valP,

    // Inputs forwarded from execute stage
    input [3:0] e_dstE,
    input [63:0] e_valE,

    // Inputs forwarded from M register and memory stage
    input [3:0] M_dstE,
    input [63:0] M_valE,
    input [3:0] M_dstM,
    input [63:0] m_valM,

    // Inputs forwarded from W register
    input [3:0] W_dstM,
    input [63:0] W_valM,
    input [3:0] W_dstE,
    input [63:0] W_valE,

    // Outputs
    output reg[2:0] d_stat,
    output reg[3:0] d_icode,
    output reg[3:0] d_ifun,
    output reg[63:0] d_valC,
    output reg[63:0] d_valA,
    output reg[63:0] d_valB,
    output reg[3:0] d_dstE,
    output reg[3:0] d_dstM,
    output reg[3:0] d_srcA,
    output reg[3:0] d_srcB
);
    reg [63:0] reg_array[0:15];
    integer i;
    initial begin
        for (i = 0; i < 16; i = i+1) begin
          reg_array[i] <= 255; 
        end
    end
    always @(*) begin   
        d_stat <= D_stat;
        d_icode <= D_icode;
        d_ifun <= D_ifun;
        d_valC <= D_valC;
    end
always @(*) begin
    case (d_icode)
        2, 3, 6: d_dstE = D_rB;
        8, 9, 10, 11: d_dstE = 4;
        default: d_dstE = 15;
    endcase
end

always @(*) begin
    case (d_icode)
        5, 11: d_dstM = D_rA;
        default: d_dstM = 15;
    endcase
end

always @(*) begin
    case (d_icode)
        2, 4, 6: d_srcA = D_rA;
        9, 10, 11: d_srcA = 4;
        default: d_srcA = 15;
    endcase
end

    always @(*) begin
        case (d_icode)
            4, 5, 6: d_srcB = D_rB;
            8, 9, 10, 11: d_srcB = 4;
            default: d_srcB = 15;
        endcase
    end

    always @(*) begin

        if (d_icode == 7 || d_icode == 8) begin

            d_valA <= D_valP;
        end
        else if (d_srcA == e_dstE) begin

            d_valA <= e_valE;
        end
        else if (d_srcA == M_dstM) begin

            d_valA <= m_valM;
        end
        else if (d_srcA == M_dstE) begin

            d_valA <= M_valE;
        end
        else if (d_srcA == W_dstM) begin

            d_valA <= W_valM;
        end
        else if (d_srcA == W_dstE) begin

            d_valA <= W_valE;
        end
        else begin
            
            d_valA <= reg_array[d_srcA];
        end
    end
    always @(*) begin

        if (d_srcB == e_dstE) begin

            d_valB <= e_valE;
        end
        else if (d_srcB == M_dstM) begin

            d_valB <= m_valM;
        end
        else if (d_srcB == M_dstE) begin

            d_valB <= M_valE;
        end
        else if (d_srcB == W_dstM) begin

            d_valB <= W_valM;
        end
        else if (d_srcB == W_dstE) begin

            d_valB <= W_valE;
        end
        else begin
            
            d_valB <= reg_array[d_srcB];
        end
    end
    always @(posedge clk) begin
        reg_array[W_dstM] <= W_valM;
        reg_array[W_dstE] <= W_valE;
    end
endmodule