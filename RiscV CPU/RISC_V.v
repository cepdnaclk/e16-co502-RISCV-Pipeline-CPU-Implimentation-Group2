
`include "../Adders/DedicatedAdders.v"
`include "../ALU module/ALU.v"
`include "../Branch and Jump Unit/Branch_jump_module.v"
`include "../CONTROL UNIT module/controlUnit.v"
`include "../Data Refining module/Data_ref_module.v"
`include "../Extension Wire module/Wire_module.v"
`include "../Instruction Fetch module/InstructionFetchModule.v"
`include "../Multiplexers/Multiplexers.v"
`include "../Pipeline registers/PiplineRegs.v"
`include "../REG FILE module/REGFILE.v"

module RiscV_CPU(CLK, RESET, PC, Instruction,cache_memRead,cache_memWrite,ALUout_out_pipe3,to_data_memory,from_data_mem,instrCache_mem_busywait,cache_mem_busywait,Insthit,Insthit_out_pipe3);

input CLK,RESET,instrCache_mem_busywait,cache_mem_busywait,Insthit;
input[31:0] from_data_mem;  
input [31:0] Instruction;                     //this go directly to pipeline reg 1
output [31:0] PC,to_data_memory;
output cache_memRead,cache_memWrite,Insthit_out_pipe3;         // this should be from output of pipeline reg 3
output [31:0] ALUout_out_pipe3;                       //this should be output of pipeline reg 3

//stage 1 wires
wire [127:0] mem_Readdata;
wire [31:0]  nextPC,jump_branch_pc,pcmux_out,PCAdder_out,readInstruction;
wire [27:0]  mem_Address;
wire         busyWait,mem_BusyWait,hit,mem_Read,pcmux_select;

//pipeline reg 1 wires
wire [31:0] nextPC_out_pipe1,PC_out_pipe1,Instr_out_pipe1;
wire Insthit_out_pipe1;

//stage 2 wires

wire        mux1_select,mux3_select,mux5_select,memRead,memWrite,branch,jump,writeEnable,REG_WRITE,Insthit;
wire [1:0]  mux4_select;
wire [2:0]  mux2_select;
wire [4:0]  ALUop;
wire [31:0] OUT1,OUT2,B_imm,J_imm,S_imm,U_imm,I_imm,mux2_out;

//pipeine reg 2 wires
wire mux_5_sel_out_pipe2,writeEnable_out_pipe2,mux_3_sel_out_pipe2,memWrite_out_pipe2,memRead_out_pipe2,branch_out_pipe2,jump_out_pipe2,mux_1_sel_out_pipe2,Insthit_out_pipe2;
wire [2:0] Funct3_out_pipe2;
wire [1:0] mux_4_sel_out_pipe2;
wire [4:0] ALUop_out_pipe2,des_register_out_pipe2;
wire [31:0] PC_out_pipe2,nextPC_out_pipe2,data1_out_pipe2,data2_out_pipe2,mux_2_out_out_pipe2;

//stage 3 wires

wire       zero_signal,sign_bit_signal,sltu_bit_signal;
wire[31:0] DATA1_in,DATA2_in,Alu_RESULT,mux_4_out;

//pipeline reg 3 wires
wire writeEnable_out_pipe3,mux_3_sel_out_pipe3,Insthit_out_pipe3;
wire [2:0] Funct3_out_pipe3;
wire [4:0] des_register_out_pipe3;
wire [31:0] ALUout_out,data2_out_pipe3;

//stage 4 wires
wire[31:0] data_ref_out; //input output from cpu

//pipeline reg 4 wires
wire Insthit_out_pipe4,writeEnable_out_pipe4,mux_3_sel_out_pipe4;
wire [4:0] des_register_out_pipe4;
wire [31:0] ALUout_out_pipe4,dmem_out_out_pipe4;

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


InstructionfetchModule     RiscV_instrFetch(CLK,RESET,instruction_mem_busywait,data_mem_busywait,pcmux_select,PC,nextPC,jump_branch_pc);

// instructionCache        RiscV_instrCache(CLK,RESET,PC,readInstruction,busywait,mem_Read,mem_Address,mem_Readdata,mem_BusyWait,hit);
// Instruction_memory      RiscV_instrmemory(CLK,mem_Read,mem_Address,mem_Readdata,mem_BusyWait);

/* 
    -----
     Pipeline register 1
    -----
*/
//!need to resolve when discussion
PipelineReg_1             RiscV_pipelineReg1(CLK,RESET,nextPC,PC,Instruction,Insthit,cache_mem_busywait,nextPC_out_pipe1,PC_out_pipe1,Instr_out_pipe1,Insthit_out_pipe1);



