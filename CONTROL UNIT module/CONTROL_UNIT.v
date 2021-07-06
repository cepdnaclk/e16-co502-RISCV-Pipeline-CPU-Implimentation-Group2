//       #########         CONTROL UNIT        ########

//Delays should be introduced..

module ControlUnit(Instruction,alu_op,mux1_select,mux2_select,mux3_select,mux4_select,mux5_select,memRead,memWrite,branch_jump,writeEnable);          //control unit module
	
    //port selection
    input  [31:0] Instruction;
	output [4:0] alu_op;
    output [3:0] branch_jump;
	output mux1_select,mux2_select,mux3_select,mux4_select,
            mux5_select,memRead,memWrite,writeEnable;
        
	reg [6:0] OPCODE;
    reg [4:0] alu_op;
    reg [3:0] branch_jump;
	reg mux1_select,mux2_select,mux3_select,mux4_select,
        mux5_select,memRead,memWrite,WriteEnable;
	
	// always @(Instruction) begin
	// 	OUT2addr <= Instruction[2:0];             
	// 	OUT1addr <= Instruction[10:8];
	// 	INaddr <= Instruction[18:16];
	// 	targetOffset <= Instruction[23:16];
	// 	Immediate <= Instruction[7:0];
	// end

	always@(Instruction)begin
	#1                                                      //decode delay(should change)
	OPCODE = Instruction[6:0];                              //instruction decoding
    funct3 = Instruction[14:12];
    funct7 = Instruction[31:25];
	end
	
	//assign alu_select = OPCODE [2:0];    //assigning alu select signal according to instruction
	
	always @(OPCODE) begin     
		case(OPCODE)
			7'b0110111:begin 		//U type (lui) instruction
				mulx1 = 1'b0;
				mulx2 = 1'b1;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
			7'b0010111:begin 		//U type (auipc) instruction
				mulx1 = 1'b1;
				mulx2 = 1'bx;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
			7'b1101111:begin 		//jal instruction
				mulx1 = 1'b0;
				mulx2 = 1'b1;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
			7'b1100111:begin 		//jalr instruction
				mulx1 = 1'b0;
				mulx2 = 1'b0;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
            7'b1100011:begin 		//B type instructions
				mulx1 = 1'b0;
				mulx2 = 1'b0;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
            7'b0000011:begin 		//I type (load) instructions
				mulx1 = 1'b0;
				mulx2 = 1'b0;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
            7'b0100011:begin 		//S type instructions
				mulx1 = 1'b0;
				mulx2 = 1'b0;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
            7'b0010011:begin 		//I type instructions
				mulx1 = 1'b0;
				mulx2 = 1'b0;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end
            7'b0110011:begin 		//R type instructions(with standard M extention)
				mulx1 = 1'b0;
				mulx2 = 1'b0;
				WriteEnable = 1'b1;
				isJump = 1'b0;
				branchEq = 1'b0;
				muxSelect = 1'b0;
				shift = 2'bxx;
				end        
		endcase
     end
endmodule