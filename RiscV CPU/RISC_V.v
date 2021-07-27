module RiscV_group2(RESET,CLK);

input CLK,RESET;

//stage 1 wires
wire [127:0] mem_Readdata;
wire [31:0]  nextPC,jump_branch_pc,pcmux_out,PC,PCAdder_out,readInstruction;
wire [27:0]  mem_Address;
wire         busyWait,busywait,mem_BusyWait,hit,mem_Read;

//stage 2 wires

wire        mux1_select,mux3_select,mux5_select,memRead,memWrite,branch,jump,writeEnable,REG_WRITE,Insthit;
wire [1:0]  mux4_select;
wire [2:0]  mux2_select;
wire [4:0]  AlUop;
wire [31:0] OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS,B_imm,J_imm,S_imm,U_imm,I_imm,mux2_out;

//stage 3 wires

wire       zero_signal,sign_bit_signal,sltu_bit_signal
wire[31:0] DATA1_in,DATA2_in,Alu_RESULT

//module instantiation


/* 
    -----
     stage 1 (instruction fetching stage modules)
    -----
*/
multiplexer_type1       RiscV_pcmux(nextPC,jump_branch_pc,pcmux_out);
ProgrameCounter         RiscV_PC(CLK,RESET,nextPC,PC,busyWait);
adder_type2             RiscV_PCAdder(PC,PCAdder_out);
instructionCache        RiscV_instrCache(CLK,RESET,PC,readInstruction,busywait,mem_Read,mem_Address,mem_Readdata,mem_BusyWait,hit);
Instruction_memory      RiscV_instrmemory(CLK,mem_Read,mem_Address,mem_Readdata,mem_BusyWait);

/* 
    -----
     Pipeline register 1
    -----
*/
//!need to resolve when discussion




/* 
    -----
     stage 2 (instruction decode & regfile access stage modules)
    -----
*/
controlUnit              RiscV_controlUnit("Instruction",mux1_select,mux2_select,mux3_select,mux4_select,mux5_select,memRead,memWrite,branch,jump,writeEnable,AlUop);
reg_file                 RiscV_regfile(CLK,RESET,"IN",OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS,REG_WRITE,Insthit);
Wire_module              RiscV_wireExtentions("Instruction",B_imm,J_imm,S_imm,U_imm,I_imm);
multiplexer_type2        RiscV_mux2(B_imm,S_imm,I_imm,U_imm,J_imm,mux2_out,"mux2_select");

/* 
    -----
     Pipeline register 2
    -----
*/
//!need to resolve when discussion

/* 
    -----
     stage 3 (Alu operations stage)
    -----
*/
multiplexer_type1        RiscV_mux1("IN1,IN2",DATA1_in,"mux1_select");
multiplexer_type1        RiscV_mux5("IN1,IN2",DATA2_in,"mux5_select");
alu                      RiscV_alu(DATA1_in,DATA2_in,Alu_RESULT,"SELECT",zero_signal,sign_bit_signal,sltu_bit_signal);
multiplexer_type3

endmodule