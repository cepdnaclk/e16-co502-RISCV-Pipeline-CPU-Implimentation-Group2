module Branch_jump_module (
    PC,
    Branch_imm,
    Instruction,
    zero_signal,
    sign_bit_signal,
    sltu_bit_signal,
    Branch_jump_PC_OUT,
    branch_jump_mux_signal
);

input [31:0] PC,Branch_imm,Instruction,Alu_Jump_imm;
input branch_signal,jump_signal,zero_signal,sign_bit_signal,sltu_bit_signal;

output branch_jump_mux_signal;
output reg [31:0] Branch_jump_PC_OUT;

wire beq,bge,bne,blt,bltu,bgeu;

assign beq= (~Instruction[14]) & (~Instruction[13]) &  (~Instruction[12]) & zero_signal;
assign bge= (Instruction[14]) & (~Instruction[13]) &  (Instruction[12]) & (~sign_bit_signal);
assign bne= (~Instruction[14]) & (~Instruction[13]) &  (Instruction[12]) & (~zero_signal);
assign blt= (Instruction[14]) & (~Instruction[13]) &  (~Instruction[12]) & (~zero_signal) & sign_bit_signal;
assign bltu= (Instruction[14]) & (Instruction[13]) &  (~Instruction[12]) & (~zero_signal) & sltu_bit_signal;
assign bgeu= (Instruction[14]) & (Instruction[13]) &  (Instruction[12]) & (~sltu_bit_signal);

assign branch_jump_mux_signal=(branch_signal &(beq|bge|bne|blt|bltu|bgeu)) | (jump_signal);


always @(*) begin
    if (jump_signal==1'b1) begin
        Branch_jump_PC_OUT=Alu_Jump_imm;
    end
    else begin
        Branch_jump_PC_OUT=PC+Branch_imm;
    end
end
    
endmodule