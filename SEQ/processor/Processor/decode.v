module decode(
    input clk,
    input [3:0] icode,
    input [3:0] rA,
    input [3:0] rB,
    output reg [63:0] valA,
    output reg [63:0] valB,
    output reg [63:0] rax,
    output reg [63:0] rcx,
    output reg [63:0] rdx,
    output reg [63:0] rbx,
    output reg [63:0] rsp,
    output reg [63:0] rbp,
    output reg [63:0] rsi,
    output reg [63:0] rdi,
    output reg [63:0] r8,
    output reg [63:0] r9,
    output reg [63:0] r10,
    output reg [63:0] r11,
    output reg [63:0] r12,
    output reg [63:0] r13,
    output reg [63:0] r14
);

reg [63:0] reg_file [0:14];

initial begin
    reg_file[0] = 64'd111;       // rax
    reg_file[1] = 64'd222;       // rcx
    reg_file[2] = 64'd333;       // rdx
    reg_file[3] = 64'd444;       // rbx
    reg_file[4] = 64'd555;       // rsp
    reg_file[5] = 64'd666;       // rbp
    reg_file[6] = -64'sd777;     // rsi
    reg_file[7] = 64'd888;       // rdi
    reg_file[8] = 64'd999;       // r8
    reg_file[9] = -64'sd1111;    // r9
    reg_file[10] = 64'd2222;     // r10
    reg_file[11] = 64'd3333;     // r11
    reg_file[12] = 64'd4444;     // r12
    reg_file[13] = 64'd5555;     // r13
    reg_file[14] = 64'd6666;     // r14
end
always @(posedge clk) begin
    rax = reg_file[0];
    rcx = reg_file[1];
    rdx = reg_file[2];
    rbx = reg_file[3];
    rsp = reg_file[4];
    rbp = reg_file[5];
    rsi = reg_file[6];
    rdi = reg_file[7];
    r8 = reg_file[8];
    r9 = reg_file[9];
    r10 = reg_file[10];
    r11 = reg_file[11];
    r12 = reg_file[12];
    r13 = reg_file[13];
    r14 = reg_file[14];
end
always @(posedge clk) begin
    case (icode)
        4'b0010: begin // cmovxx
            valA = reg_file[rA];
            valB = 0;
        end
        4'b0011: begin // irmovq
            valB = reg_file[rB];
        end
        4'b0100: begin // rmmovq
            valA = reg_file[rA];
            valB = reg_file[rB];
        end
        4'b0101: begin // mrmovq
            valA = reg_file[rA];
            valB = reg_file[rB];
        end
        4'b0110: begin // Opq
            valA = reg_file[rA];
            valB = reg_file[rB];
        end
        4'b1000: begin // call
            valB = reg_file[4];
        end
        4'b1001: begin // ret
            valA = reg_file[4];
            valB = reg_file[4];
        end
        4'b1010: begin // pushq
            valA = reg_file[4];
            valB = reg_file[4];
        end
        4'b1011: begin // popq
            valA = reg_file[4];
            valB = reg_file[4];
        end
        default: begin
        end
    endcase
end

endmodule