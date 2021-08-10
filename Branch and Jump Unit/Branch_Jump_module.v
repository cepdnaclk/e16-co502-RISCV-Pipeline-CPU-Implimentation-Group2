`timescale  1ns/100ps

module Branch_jump_module (
    RESET,
    PC,
    Branch_imm,
    Alu_Jump_imm,
    func_3,
    branch_signal,
    jump_signal,
    zero_signal,
    sign_bit_signal,
    sltu_bit_signal,
    Branch_jump_PC_OUT,
    branch_jump_mux_signal
);

input [31:0] PC,Branch_imm,Alu_Jump_imm;
input [2:0] func_3;
input RESET,branch_signal,jump_signal,zero_signal,sign_bit_signal,sltu_bit_signal;

output reg branch_jump_mux_signal;
output reg [31:0] Branch_jump_PC_OUT;

wire beq,bge,bne,blt,bltu,bgeu;

assign #1 beq= (~func_3[2]) & (~func_3[1]) &  (~func_3[0]) & zero_signal;
assign #1 bge= (func_3[2]) & (~func_3[1]) &  (func_3[0]) & (~sign_bit_signal);
assign #1 bne= (~func_3[2]) & (~func_3[1]) &  (func_3[0]) & (~zero_signal);
assign #1 blt= (func_3[2]) & (~func_3[1]) &  (~func_3[0]) & (~zero_signal) & sign_bit_signal;
assign #1 bltu= (func_3[2]) & (func_3[1]) &  (~func_3[0]) & (~zero_signal) & sltu_bit_signal;
assign #1 bgeu= (func_3[2]) & (func_3[1]) &  (func_3[0]) & (~sltu_bit_signal);

always @(branch_signal,jump_signal)begin
    branch_jump_mux_signal=(branch_signal &(beq|bge|bne|blt|bltu|bgeu)) | (jump_signal);
end

always @(RESET)begin
    branch_jump_mux_signal = 1'b0;
end

always @(*) begin
    #1                                     //register write delay
    if (jump_signal==1'b1) begin
        Branch_jump_PC_OUT=Alu_Jump_imm;
    end
    else begin
        #2                                  //adder delay
        Branch_jump_PC_OUT=PC+Branch_imm;
    end
end
    
endmodule