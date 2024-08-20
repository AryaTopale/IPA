module write_back(
    input clk,
    input [3:0] icode,
    input [3:0] rA,
    input [3:0] rB,
    input [63:0] valE,
    input [63:0] valM,
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
    reg_file[0]=1;
    reg_file[1]=1;
    reg_file[2]=1;
    reg_file[3]=1;
    reg_file[4]=127;
    reg_file[5]=1;
    reg_file[6]=1;
    reg_file[7]=1;
    reg_file[8]=1;
    reg_file[9]=1;
    reg_file[10]=1;
    reg_file[11]=1;
    reg_file[12]=1;
    reg_file[13]=1;
    reg_file[14]=1;
end
always @(*)begin
    rax=reg_file[0];
    rcx=reg_file[1];
    rdx=reg_file[2];
    rbx=reg_file[3];
    rsp=reg_file[4];
    rbp=reg_file[5];
    rsi=reg_file[6];
    rdi=reg_file[7];
    r8=reg_file[8];
    r9=reg_file[9];
    r10=reg_file[10];
    r11=reg_file[11];
    r12=reg_file[12];
    r13=reg_file[13];
    r14=reg_file[14];
end
always @(posedge clk) begin
    case (icode)
        4'b0010: begin // cmovxx
            reg_file[rB] <= valE;
        end
        4'b0011: begin // irmovq
            reg_file[rB] <= valE;
        end
        4'b0101: begin // mrmovq
            reg_file[rA] <= valM;
        end
        4'b0110: begin // Opq
            reg_file[rB] <= valE;
        end
        4'b1000: begin // call for rsp
            reg_file[4] <= valE;
        end
        4'b1001: begin // ret for rsp
            reg_file[4] <= valE;
        end
        4'b1010: begin // pushq for rsp
            reg_file[4] <= valE;
        end
        4'b1011: begin // popq for rsp
            reg_file[rA] <= valM;
            reg_file[4] <= valE;
        end
        default: begin
        end
    endcase
end

endmodule