module decode(
    input clk,
    input [3:0] icode,
    input [3:0] rA,
    input [3:0] rB,
    input [63:0] valE,valM,
    output reg [63:0] valA,
    output reg [63:0] valB,
    input [63:0] rax,
    input [63:0] rcx,
    input  [63:0] rdx,
    input  [63:0] rbx,
    input  [63:0] rsp,
    input  [63:0] rbp,
    input  [63:0] rsi,
    input [63:0] rdi,
    input [63:0] r8,
    input  [63:0] r9,
    input  [63:0] r10,
    input [63:0] r11,
    input  [63:0] r12,
    input  [63:0] r13,
    input [63:0] r14
);

reg [63:0] reg_file [0:14];

always @(*) begin
    reg_file[0]=rax;
    reg_file[1]=rcx;
    reg_file[2]=rdx;
    reg_file[3]=rbx;
    reg_file[4]=rsp;
    reg_file[5]=rbp;
    reg_file[6]=rsi;
    reg_file[7]=rdi;
    reg_file[8]=r8;
    reg_file[9]=r9;
    reg_file[10]=r10;
    reg_file[11]=r11;
    reg_file[12]=r12;
    reg_file[13]=r13;
    reg_file[14]=r14;
    case (icode)
        4'b0000:begin
        end
        4'b0001:begin
        end
        4'b0010: begin // cmovxx
            valA = reg_file[rA];
            //valB = 0;
        end
        4'b0011: begin // irmovq
           //  valB = reg_file[rB];
        end
        4'b0100: begin // rmmovq       
            valA = reg_file[rA];
            valB = reg_file[rB];
        end
        4'b0101: begin // mrmovq
            // valA = reg_file[rA];
            valB = reg_file[rB];
        end
        4'b0110: begin // Opq
            valA = reg_file[rA];
            valB = reg_file[rB];
        end
        4'b0111: begin
        end
        4'b1000: begin // call
            valB = reg_file[4];
        end
        4'b1001: begin // ret
            valA = reg_file[4];
            valB = reg_file[4];
        end
        4'b1010: begin // pushq
            valA = reg_file[rA];
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