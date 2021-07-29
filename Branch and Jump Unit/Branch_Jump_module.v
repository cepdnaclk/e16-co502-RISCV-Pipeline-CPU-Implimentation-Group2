module Branch_jump_module (
    PC,
    Branch_imm,
    Alu_Jump_imm,
    func_3,
    zero_signal,
    sign_bit_signal,
    sltu_bit_signal,
    Branch_jump_PC_OUT,
    branch_jump_mux_signal
);

input [31:0] PC,Branch_imm,Alu_Jump_imm;
input [2:0] func_3;
input branch_signal,jump_signal,zero_signal,sign_bit_signal,sltu_bit_signal;

output branch_jump_mux_signal;
output reg [31:0] Branch_jump_PC_OUT;

wire beq,bge,bne,blt,bltu,bgeu;

assign beq= (~func_3[2]) & (~func_3[1]) &  (~func_3[0]) & zero_signal;
assign bge= (func_3[2]) & (~func_3[1]) &  (func_3[0]) & (~sign_bit_signal);
assign bne= (~func_3[2]) & (~func_3[1]) &  (func_3[0]) & (~zero_signal);
assign blt= (func_3[2]) & (~func_3[1]) &  (~func_3[0]) & (~zero_signal) & sign_bit_signal;
assign bltu= (func_3[2]) & (func_3[1]) &  (~func_3[0]) & (~zero_signal) & sltu_bit_signal;
assign bgeu= (func_3[2]) & (func_3[1]) &  (func_3[0]) & (~sltu_bit_signal);

//possible issue here, what happens if the instruction is a beq but its valid for bge??
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