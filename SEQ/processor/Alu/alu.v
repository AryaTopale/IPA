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
module and_gate(output Y, input A, input B);
    and a1 (Y,A,B);
endmodule
module and_64bit (
    input [63:0] A,
    input [63:0] B,
    output [63:0] out
);
    genvar i;
    
    generate
        for (i = 0; i < 64; i = i + 1) begin
            and_gate and1(
                .Y(out[i]),
                .A(A[i]),
                .B(B[i])
            );
        end
    endgenerate

endmodule
module adder(output S, output Cout, input A, input B, input Cin, input M);
    wire t1, t2, t3;
    wire B1;
    xor x0(B1, B, M);
    xor x1(t1, A, B1);
    xor x2(S, t1, Cin);
    and a1(t2, A, B1);
    and a2(t3, t1, Cin);
    or o1(Cout, t2, t3);
endmodule

module add_64bit (
    input [63:0] A,
    input [63:0] B,
    input [63:0] Cin,
    input M,

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
            .Cin(Cin[0]),
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
endgenerate

endmodule

module alu (
    input [63:0] A,
    input [63:0] B,
    input [1:0] control,
    output [63:0] op1,
    output [63:0] op2,
    output [63:0] op3,
    output [63:0] op4,
    output [63:0] op,
    output Coutf,
    output sub_Coutf,
);

    wire [63:0] and_out_a, and_out_b, xor_out_a, xor_out_b, add_out_a, add_out_b, sub_out_a, sub_out_b, sub_carry;
    wire n0, n1;
    not N0(n0, control[0]);
    not N1(n1, control[1]);
    wire d0;
    and X0(d0, n0, n1);
    wire d1;
    and X1(d1, control[0], n1);
    wire d2;
    and X2(d2, control[1], n0);
    wire d3;
    and X3(d3, control[1], control[0]);
    and_64bit and0 (.A(A), .B(B), .out(and_out_a));
    xor_64bit xor0 (.A(A), .B(B), .out(xor_out_a));
    add_64bit add0 (.A(A), .B(B), .Cin({64{control[0]}}), .M(1'b0), .Cout(add_out_b), .S(add_out_a));
    add_64bit sub0 (.A(A), .B(B), .Cin({64{control[1]}}), .M(1'b1), .Cout(sub_carry), .S(sub_out_a));
    genvar i;
    wire[63:0] and2;
    wire[63:0] and3;
    wire[63:0] and4;
    wire[63:0] and5;
    generate
        for(i = 0; i < 64; i = i + 1) begin
            and a2(and2[i], d0, and_out_a[i]);
            and a3(and3[i], d1, xor_out_a[i]);
            and a4(and4[i], d2, add_out_a[i]);
            and a5(and5[i], d3, sub_out_a[i]);
        end
    endgenerate
    assign op1 = and2;
    assign op2 = and3;
    assign op3 = and4;
    assign op4 = and5;
    wire [63:0] o1, o2;
    genvar j;
    generate
        for (j = 0; j < 64; j = j + 1) begin
            or (o1[j], op1[j], op2[j]);
            or (o2[j], op3[j], op4[j]);
            or (op[j], o1[j], o2[j]);
        end
    endgenerate
    assign Coutf = add_out_b[63];
    assign sub_Coutf = sub_carry[63];
endmodule
