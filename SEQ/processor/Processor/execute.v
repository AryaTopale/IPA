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
    output zeroflag,
    output signflag,
    output overflow
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
    assign zeroflag=(op==0);
    assign signflag=(op[63]==1);
    assign overflow=(A>0&&B>0&&op<0)||(A<0&&B<0&&op>0);
endmodule

module execute(
    clk, 
    icode, ifun, 
    valA, valB, valC, valE, 
    cnd, 
    zeroflag, signflag, overflow
    );

input clk;
input [3:0] icode, ifun;
input [63:0] valA, valB, valC;
output reg [63:0] valE;
output reg cnd;
output wire zeroflag, signflag, overflow;
reg [1:0] control;
reg signed [63:0] in_1;
reg signed [63:0] in_2;
wire signed [63:0] out;
wire[63:0] op1,op2,op3,op4;
wire cout,sub_Coutf;
alu ALU(in_1,in_2,control,op1,op2,op3,op4,out,cout,sub_Coutf,zeroflag,signflag,overflow);
always @(*) begin
    cnd=0;
    if (icode == 4'b0011) begin // irmovq
        // valE = 0 + valC
        in_1 = valC;
        in_2 = 64'd0;
        control = 0;
    end
    else if (icode == 4'b0100||icode ==4'b0101) begin // rmmovq mrmovq
        // valE = valB + valC
        in_1 = valC;
        in_2 = valB;
        control = 0;
    end
    else if (icode == 4'b0010) begin // cmovXX
        cnd = 0;
        if (ifun == 4'b0000) begin // normal cmove
            cnd = 1; // unconditional move instruction
        end
        else if (ifun == 4'b0001) begin // cmovle
            if ((signflag^overflow)|zeroflag)
                cnd = 1;
        end
        else if (ifun == 4'b0010) begin // cmovl
            if (signflag^overflow)
                cnd = 1;
        end
        else if (ifun == 4'b0011) begin // cmove
            if (zeroflag)
                cnd = 1;
        end
        else if (ifun == 4'b0100) begin // cmovne
            if (!zeroflag)
                cnd = 1;
        end
        else if (ifun == 4'b0101) begin // cmovge
            if (!(signflag^overflow))
                cnd = 1;
        end
        else if (ifun == 4'b0110) begin // cmovg
            if (!(signflag^overflow) && !zeroflag)
                cnd = 1;
        end
        in_1 = valA;
        in_2 = 64'd0;
        control = 0; // valE = valA + 0
    end
    else if (icode == 4'b0110) begin // Opq
        in_1 = valB;
        in_2 = valA;
        if(ifun==0)begin
            control=0;
        end
        if(ifun==1)begin
            control=1;
        end
        if(ifun==2)begin
            control=2;
        end
        if(ifun==3)begin
            control=3;
        end
    end
    else if (icode == 4'b0111) begin // jXX
        cnd = 0;
        if (ifun == 4'b0000) begin // jmp
            cnd = 1; // unconditional jump
        end
        else if (ifun == 4'b0001) begin // jle
            if ((signflag^overflow)|zeroflag)
                cnd = 1;
        end
        else if (ifun == 4'b0010) begin // jl
            if (signflag^overflow)
                cnd = 1;
        end
        else if (ifun == 4'b0011) begin // je
            if (zeroflag)
                cnd = 1;
        end
        else if (ifun == 4'b0100) begin // jne
            if (!zeroflag)
                cnd = 1;
        end
        else if (ifun == 4'b0101) begin // jge
            if (!(signflag^overflow))
                cnd = 1;
        end
        else if (ifun == 4'b0110) begin // jg
            if (!(signflag^overflow) && !zeroflag)
                cnd = 1;
        end
    end
    else if (icode == 4'b1000) begin // call
        // valE = valB - 8
        in_1 = -64'd8;
        in_2 = valB;
        control =0; // to decrement the stack pointer by 8 on call
    end
    else if (icode == 4'b1001) begin // ret
        // valE = valB + 8
        in_1 = 64'd8;
        in_2 = valB;
        control =0; // to increment the stack pointer by 8 on ret
    end
    else if (icode == 4'b1010) begin // pushq
        // valE = valB - 8
        in_1 = -64'd8;
        in_2 = valB;
        control = 0; // to decrement the stack pointer by 8 on pushq
    end
    else if (icode == 4'b1011) begin // popq
        // valE = valB + 8
        in_1 = 64'd8;
        in_2 = valB;
        control = 0; // to increment the stack pointer by 8 on popq
    end
    valE = out;
end
endmodule