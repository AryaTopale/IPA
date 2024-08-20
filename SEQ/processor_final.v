`include "fetch.v"
`include "write_back.v"
`include "decode.v"
`include "pc_update.v"
`include "execute.v"
`include "memory.v"

module processor;
    reg clk;
    wire zeroflag, overflow, signflag;
    wire [3:0] icode, ifun;
    reg [63:0] PC;
    wire [3:0] rA, rB;
    wire signed [63:0] valC, valP, valE, valM;
    wire dmem_error;
    wire imem_error;
    wire halt;
    wire signed [63:0] valA, valB;
    wire cnd;
    wire [63:0] newPC;
    reg signed [63:0] reg_file [0:14];
    wire signed [63:0] reg_wire [0:14];
    // Instantiating modules
    fetch fetch_block(
        .clk(clk),
        .PC(PC),
        .icode(icode),
        .ifun(ifun),
        .rA(rA),
        .rB(rB),
        .valC(valC),
        .valP(valP),
        .imem_error(imem_error),
        .halt(halt),
        .invalid_instr(invalid_instr)
    );

    decode decode_block(
        .clk(clk),
        .icode(icode),
        .rA(rA),
        .rB(rB),
        .valA(valA),
        .valB(valB),
        .rax(reg_file[0]),
        .rcx(reg_file[1]), 
        .rdx(reg_file[2]), 
        .rbx(reg_file[3]), 
        .rsp(reg_file[4]), 
        .rbp(reg_file[5]), 
        .rsi(reg_file[6]), 
        .rdi(reg_file[7]), 
        .r8(reg_file[8]), 
        .r9(reg_file[9]), 
        .r10(reg_file[10]), 
        .r11(reg_file[11]), 
        .r12(reg_file[12]), 
        .r13(reg_file[13]), 
        .r14(reg_file[14])
    );

    execute execute_block(
        .clk(clk),
        .icode(icode),
        .ifun(ifun),
        .valA(valA),
        .valB(valB),
        .valC(valC),
        .valE(valE),
        .cnd(cnd),
        .zeroflag(zeroflag),
        .signflag(signflag),
        .overflow(overflow)
    );

    memory memory_block(
        .clk(clk),
        .icode(icode),
        .valA(valA),
        .valP(valP),
        .valE(valE),
        .valM(valM),
        .dmem_error(dmem_error)
    );

    pc_update pc_block(
        .clk(clk),
        .icode(icode),
        .cnd(cnd),
        .valC(valC),
        .valM(valM),
        .valP(valP),
        .newPC(newPC)
    );

    write_back write_block(
        .clk(clk),
        .icode(icode),
        .rA(rA),
        .rB(rB),
        .valE(valE),
        .valM(valM),
        .rax(reg_wire[0]),
        .rcx(reg_wire[1]), 
        .rdx(reg_wire[2]), 
        .rbx(reg_wire[3]), 
        .rsp(reg_wire[4]), 
        .rbp(reg_wire[5]), 
        .rsi(reg_wire[6]), 
        .rdi(reg_wire[7]), 
        .r8(reg_wire[8]), 
        .r9(reg_wire[9]), 
        .r10(reg_wire[10]), 
        .r11(reg_wire[11]), 
        .r12(reg_wire[12]), 
        .r13(reg_wire[13]),
        .r14(reg_wire[14])
    );
initial begin    

    clk <= 0;
    PC <=0;
       $monitor("time=%0d  clk=%0d  PC=%0d icode=%0h  ifun=%0d  rA=%0d  rB=%0d  valC=%0d  valP=%0d  valA =%0d, valB=%0d, R0=%0d  R1=%0d  R2=%0d  R3=%0d  R4=%0d  R5=%0d  R6=%0d  R7=%0d  R8=%0d  R9=%0d  R10=%0d  R11=%0d  R12=%0d  R13=%0d  R14=%0d v , valC = %0d , valE = %0d, valM = %0d\n", $time, clk, PC, icode, ifun, rA, rB, valC, valP,valA , valB, reg_file[0], reg_file[1], reg_file[2], reg_file[3], reg_file[4], reg_file[5], reg_file[6], reg_file[7], reg_file[8], reg_file[9], reg_file[10], reg_file[11], reg_file[12], reg_file[13], reg_file[14] ,valC,valE,valM);
    forever begin
        #5
        clk=~clk;
    end
end
initial begin
    #600
    $finish;
end
always @(posedge clk) begin  
    PC <= newPC;
end	
always@(*)
    begin
        reg_file[0] = reg_wire[0];
        reg_file[1] = reg_wire[1];
        reg_file[2] = reg_wire[2];
        reg_file[3] = reg_wire[3];
        reg_file[4] = reg_wire[4];
        reg_file[5] = reg_wire[5];
        reg_file[6] = reg_wire[6];
        reg_file[7] = reg_wire[7];
        reg_file[8] = reg_wire[8];
        reg_file[9] = reg_wire[9];
        reg_file[10] = reg_wire[10];
        reg_file[11] = reg_wire[11];
        reg_file[12] = reg_wire[12];
        reg_file[13] = reg_wire[13];
        reg_file[14] = reg_wire[14];
    end
    always@(posedge clk)
    begin
        if(halt == 1)
            begin
                
                $finish;
            end
        
        else if(dmem_error  == 1)
            begin
                $finish;
            end
        else if(imem_error == 1)
            begin
                $finish;
            end

    end
endmodule