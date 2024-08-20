`timescale 1ns / 1ps

module alu_tb;

    // Inputs
    reg clk;
    reg [2:0] E_stat;
    reg [3:0] E_icode;
    reg [3:0] E_ifun;
    reg signed [63:0] E_valC;
    reg signed [63:0] E_valA;
    reg signed [63:0] E_valB;
    reg signed [3:0] E_dstE;
    reg [3:0] E_dstM;
    reg [2:0] W_stat;
    reg [2:0] m_stat;

    // Outputs
    wire [2:0] e_stat;
    wire [3:0] e_icode;
    wire e_Cnd;
    wire signed [63:0] e_valE;
    wire [63:0] e_valA;
    wire [3:0] e_dstE;
    wire [3:0] e_dstM;
    wire zeroflag;
    wire signflag;
    wire overflow;

    // Instantiate the ALU module
    execute uut (
        .clk(clk),
        .E_stat(E_stat),
        .E_icode(E_icode),
        .E_ifun(E_ifun),
        .E_valC(E_valC),
        .E_valA(E_valA),
        .E_valB(E_valB),
        .E_dstE(E_dstE),
        .E_dstM(E_dstM),
        .W_stat(W_stat),
        .m_stat(m_stat),
        .e_stat(e_stat),
        .e_icode(e_icode),
        .e_Cnd(e_Cnd),
        .e_valE(e_valE),
        .e_valA(e_valA),
        .e_dstE(e_dstE),
        .e_dstM(e_dstM),
        .zeroflag(zeroflag),
        .signflag(signflag),
        .overflow(overflow)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initial values
    initial begin
        clk = 0;
        E_stat = 3'b000;
        E_icode = 4'b0000;
        E_ifun = 4'b0000;
        E_valC = 64'h0000000000000000;
        E_valA = 64'h0000000000000000;
        E_valB = 64'h0000000000000000;
        E_dstE = 4'b0000;
        E_dstM = 4'b0000;
        W_stat = 3'b000;
        m_stat = 3'b000;
        #10;
        // Add more test cases here
        $finish;
    end

endmodule
