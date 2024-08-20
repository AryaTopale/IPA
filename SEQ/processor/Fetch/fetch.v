module fetch(clk, PC, icode, ifun, rA, rB, valC, valP,
            imem_error, halt, invalid_instr);
input clk;
input [63:0] PC; 
output reg [3:0] icode, ifun, rA, rB;
output reg [63:0] valC, valP;
reg[7:0] instruction_memory[0:255];
output reg imem_error,halt,invalid_instr;
initial begin
    $readmemb("/home/arya/Documents/project-team_31/SEQ/testcase.txt", instruction_memory);
end
always @(*)
begin
    icode = instruction_memory[PC][7:4];
    ifun = instruction_memory[PC][3:0];
    invalid_instr = 0;
    imem_error = 0;
    halt=0;
    if (PC > 8191) begin
        imem_error <= 1;
    end
    
    else if (icode < 4'b0000 || icode > 4'b1100) begin
        invalid_instr <= 1;
        valP<=PC+1;
    end
    else if (icode == 4'b0000) begin //halt
        halt <= 1;
        valP <= PC + 1;
    end
    else if (icode == 4'b0001||icode==4'b1001) begin //nop ret
        valP <= PC + 1;
    end
    else if (icode == 4'b0010||icode==4'b0110||icode==4'b1010||icode==4'b1011) begin //cmovxx opq pushq popq
        valP <= PC + 2;
        rB <= instruction_memory[PC+1][3:0];
        rA <= instruction_memory[PC+1][7:4];
    end
    else if (icode == 4'b0100||icode==4'b0101||icode==4'b0011) begin //rmmovq mrmovq irmovq
        rB <= instruction_memory[PC+1][3:0];
        rA <= instruction_memory[PC+1][7:4];

        valC <= {instruction_memory[PC+9], instruction_memory[PC+8], 
                 instruction_memory[PC+7], instruction_memory[PC+6],
                 instruction_memory[PC+5], instruction_memory[PC+4],
                 instruction_memory[PC+3], instruction_memory[PC+2]};
        valP <= PC + 10;
    end
    else if (icode == 4'b0111||icode==4'b1000) begin  //jxx call 
        valP <= PC + 9;            
        valC <= {instruction_memory[PC+8], instruction_memory[PC+7], 
                 instruction_memory[PC+6], instruction_memory[PC+5],
                 instruction_memory[PC+4], instruction_memory[PC+3],
                 instruction_memory[PC+2], instruction_memory[PC+1]};
    end
end

endmodule
