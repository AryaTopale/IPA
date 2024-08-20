module pc_update(
    input [3:0]icode,
    input cnd,
    input clk,
    input [63:0] valC,
    input [63:0] valM,
    input [63:0] valP,
    output reg [63:0] newPC
);
    reg[31:0] final;
    always @(*)begin
        if(icode==4'b1000)begin //call
            newPC=valC;
        end
        if(icode==4'b1001)begin //ret
            newPC=valP;
        end
        if(icode==4'b0111)begin //jxx
            if(cnd)begin
                newPC=valC;
            end
            else
                newPC=valP;
        end
        else
            newPC=valP;
    end
endmodule