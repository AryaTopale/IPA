module write_back(
    input clk,
    input [3:0] icode,
    input [3:0] rA,
    input [3:0] rB,
    input [63:0] valE,
    input [63:0] valM
);

reg [63:0] reg_file [0:14]; 

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
