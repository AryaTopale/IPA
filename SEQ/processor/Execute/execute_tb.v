`timescale 1ns / 1ps
`include "fetch.v"
`include "decode.v"
module execute_tb;
reg clk;
wire zeroflag;
wire overflow;
wire signflag;
wire [3:0]icode;
wire [3:0]ifun;
reg [63:0]PC;
wire [3:0] rA;
wire [3:0] rB;
wire [63:0] valC;
wire [63:0] valP;
wire [63:0] valE;
reg [63:0] valM;
wire [63:0] valA;
wire [63:0] valB;
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
wire cnd;


fetch fetch_block(.clk(clk),.PC(PC),.icode(icode),.ifun(ifun),.rA(rA),
              .rB(rB),.valC(valC),.valP(valP), .dmem_error(dmem_error), .halt(halt), .invalid_instr(invalid_instr));

    decode uut (
        .clk(clk),
        .icode(icode),
        .rA(rA),
        .rB(rB),
        // .valE(valE),
        // .valM(valM),
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

  initial begin
    

    clk=0;
    PC=64'd52;
    valM=64'd10;

    #10 clk=~clk;PC=64'd3;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;
  end 
  
  initial 
		$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valE=%d SF=%d ZF=%d OF=%d cnd=%d\n",clk,PC, icode,ifun,rA,rB,valA,valB,valE, signflag,zeroflag,overflow, cnd);
endmodule