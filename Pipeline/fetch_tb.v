module fetch_tb;

    // Inputs
    reg [63:0] F_predPC;
    reg [3:0] M_icode;
    reg M_Cnd; // Corrected name
    reg [63:0] M_valA;
    reg [3:0] W_icode;
    reg [63:0] W_valM;
    
    // Outputs
    wire [2:0] f_stat;
    wire [3:0] f_icode;
    wire [3:0] f_ifun;
    wire [3:0] f_rA;
    wire [3:0] f_rB;
    wire [63:0] f_valC;
    wire [63:0] f_valP;
    wire [63:0] f_predPC;
    
    // Instantiate the fetch module
    fetch uut (
        .F_predPC(F_predPC),
        .M_icode(M_icode),
        .M_Cnd(M_Cnd), // Corrected name
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
    
    // Clock generation
    reg clk = 0;
    always #5 clk = ~clk;
    
    // Stimulus
    initial begin
        // Initialize inputs
        F_predPC = 64'd0;
        M_icode = 4'd0;
        M_Cnd = 0;
        M_valA = 64'd0;
        W_icode = 4'd0;
        W_valM = 64'd0;
        
        // Apply inputs
        #10;
        F_predPC = 64'd8;
        M_icode = 4'd7;
        M_Cnd = 1;
        M_valA = 64'd123;
        
        // Wait for some time
        #20;
        
        // Add more test cases if needed
        
        // End simulation
        #10;
        $finish;
    end
    
endmodule
