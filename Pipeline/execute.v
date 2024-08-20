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
    input clk,
    // Inputs
    input [2:0] E_stat,
    input [3:0] E_icode,
    input [3:0] E_ifun, 
    input signed [63:0] E_valC,
    input signed [63:0] E_valA, 
    input signed [63:0] E_valB,
    input signed [3:0] E_dstE, 
    input [3:0] E_dstM,
    input [2:0] W_stat,
    input [2:0] m_stat,
    // Outputs
    output reg[2:0] e_stat,
    output reg[3:0] e_icode,
    output reg e_Cnd,
    output reg signed [63:0] e_valE,
    output reg[63:0] e_valA,
    output reg[3:0] e_dstE,
    output reg[3:0] e_dstM,
    output wire zeroflag,
    output wire signflag,
    output wire overflow
);

always @(*) begin
    e_stat <= E_stat;
    e_icode <= E_icode;
    e_dstM <= E_dstM;
    e_valA <= E_valA;
    e_dstM <= E_dstM;
end
reg [1:0] control;
reg signed [63:0] in1;
reg signed [63:0] in2;
wire signed [63:0] out;
wire [63:0] op1, op2, op3, op4;
wire cout, sub_Coutf;


// ALU instantiation
alu ALU(in1, in2, control, op1, op2, op3, op4, out, cout, sub_Coutf, zeroflag, signflag, overflow);

always @(*) begin
    case (E_icode)
        // irmovq V, rB
        4'b0011: begin 
            e_valE = 0 + E_valC;
            in1 = E_valC;
            in2 = 64'd0;
            control = 2'b00;
        end

        // rmmovq rA, D(rB)
        4'b0100: begin 
            e_valE = E_valB + E_valC;
            in1 = E_valC;
            in2 = E_valB;
            control = 2'b00;
        end

        // cmovXX rA, rB
        4'b0010: begin    
            e_Cnd = 0;   
            case(E_ifun)
                // normal cmove
                4'b0000: begin 
                    e_Cnd = 1; // unconditional move instruction
                end
                // cmovle
                4'b0001: begin     
                    if((signflag^overflow)|zeroflag)
                        e_Cnd = 1;
                end
                // cmovl
                4'b0010: begin 
                    if(signflag^overflow)
                        e_Cnd = 1;
                end
                // cmove
                4'b0011: begin 
                    if(zeroflag)
                        e_Cnd = 1;
                end
                // cmovne
                4'b0100: begin 
                    if(!zeroflag)
                        e_Cnd = 1;
                end
                // cmovge
                4'b0101: begin   
                    if(!(signflag^overflow))
                        e_Cnd = 1;
                end
                // cmovg
                4'b0110: begin 
                    if(!(signflag^overflow) && !zeroflag)
                        e_Cnd = 1;
                end
            endcase
            in1 = E_valA;
            in2 = 64'd0;
            control = 2'b00; 
            e_valE = E_valA + 0;
        end

        // mrmovq D(rB), rA
        4'b0101: begin 
            e_valE = E_valB + E_valC;
            in1 = E_valC;
            in2 = E_valB;
            control = 2'b00;
        end

        // Opq rA, rB
        4'b0110: begin
            in1 = E_valB;
            in2 = E_valA;
            control = E_ifun[1:0];
        end
        // jXX Dest
        4'b0111: begin
            e_Cnd = 0;
            case(E_ifun)
                // jmp
                4'b0000: begin
                    e_Cnd = 1; 
                end
                // jle
                4'b0001: begin 
                    if((signflag^overflow)|zeroflag)
                        e_Cnd = 1;
                end
                // jl
                4'b0010: begin 
                    if(signflag^overflow)
                        e_Cnd = 1;
                end
                // je
                4'b0011: begin 
                    if(zeroflag)
                        e_Cnd = 1;
                end
                // jne
                4'b0100: begin 
                    if(!zeroflag)
                        e_Cnd = 1;
                end
                // jge
                4'b0101: begin 
                    if(!(signflag^overflow))
                        e_Cnd = 1;
                end
                // jg
                4'b0110: begin 
                    if(!(signflag^overflow) && !zeroflag)
                        e_Cnd = 1;
                end
            endcase
        end 

        // call Dest
        4'b1000: begin 
            e_valE = E_valB - 8;
            in1 = -64'd8;
            in2 = E_valB;
            control = 2'b00; // to decrement the stack pointer by 8 on call
        end

        // ret
        4'b1001: begin 
            e_valE = E_valB + 8;
            in1 = 64'd8;
            in2 = E_valB;
            control = 2'b00; // to increment the stack pointer by 8 on ret
        end

        // pushq rA
        4'b1010: begin 
            e_valE = E_valB - 8;
            in1 = -64'd8;
            in2 = E_valB;
            control = 2'b00; // to decrement the stack pointer by 8 on pushq
        end

        // popq rA
        4'b1011: begin 
            e_valE = E_valB + 8;
            in1 = 64'd8;
            in2 = E_valB;
            control = 2'b00; // to increment the stack pointer by 8 on popq
        end
    endcase
end
always @(*) begin
    if (e_icode == 2 || e_Cnd == 0) begin
        e_dstE = 15;
    end else begin
        e_dstE = E_dstE;
    end
end

endmodule
