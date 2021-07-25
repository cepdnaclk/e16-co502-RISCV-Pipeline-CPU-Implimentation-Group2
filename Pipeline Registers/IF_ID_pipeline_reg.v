module IF_ID_pipeline_req (
    PC_incremented_by_4,
    PC,Instruction,
    CLK,
    RESET,
    PC_reg_out,
    PC_incremented_by_4_reg_out,
    Instruction_reg_out
);

input [31:0] PC_incremented_by_4,PC,Instruction;
input CLK,RESET;
output reg [31:0] PC_reg_out,PC_incremented_by_4_reg_out,Instruction_reg_out;

// Set all the pipeline register values to zero on the Reset signal comes from the processor
always @(RESET) begin
    PC_reg_out<=0;
    PC_incremented_by_4_reg_out<=0;
    Instruction_reg_out<=0;
end

// write to privious stage values to the pipeline registers on the positive clock edge
always @(posedge CLK) begin
    PC_reg_out<=PC;
    PC_incremented_by_4_reg_out<=PC_incremented_by_4;
    Instruction_reg_out<=Instruction;
end
    
endmodule