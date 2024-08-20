module memory(
    input clk,
    input [3:0] icode,
    input [63:0] valA, valP, valE,
    output reg [63:0] valM,
    output reg dmem_error
);
    reg [63:0] mem [0:8191]; 
    

    // end
    always @(*) begin
        dmem_error = 1'b0; 
        if (icode == 4'b0100||icode==4'b0101||icode == 4'b1000 || icode == 4'b1010) begin 
            if (valE >= 8192) 
                dmem_error = 1'b1;
        end
    end
    always @(*) begin
        if (icode == 4'b0101) // mrmovq
            valM = mem[valE];
        else if (icode == 4'b0100) // rmmovq
            mem[valE] = valA;
        else if (icode == 4'b1000) // call
            mem[valE] = valP;
        else if (icode == 4'b1001) // ret
            valM = mem[valA];
        else if (icode == 4'b1010) // pushq
            mem[valE] = valA;
        else if (icode == 4'b1011) // popq
            valM = mem[valA];
    end
endmodule