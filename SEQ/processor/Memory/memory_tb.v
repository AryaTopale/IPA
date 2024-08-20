module memory_tb;

    // Signals
    reg clk = 0;
    reg [3:0] icode;
    reg [63:0] valA, valP, valE;
    wire [63:0] valM;
    wire dmem_error;

    // Instantiate the module
    memory dut (
        .clk(clk),
        .icode(icode),
        .valA(valA),
        .valP(valP),
        .valE(valE),
        .valM(valM),
        .dmem_error(dmem_error)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Initialize inputs
        icode = 4'b0000;
        valA = 8'hFF; // Assuming valA and valP can be any value less than 256
        valP = 8'hFF;
        valE = 8'hFF; // Assuming valE is within the range of 8192

        // Apply stimulus
        #10 icode = 4'b0101; // mrmovq
        #10 valE = 8'hFF;    // Example value for valE
        #10;

        #10 icode = 4'b0100; // rmmovq
        #10 valA = 64'h1234567890ABCDEF; // Example value for valA
        #10;

        #10 icode = 4'b1000; // call
        #10 valP = 64'hABCDEF0123456789; // Example value for valP
        #10;

        #10 icode = 4'b1001; // ret
        #10;

        #10 icode = 4'b1010; // pushq
        #10;

        #10 icode = 4'b1011; // popq
        #10;

        // End simulation
        #10 $finish;
    end

    // Display statements
    always @(posedge clk) begin
        $display("At time %t, icode = %b, valA = %h, valP = %h, valE = %h, valM = %h", $time, icode, valA, valP, valE, valM);
    end

endmodule
