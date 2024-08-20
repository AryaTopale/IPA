module pc_update_tb;

    // Signals
    reg [3:0] icode;
    reg cnd;
    reg clk;
    reg [63:0] valC;
    reg [63:0] valM;
    reg [63:0] valP;
    wire [63:0] newPC;
    
    // Instantiate the module under test
    pc_update uut (
        .icode(icode),
        .cnd(cnd),
        .clk(clk),
        .valC(valC),
        .valM(valM),
        .valP(valP),
        .newPC(newPC)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Initial stimulus
    initial begin
        // Initialize inputs
        icode = 4'b0;
        cnd = 1'b0;
        valC = 64'h0;
        valM = 64'h0;
        valP = 64'h0;

        // Apply inputs and observe outputs
        #20 icode = 4'b1000; // call
        #20 valC = 64'h123456789abcdef; // some example value for valC
        #30 $display("New PC after call: %h", newPC);
        
        #20 icode = 4'b1001; // ret
        #20 valP = 64'hfedcba987654321; // some example value for valP
        #30 $display("New PC after ret: %h", newPC);
        
        #20 icode = 4'b0111; // jxx
        #20 cnd = 1'b1; // condition true
        #20 valC = 64'h1111111111111111; // some example value for valC
        #30 $display("New PC after jxx (condition true): %h", newPC);
        
        #20 cnd = 1'b0; // condition false
        #20 valP = 64'h2222222222222222; // some example value for valC
        #30 $display("New PC after jxx (condition false): %h", newPC);
        
        #20 $finish;
    end

endmodule
