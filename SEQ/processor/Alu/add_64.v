module adder(
    output S,
    output Cout,
    input A,
    input B,
    input Cin,
    input M
);
    wire t1, t2, t3;
    wire B1;
    xor x0(B1, B, M);
    xor x1(t1, A, B1);
    xor x2(S, t1, Cin);
    and a1(t2, A, B1);
    and a2(t3, t1, Cin);
    or o1(Cout, t2, t3);
endmodule

module add_64bit(
    input [63:0] A,
    input [63:0] B,
    input [63:0] Cin,
    input M,
    output overflow,
    output [63:0] Cout,
    output [63:0] S
);
    genvar i, j;
    generate
        for (j = 0; j < 1; j = j + 1) begin
            adder add0(
                .Cout(Cout[0]),
                .S(S[0]),
                .A(A[0]),
                .B(B[0]),
                .Cin(Cin[0]), // Connect only the LSB of Cin
                .M(M)
            );
        end
        for (i = 1; i < 64; i = i + 1) begin
            adder add1 (
                .Cout(Cout[i]),
                .S(S[i]),
                .A(A[i]),
                .B(B[i]),
                .Cin(Cout[i-1]),
                .M(M)
            );
        end
        assign overflow=Cout[63];
        
    endgenerate
endmodule
