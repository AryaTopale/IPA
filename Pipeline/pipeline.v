`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "control.v"

module pipeline;
    reg [63:0] F_predPC = 0;
    reg clk;
    reg [2:0] D_stat = 1;
    reg [3:0] D_icode = 1;
    reg [3:0] D_ifun = 0;
    reg [3:0] D_rA = 0;
    reg [3:0] D_rB = 0;
    reg [63:0] D_valC = 0;
    reg [63:0] D_valP = 0;
    reg [2:0] E_stat = 1;
    reg [3:0] E_icode = 1;
    reg [3:0] E_ifun = 0;
    reg [63:0] E_valC = 0;
    reg [63:0] E_valA = 0;
    reg [63:0] E_valB = 0;
    reg [3:0] E_dstE = 0;
    reg [3:0] E_dstM = 0;
    reg [3:0] E_srcA = 0;
    reg [3:0] E_srcB = 0;
    reg [2:0] M_stat = 1;
    reg [3:0] M_icode = 1;
    reg M_Cnd = 0;
    reg [63:0] M_valE = 0;
    reg [63:0] M_valA = 0;
    reg [3:0] M_dstE = 0;
    reg [3:0] M_dstM = 0;
    reg [2:0] W_stat = 1;
    reg [3:0] W_icode = 1;
    reg [63:0] W_valE = 0;
    reg [63:0] W_valM = 0;  
    reg [3:0] W_dstE = 0;
    reg [3:0] W_dstM = 0;
    wire [2:0] f_stat;
    wire [3:0] f_icode;
    wire [3:0] f_ifun;
    wire [3:0] f_rA;
    wire [3:0] f_rB;
    wire [63:0] f_valC;
    wire [63:0] f_valP;
    wire [63:0] f_predPC;
    wire [2:0] d_stat;
    wire [3:0] d_icode;
    wire [3:0] d_ifun;
    wire [63:0] d_valC;
    wire [63:0] d_valA;
    wire [63:0] d_valB;
    wire [3:0] d_dstE;
    wire [3:0] d_dstM;
    wire [3:0] d_srcA;
    wire [3:0] d_srcB;
    wire [2:0] e_stat;
    wire [3:0] e_icode;
    wire e_Cnd;
    wire [63:0] e_valE;
    wire [63:0] e_valA;
    wire [3:0] e_dstE;
    wire [3:0] e_dstM;
    wire [2:0] m_stat;
    wire [3:0] m_icode;
    wire [63:0] m_valE;
    wire [63:0] m_valM;
    wire [3:0] m_dstE;
    wire [3:0] m_dstM;
    fetch f(
        .F_predPC(F_predPC),
        .M_icode(M_icode),
        .M_Cnd(M_Cnd),
        .M_valA(M_valA),
        .W_icode(W_icode),
        .W_valM(W_valM),
        .f_stat(f_stat),
        .f_icode(f_icode),
        .f_ifun(f_ifun),
        .f_rA(f_rA),
        .f_rB(f_rB),
        .f_valC(f_valC),
        .f_valP(f_valP),
        .f_predPC(f_predPC)
    );
    decode d(
        .clk(clk),
        .D_stat(D_stat),
        .D_icode(D_icode),
        .D_ifun(D_ifun),
        .D_rA(D_rA),
        .D_rB(D_rB),
        .D_valC(D_valC),
        .D_valP(D_valP),
        .e_dstE(e_dstE),
        .e_valE(e_valE),
        .M_dstE(M_dstE),
        .M_valE(M_valE),
        .M_dstM(M_dstM),
        .m_valM(m_valM),
        .W_dstM(W_dstM),
        .W_valM(W_valM),
        .W_dstE(W_dstE),
        .W_valE(W_valE),
        .d_stat(d_stat),
        .d_icode(d_icode),
        .d_ifun(d_ifun),
        .d_valC(d_valC),
        .d_valA(d_valA),
        .d_valB(d_valB),
        .d_dstE(d_dstE),
        .d_dstM(d_dstM),
        .d_srcA(d_srcA),
        .d_srcB(d_srcB)
    );
    execute e(
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
        .e_dstM(e_dstM)
    );

    memory m(
        .clk(clk),
        .M_stat(M_stat),
        .M_icode(M_icode),
        .M_valE(M_valE),
        .M_valA(M_valA),
        .M_dstE(M_dstE),
        .M_dstM(M_dstM),
        .m_stat(m_stat),
        .m_icode(m_icode),
        .m_valE(m_valE),
        .m_valM(m_valM),
        .m_dstE(m_dstE),
        .m_dstM(m_dstM)
    );
    assign Stat = W_stat;
    wire W_stall;
    wire M_bubble;
    wire E_bubble;
    wire D_bubble;
    wire D_stall;
    wire F_stall;

    control c(
        .D_icode(D_icode),
        .d_srcA(d_srcA),
        .d_srcB(d_srcB),
        .E_icode(E_icode),
        .E_dstM(E_dstM),
        .e_Cnd(e_Cnd),
        .M_icode(M_icode),
        .m_stat(m_stat),
        .W_stat(W_stat),
        .W_stall(W_stall),
        .M_bubble(M_bubble),
        .E_bubble(E_bubble),
        .D_bubble(D_bubble),
        .D_stall(D_stall),
        .F_stall(F_stall)
    );
    always @(posedge clk) begin
        if (F_stall != 1) begin
            F_predPC <= f_predPC;
        end
    end
    always @(posedge clk) begin
        if (D_stall == 0) begin

            if (D_bubble == 0) begin

                D_stat <= f_stat;
                D_icode <= f_icode;
                D_ifun <= f_ifun;
                D_rA <= f_rA;
                D_rB <= f_rB;
                D_valC <= f_valC;
                D_valP <= f_valP;
            end
            else begin
                D_stat <= 1;
                D_icode <= 1;
                D_ifun <= 0;
                D_rA <= 0;
                D_rB <= 0;
                D_valC <= 0;
                D_valP <= 0;
            end
        end
        
    end
    always @(posedge clk) begin
        if (E_bubble == 1) begin

            E_stat <= 1;
            E_icode <= 1;
            E_ifun <= 0;
            E_valC <= 0;
            E_valA <= 0;
            E_valB <= 0;
            E_dstE <= 0;
            E_dstM <= 0;
            E_srcA <= 0;
            E_srcB <= 0;
        end
        else begin
            E_stat <= d_stat;
            E_icode <= d_icode;
            E_ifun <= d_ifun;
            E_valC <= d_valC;
            E_valA <= d_valA;
            E_valB <= d_valB;
            E_dstE <= d_dstE;
            E_dstM <= d_dstM;
            E_srcA <= d_srcA;
            E_srcB <= d_srcB;
        end
    end
    always @(posedge clk) begin
        if (M_bubble == 1) begin
            M_stat <= 1;
            M_icode <= 1;
            M_Cnd <= 0;
            M_valE <= 0;
            M_valA <= 0;
            M_dstE <= 0;
            M_dstM <= 0;
        end
        else begin
            M_stat <= e_stat;
            M_icode <= e_icode;
            M_Cnd <= e_Cnd;
            M_valE <= e_valE;
            M_valA <= e_valA;
            M_dstE <= e_dstE;
            M_dstM <= e_dstM;
        end
    end
    always @(posedge clk) begin
        if (W_stall != 1) begin
            W_stat <= m_stat;
            W_icode <= m_icode;
            W_valE <= m_valE;
            W_valM <= m_valM;
            W_dstE <= m_dstE;
            W_dstM <= m_dstM;
        end
    end
    initial begin
        clk <= 0;
        forever #5 clk <= ~clk; 
    end
    initial begin
        #500
        $finish;
    end
    initial begin
        $monitor("time=%0d  clk=%0d  f_PC=%0d  f_rA=%0d  f_rB=%0d  f_valC=%0d  f_valP=%0d\nf_icode=%0d f_ifun=%0d, F_predPC = %0d, D_icode = %0d, d_icode = %0d, E_icode = %0d, e_icode = %0d, M_icode = %0d, m_icode = %0d, W_icode = %0d, w_icode = %0d , R0=%0d  R1=%0d  R2=%0d  R3=%0d  R4=%0d  R5=%0d  R6=%0d  R7=%0d  R8=%0d  R9=%0d  R10=%0d  R11=%0d  R12=%0d  R13=%0d  R14=%0d    ||   e_cnd=%0d E_bubble=%0d\n", $time, clk, f.f_pc, f_rA, f_rB, f_valC, f_valP, f_icode,f_ifun,F_predPC,D_icode,d_icode,E_icode,e_icode,M_icode,m_icode,W_icode,W_icode, d.reg_array[0], d.reg_array[1], d.reg_array[2], d.reg_array[3], d.reg_array[4], d.reg_array[5], d.reg_array[6], d.reg_array[7], d.reg_array[8], d.reg_array[9], d.reg_array[10], d.reg_array[11], d.reg_array[12], d.reg_array[13], d.reg_array[14],e_Cnd,E_bubble);
    end
    always @(*) begin      
        if(Stat == 2) begin
            $finish;
        end
    end
endmodule
