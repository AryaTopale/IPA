module write_back_tb;

reg clk;
reg [3:0] icode;
reg [3:0] rA;
reg [3:0] rB;
reg [63:0] valE;
reg [63:0] valM;

write_back wb_inst (
    .clk(clk),
    .icode(icode),
    .rA(rA),
    .rB(rB),
    .valE(valE),
    .valM(valM)
);

initial begin
    // Initialize inputs
    clk = 0;
    icode = 4'b0010;
    rA = 4'b0001;
    rB = 4'b0010;
    valE = 64'h123456789abcdef;
    valM = 64'hfedcba9876543210;
    
    // Add some delay for inputs to settle
    #10;
    
    // Toggle clock
    forever #5 clk = ~clk;
end

endmodule
