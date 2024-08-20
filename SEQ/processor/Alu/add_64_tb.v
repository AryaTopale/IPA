module testbench_add_64bit;
    reg [63:0] A, B, Cin; // Extend Cin to 64 bits
    reg M;
    wire overflow;
    wire [63:0] S, Cout;
    
    // Instantiate the add_64bit module
    add_64bit adder_instance (
        .A(A),
        .B(B),
        .S(S),
        .Cout(Cout),
        .Cin(Cin), // Extend Cin to 64 bits
        .M(M),
        .overflow(overflow)
    );

    // Apply test cases
    initial begin
        // Test Case 1
        $dumpfile("add_64_tb.vcd");
        $dumpvars(0,testbench_add_64bit);
        A = 5;
        B = -1;
        Cin = 64'b1; 
        M = 1'b1;

        #10; // Allow some time for signals to propagate

        // Display results
        $display("Test Case 1:");
        $display("A = %b", A);
        $display("B = %b", B);
        $display("S = %d", S);
        $display("Cout[63] = %d", Cout[63]);
        $display("\n");
        $display("overflow= ", overflow);

        // Add more test cases as needed
        // End simulation
        $finish;
    end
endmodule
