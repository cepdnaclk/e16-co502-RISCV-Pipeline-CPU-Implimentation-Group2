// Pipeline register between instruction fetching and register read stages

module PipelineReg_1(clock,reset,nextPC,PC,Instruction,Insthit,busywait,
                     nextPC_out,PC_out,Instr_out,Insthit_out);

input [31:0] nextPC,PC,Instruction;
input clock,reset,Insthit,busywait;   //  instruction hit signal to check wether the fetched instruction is a valid one and busywait to 
                          //  the register to hold the value.

output reg [31:0] nextPC_out,PC_out,Instr_out;
output reg Insthit_out; 

always @(posedge clock ) begin
    if (!busywait)begin
        nextPC_out  <= nextPC;
        PC_out      <= PC;
        Instr_out   <= Instruction;
        Insthit_out <= Insthit;
    end
end

always @(reset)begin
    if(reset == 1'b1) begin 
        Instr_out   <= 0;
        Insthit_out <= 0;
    end
end

endmodule




// Pipeline register between register read stage & ALU operation stage

module PipelineReg_2(reset,clock,busywait,
        //from instruction
        des_register,Funct3,
        
        //control signals
        mux_5_sel,writeEnable,mux_3_sel,memWrite,memRead,ALUop,mux_4_sel,branch,jump,mux_1_sel,
        
        //PC
        PC,nextPC,
        
        //regfile outputs
        data1,data2,
        
        //immidiate value
        mux_2_out,
        
        //inst hit signal
        Insthit,
        
        //outputs
        des_register_out,Funct3_out,mux_5_sel_out,writeEnable_out,mux_3_sel_out,memWrite_out,memRead_out,ALUop_out,mux_4_sel_out,branch_out,jump_out,mux_1_sel_out,
        PC_out,nextPC_out,data1_out,data2_out,mux_2_out_out,Insthit_out);

input [31:0] nextPC,PC,data1,data2;
input [4:0]  ALUop,des_register;
input [2:0]  mux_2_out,Funct3;
input [1:0]  mux_4_sel;
input        reset,clock,busywait,mux_5_sel,writeEnable,mux_3_sel,memWrite,memRead,branch,jump,mux_1_sel,Insthit;

output reg [31:0] nextPC_out,PC_out,data1_out,data2_out;
output reg [4:0]  ALUop_out,des_register_out;
output reg [2:0]  mux_2_out_out,Funct3_out;
output reg [1:0]  mux_4_sel_out;
output reg        mux_5_sel_out,writeEnable_out,mux_3_sel_out,memWrite_out,memRead_out,branch_out,jump_out,mux_1_sel_out,Insthit_out;

always @(posedge clock ) begin
    if (!busywait)begin
        nextPC_out <= nextPC;
        PC_out     <= PC;
        data1_out  <= data1;
        data2_out  <= data2;
        ALUop_out  <= ALUop;
        des_register_out    <= des_register;
        mux_2_out_out       <= mux_2_out;
        Funct3_out          <= Funct3;
        mux_4_sel_out       <= mux_4_sel;
        mux_5_sel_out       <= mux_5_sel;
        writeEnable_out     <= writeEnable;
        mux_3_sel_out       <= mux_3_sel;
        memWrite_out        <= memWrite;
        memRead_out         <= memRead;
        branch_out          <= branch;
        jump_out            <= jump;
        mux_1_sel_out       <= mux_1_sel;
        Insthit_out         <= Insthit;
    end
end

//waht shoul happen when reset????
always @(reset)begin
    if(reset == 1'b1) begin 
    end
end

endmodule



// Pipeline register between ALU operation stage & data memory stage

module PipelineReg_3(reset,clock,busywait,
        //from instruction
        des_register,Funct3,
        
        //control signals
        writeEnable,mux_3_sel,memWrite,memRead,
        
        //Alu out
        ALUout,
        
        //regfile outputs
        data2,
        
        //inst hit signal
        Insthit,
        
        //outputs
        des_register_out,Funct3_out,writeEnable_out,mux_3_sel_out,memWrite_out,memRead_out,ALUout_out,data2_out,Insthit_out);

input [31:0] data2,ALUout;
input [4:0]  des_register;
input [2:0]  Funct3;
input        reset,clock,busywait,writeEnable,mux_3_sel,memWrite,memRead,Insthit;

output reg [31:0] data2_out,ALUout_out;
output reg [4:0]  des_register_out;
output reg [2:0]  Funct3_out;
output reg        writeEnable_out,mux_3_sel_out,memWrite_out,memRead_out,Insthit_out;

always @(posedge clock ) begin
    if (!busywait)begin
        data2_out           <= data2;
        ALUout_out          <= ALUout;
        des_register_out    <= des_register;
        Funct3_out          <= Funct3;
        writeEnable_out     <= writeEnable;
        mux_3_sel_out       <= mux_3_sel;
        memWrite_out        <= memWrite;
        memRead_out         <= memRead;
        Insthit_out         <= Insthit;
    end
end

//what should happen when reset????
always @(reset)begin
    if(reset == 1'b1) begin
    end
end

endmodule

// Pipeline register between data memory stage & writeback stage

module PipelineReg_4(reset,clock,
        //from instruction
        des_register,
        
        //control signals
        writeEnable,mux_3_sel,
        
        //Alu out
        ALUout,
        
        //data mem outputs
        dmem_out,
        
        //inst hit signal
        Insthit,
        
        //outputs
        des_register_out,writeEnable_out,mux_3_sel_out,ALUout_out,dmem_out_out,Insthit_out);

input [31:0] dmem_out,ALUout;
input [4:0]  des_register;
input        reset,clock,writeEnable,mux_3_sel,Insthit;

output reg [31:0] dmem_out_out,ALUout_out;
output reg [4:0]  des_register_out;
output reg        writeEnable_out,mux_3_sel_out,Insthit_out;

always @(posedge clock ) begin
        dmem_out_out        <= dmem_out;
        ALUout_out          <= ALUout;
        des_register_out    <= des_register;
        writeEnable_out     <= writeEnable;
        mux_3_sel_out       <= mux_3_sel;
        Insthit_out         <= Insthit;
end

//what should happen when reset????
always @(reset)begin
    if(reset == 1'b1) begin 
    end
end

endmodule