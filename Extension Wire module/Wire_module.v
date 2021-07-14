module Wire_module (
    Instruction,
    B_imm,
    J_imm,
    S_imm,
    U_imm,
    I_imm

);

input  [31:0] Instruction;
output [31:0] B_imm,J_imm,S_imm,U_imm,I_imm;

// sign extention imidiate value for B type 
assign B_imm={{20{Instruction[31]}},Instruction[7],Instruction[30:25],Instruction[11:5],1'b0};
// sign extention imidiate value for J type 
assign J_imm={{12{Instruction[31]}},Instruction[19:12],Instruction[20],Instruction[30:21],1'b0};
// sign extention imidiate value for S type 
assign S_imm={{21{Instruction[31]}},Instruction[30:25],Instruction[11:7]};
// sign extention imidiate value for U type 
assign U_imm={Instruction[31:12],{12{1'b0}}};
// sign extention imidiate value for R type 
assign I_imm={{21{Instruction[31]}},Instruction[30:20]};
    
endmodule