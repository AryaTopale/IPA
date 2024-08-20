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
    wire [63:0] rax;
    wire [63:0] rcx;
    wire [63:0] rdx;
    wire [63:0] rbx;
    wire [63:0] rsp;
    wire [63:0] rbp;
    wire [63:0] rsi;
    wire [63:0] rdi;
    wire [63:0] r8;
    wire [63:0] r9;
    wire [63:0] r10;
    wire [63:0] r11;
    wire [63:0] r12;
    wire [63:0] r13;
    wire [63:0] r14;

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
        .rax(rax),
        .rcx(rcx),
        .rdx(rdx),
        .rbx(rbx),
        .rsp(rsp),
        .rbp(rbp),
        .rsi(rsi),
        .rdi(rdi),
        .r8(r8),
        .r9(r9),
        .r10(r10),
        .r11(r11),
        .r12(r12),
        .r13(r13),
        .r14(r14)
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
        .valM(valM)
    );
  initial begin    

    clk = 0;
    PC =0;
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;
    #10 clk = ~clk; 
    #10 clk = ~clk; PC = newPC;

  end 
  
  initial 
	$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valE=%d\t valP=%d r14=%d cnd=%d halt=%d\n", clk, PC, icode, ifun, rA, rB, valA, valB, valE,valP, r14, cnd, halt);
  
endmodule