/* 
    -----
     stage 2 (instruction decode & regfile access stage modules)
    -----
*/
controlUnit              RiscV_controlUnit(Instr_out_pipe1,mux1_select,mux2_select,mux3_select,mux4_select,mux5_select,memRead,memWrite,branch,jump,writeEnable,ALUop);
reg_file                 RiscV_regfile(CLK,RESET,reg_writedata,OUT1,OUT2,des_register_out_pipe4,Instr_out_pipe1[19:15],Instr_out_pipe1[24:20],writeEnable_out_pipe4,Insthit_out_pipe4);
Wire_module              RiscV_wireExtentions(Instr_out_pipe1,B_imm,J_imm,S_imm,U_imm,I_imm);
multiplexer_type2        RiscV_mux2(B_imm,S_imm,I_imm,U_imm,J_imm,mux2_out,mux2_select);

/* 
    -----
     Pipeline register 2
    -----
*/

// reg [4:0] des_register;
// reg [2:0] Funct3;
// assign  des_register= Instr_out_pipe1[11:7];
// assign  Funct3 = Instr_out_pipe1[14:12];

//!need to resolve when discussion
PipelineReg_2            RiscV_pipelineReg2(CLK,RESET,cache_mem_busywait,
        //from instruction
        Instr_out_pipe1[11:7],Instr_out_pipe1[14:12],
        
        //control signals
        mux5_select,writeEnable,mux3_select,memWrite,memRead,ALUop,mux4_select,branch,jump,mux1_select,
        
        //PC
        PC_out_pipe1,nextPC_out_pipe1,
        
        //regfile outputs
        OUT1,OUT2,
        
        //immidiate value
        mux2_out,
        
        //inst hit signal
        Insthit_out_pipe1,
        
        //outputs
        des_register_out_pipe2,Funct3_out_pipe2,mux_5_sel_out_pipe2,writeEnable_out_pipe2,mux_3_sel_out_pipe2,memWrite_out_pipe2,memRead_out_pipe2,ALUop_out_pipe2,mux_4_sel_out_pipe2,branch_out_pipe2,jump_out_pipe2,mux_1_sel_out_pipe2,
        PC_out_pipe2,nextPC_out_pipe2,data1_out_pipe2,data2_out_pipe2,mux_2_out_out_pipe2,Insthit_out_pipe2);


/* 
    -----
     stage 3 (Alu operations stage)
    -----
*/
multiplexer_type1        RiscV_mux1(data1_out_pipe2,PC_out_pipe2,DATA1_in,mux_1_sel_out_pipe2);
multiplexer_type1        RiscV_mux5(mux_2_out_out_pipe2,data2_out_pipe2,DATA2_in,mux_5_sel_out_pipe2);
alu                      RiscV_alu(DATA1_in,DATA2_in,Alu_RESULT,ALUop_out_pipe2,zero_signal,sign_bit_signal,sltu_bit_signal);
multiplexer_type3        RiscV_mux4(mux_2_out_out_pipe2,Alu_RESULT,nextPC_out_pipe2,mux_4_out,mux_4_sel_out_pipe2);
Branch_jump_module       RiscV_BJmodule(PC_out_pipe2,mux_2_out_out_pipe2,Alu_RESULT,Funct3_out_pipe2,branch_out_pipe2,jump_out_pipe2,zero_signal,sign_bit_signal,sltu_bit_signal,jump_branch_pc,pcmux_select);

/* 
    -----
     Pipeline register 3
    -----
*/
PipelineReg_3            RiscV_pipelineReg3(CLK,RESET,cache_mem_busywait,
        //from instruction
        des_register_out_pipe2,Funct3_out_pipe2,
        
        //control signals
        writeEnable_out_pipe2,mux_3_sel_out_pipe2,memWrite_out_pipe2,memRead_out_pipe2,
        
        //mux_4(alu result)
        mux_4_out,
        
        //regfile outputs
        data2_out_pipe2,
        
        //inst hit signal
        Insthit_out_pipe2,
        
        //outputs
        des_register_out_pipe3,Funct3_out_pipe3,writeEnable_out_pipe3,mux_3_sel_out_pipe3,cache_memWrite,cache_memRead,ALUout_out_pipe3,data2_out_pipe3,Insthit_out_pipe3);

/* 
    -----
     stage 4 (Data memory access stage)
    -----
*/
Data_ref_module          RiscV_dataRefModule(Funct3_out_pipe3,from_data_mem,data_ref_out,to_data_memory,data2_out_pipe3);

/* 
    -----
     Pipeline register 4
    -----
*/
PipelineReg_4            RiscV_pipelineReg4(CLK,RESET,
        //from instruction
        des_register_out_pipe3,
        
        //control signals
        writeEnable_out_pipe3,mux_3_sel_out_pipe3,
        
        //Alu out
        ALUout_out_pipe3,
        
        //data mem outputs
        data_ref_out,
        
        //inst hit signal
        Insthit_out_pipe3,
        
        //outputs
        des_register_out_pipe4,writeEnable_out_pipe4,mux_3_sel_out_pipe4,ALUout_out_pipe4,dmem_out_out_pipe4,Insthit_out_pipe4);

/* 
    -----
     stage 5 (writeback stage)
    -----
*/
multiplexer_type1       RiscV_mux3(ALUout_out_pipe4,dmem_out_out_pipe4,reg_writedata,mux_3_sel_out_pipe4);


endmodule