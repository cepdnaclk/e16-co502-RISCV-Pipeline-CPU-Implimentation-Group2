module RiscV_CPU(CLK, RESET, PC, Instruction,cache_memRead,cache_memWrite,Address,to_data_memory,from_data_mem,instrCache_mem_busywait,cache_mem_busywait);

input CLK,RESET,instrCache_mem_busywait,cache_mem_busywait;
input[31:0] from_data_mem;  
input [31:0] Instruction;                     //this go directly to pipeline reg 1
output [31:0] PC,to_data_memory;
output cache_memRead,cache_memWrite;         // this should be from output of pipeline reg 3
output [27:0] Address;                       //this should be output of pipeline reg 3

//stage 1 wires
wire [127:0] mem_Readdata;
wire [31:0]  nextPC,jump_branch_pc,pcmux_out,PCAdder_out,readInstruction;
wire [27:0]  mem_Address;
wire         busyWait,mem_BusyWait,hit,mem_Read,pcmux_select;

//stage 2 wires

wire        mux1_select,mux3_select,mux5_select,memRead,memWrite,branch,jump,writeEnable,REG_WRITE,Insthit;
wire [1:0]  mux4_select;
wire [2:0]  mux2_select;
wire [4:0]  AlUop;
wire [31:0] OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS,B_imm,J_imm,S_imm,U_imm,I_imm,mux2_out;

//stage 3 wires

wire       zero_signal,sign_bit_signal,sltu_bit_signal;
wire[31:0] DATA1_in,DATA2_in,Alu_RESULT;

//stage 4 wires
wire[31:0] data_ref_out; //input output from cpu

//stage 5 wires
wire[31:0] reg_writedata;


//module instantiation


/* 
    -----
     stage 1 (instruction fetching stage modules)
    -----
*/


// or(busyWait,instruction_mem_busywait,data_mem_busywait);
// multiplexer_type1       RiscV_pcmux(nextPC,jump_branch_pc,pcmux_out,pcmux_select);
// ProgrameCounter         RiscV_PC(CLK,RESET,pcmux_out,PC,busyWait);
// adder_type2             RiscV_PCAdder(PC,nextPC);


InstructionfetchModule  RiscV_instrFetch(CLK,RESET,instruction_mem_busywait,data_mem_busywait,pcmux_select,PC,nextPC,jump_branch_pc);

// instructionCache        RiscV_instrCache(CLK,RESET,PC,readInstruction,busywait,mem_Read,mem_Address,mem_Readdata,mem_BusyWait,hit);
// Instruction_memory      RiscV_instrmemory(CLK,mem_Read,mem_Address,mem_Readdata,mem_BusyWait);

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
reg_file                 RiscV_regfile(CLK,RESET,reg_writedata,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS,REG_WRITE,Insthit);
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
multiplexer_type3        RiscV_mux4("mux_2_out",Alu_RESULT,"nextPC","mux4_select");
Branch_jump_module       RiscV_BJmodule("PC,Branch_imm",Alu_RESULT,"func_3","branch_signal,jump_signal",zero_signal,sign_bit_signal,sltu_bit_signal,jump_branch_pc,pcmux_select);

/* 
    -----
     Pipeline register 3
    -----
*/


/* 
    -----
     stage 4 (Data memory access stage)
    -----
*/
Data_ref_module          RiscV_dataRefModule("func3",from_data_mem,data_ref_out,to_data_memory,"DATA2");

/* 
    -----
     Pipeline register 4
    -----
*/


/* 
    -----
     stage 5 (writeback stage)
    -----
*/
multiplexer_type1       RiscV_mux3("ALUout","datamem out",reg_writedata,"mux_3_select");


endmodule