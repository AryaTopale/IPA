// `include "fetch.v"
// `include "pc_update.v"
module fetch_tb;

  reg clk;
  reg [63:0] PC;
  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB; 
  wire [63:0] valC;
  wire [63:0] valP;
  wire imem_error, halt,invalid_instr;
  fetch dut(.clk(clk),.PC(PC),.icode(icode),.ifun(ifun),.rA(rA),
              .rB(rB),.valC(valC),.valP(valP), .imem_error(imem_error), .halt(halt), .invalid_instr(invalid_instr));
  
  initial begin 
    clk=0;
    PC=64'd0;
    #15 clk=~clk;PC=64'd3;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    #15 clk=~clk;PC=valP;
    #15 clk=~clk;
    
  end 
  
  initial 
		$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d, halt=%d\n",clk,PC,icode,ifun,rA,rB,valC,valP,halt);
endmodule