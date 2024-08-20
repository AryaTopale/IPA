module memory(
    input clk,

    // Inputs
    input [2:0] M_stat,
    input [3:0] M_icode,
    input [63:0] M_valE,
    input [63:0] M_valA,
    input [3:0] M_dstE,
    input [3:0] M_dstM,

    // Outputs
    output reg[2:0] m_stat,
    output reg[3:0] m_icode,
    output reg[63:0] m_valE,
    output reg[63:0] m_valM,
    output reg[3:0] m_dstE,
    output reg[3:0] m_dstM
);

    // Initiating data memory
    reg [63:0] memory[0:4095];
    integer i;

    initial begin
        for (i = 0; i < 4096; i = i+1) begin
            memory[i] <= 0;
        end
    end

    // Setting up direct transfer wires
    always @(*) begin
    
        m_icode <= M_icode;
        m_valE <= M_valE;
        m_dstE <= M_dstE;
        m_dstM <= M_dstM;
    end

    // write block
    reg write;

    always @(*) begin
        if (m_icode == 4 || m_icode == 8 || m_icode == 10) begin
            write <= 1;
        end
        else begin
            write <= 0;
        end
    end
    reg read;
    always @(*) begin
        if (m_icode == 5 || m_icode == 9 || m_icode == 11) begin
            read <= 1;
        end
        else begin
            read <= 0;
        end
    end
    reg [63:0] dest;
    always @(*) begin
        if (m_icode == 4 || m_icode == 5 || m_icode == 8 || m_icode == 10) begin
            dest <= m_valE;
        end
        else if (m_icode == 9 || m_icode == 11) begin
            dest <= M_valA;
        end
        else begin
            dest <= 4095; 
        end
    end
    reg dmem_error;
    always @(*) begin

        if (dest < 4096 && dest >= 0) begin
            dmem_error <= 0;
        end
        else begin
            dmem_error <= 1;
        end
    end
    always @(posedge clk) begin

        if (dmem_error == 0 && write == 1) begin
            memory[dest] <= M_valA;
        end
    end
    always @(*) begin
        if (dmem_error == 0 && read == 1) begin
            m_valM <= memory[dest];
        end
        else begin
            m_valM <= 0;
        end
    end
    always @(*) begin        
        if (dmem_error == 1) begin
            m_stat <= 3;
        end 
        else begin
            m_stat <= M_stat;
        end
    end

endmodule