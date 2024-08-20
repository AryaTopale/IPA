`include "/home/arya/Documents/project-team_31/SEQ/processor/Fetch/fetch.v"
module decode_tb;

    reg clk;
    wire [3:0]icode;
    wire [3:0]ifun;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [63:0] valP;
    wire [63:0] valC;
    reg [63:0]PC;
    // reg [63:0] valE;
    // reg [63:0] valM;
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

    fetch fetch_block(.clk(clk),.PC(PC),.icode(icode),.ifun(ifun),.rA(rA),
              .rB(rB),.valC(valC),.valP(valP), .imem_error(imem_error), .halt(halt), .invalid_instr(invalid_instr));
    // Instantiate the decode module
    decode uut (
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

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin 
    clk=0;
    PC=64'd0;
    #15 clk=~clk;PC=64'd3;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    
  end 
  
  initial begin
		$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%d rB=%d,valC=%d,valP=%d valA=%d valB=%d\n",
                  clk,PC,icode,ifun,rA,rB,valC,valP,valA,valB);
    end
endmodule