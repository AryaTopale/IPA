module xor_gate(output Y, input A, input B);
    xor x1(Y,A,B);
endmodule
module xor_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] out
);
    genvar i;
    
    generate
        for (i = 0; i < 64; i = i + 1) begin
            xor_gate xor1 (
                .Y(out[i]),
                .A(A[i]),
                .B(B[i])
            );
        end
    endgenerate

endmodule
