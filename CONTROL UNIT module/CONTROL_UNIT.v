//       #########         CONTROL UNIT        ########

//Delays should be introduced..
//compatible with the new datapath.. updated 6/7/2021

module ControlUnit(Instruction,mux1_select,mux2_select,mux3_select,mux4_select,mux5_select,memRead,memWrite,branch,jump,writeEnable,immediate__select);          //control unit module
	
    //port declaration
    input  [31:0] Instruction;
    output [2:0] immediate_select;
	output mux1_select,mux2_select,mux3_select,mux4_select,
            mux5_select,memRead,memWrite,branch,jump,writeEnable;
        
	reg [6:0] OPCODE;
    reg [1:0] mux3_select;                                //mux at the end of the pipeline which differentiate aluOut,data mem out and pc+4 value for JAL instructions
	output [2:0] immediate_select;
    reg mux1_select,mux2_select,mux3_select,mux4_select,
            mux5_select,memRead,memWrite,branch,jump,writeEnable;


	always@(Instruction)begin
	#1                                                      //decode delay(should change)
	OPCODE = Instruction[6:0];                              //instruction decoding
	end
	
	always @(OPCODE) begin     
		case(OPCODE)
			7'b0110111:begin 		//U type (lui) instruction
                mux1_select = 1'bx;
                mux2_select = 1'bx;
                mux3_select = 2'b01;
                mux4_select = 1'b0;
                mux5_select = 1'bx;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                jump = 1'b0;        //to check weather instruction is a jump
                branch = 1'b0;      //to check weather instruction is a branch
                immediate_select = 3'b000;   //control signal to sign extend module to select how should sign extend happen
				end
			7'b0010111:begin 		//U type (auipc) instruction
				mux1_select = 1'b0;
                mux2_select = 1'b1;
                mux3_select = 2'b01;
                mux4_select = 1'b1;
                mux5_select = 1'bx;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                jump = 1'b0;
                branch = 1'b0;
                immediate_select = 3'b000;
				end
			7'b1101111:begin 		//jal instruction
				mux1_select = 1'b0;
                mux2_select = 1'b1;
                mux3_select = 2'b10;
                mux4_select = 1'b1;
                mux5_select = 1'b0;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                jump = 1'b1;
                branch = 1'b0;
                immediate_select = 3'b001;
				end
			7'b1100111:begin 		//jalr instruction
				mux1_select = 1'b1;
                mux2_select = 1'b1;
                mux3_select = 2'b10;
                mux4_select = 1'b1;
                mux5_select = 1'b0;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                jump = 1'b1;
                branch = 1'b0;
                immediate_select = 3'b010;
				end
            7'b1100011:begin 		//B type instructions
				mux1_select = 1'b0;
                mux2_select = 1'b1;
                mux3_select = 2'bxx;
                mux4_select = 1'b1;
                mux5_select = 1'b1;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b0;
                jump = 1'b0;
                branch = 1'b1;
                immediate_select = 3'b011;
				end
            7'b0000011:begin 		//I type (load) instructions
				mux1_select = 1'b1;
                mux2_select = 1'b1;
                mux3_select = 2'b00;
                mux4_select = 1'b1;
                mux5_select = 1'bx;
                writeEnable = 1'b1;
                memRead = 1'b1;
                memWrite = 1'b0;
                jump = 1'b0;
                branch = 1'b0;
                immediate_select = 3'b010;
				end
            7'b0100011:begin 		//S type instructions
				mux1_select = 1'b1;
                mux2_select = 1'b1;
                mux3_select = 2'bxx;
                mux4_select = 1'b1;
                mux5_select = 1'bx;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b1;
                jump = 1'b0;
                branch = 1'b0;
                immediate_select = 3'b000;
				end
            7'b0010011:begin 		//I type instructions
				mux1_select = 1'b1;
                mux2_select = 1'b1;
                mux3_select = 2'b01;
                mux4_select = 1'b1;
                mux5_select = 1'bx;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                jump = 1'b0;
                branch = 1'b0;
                immediate_select = 3'b010;
				end
            7'b0110011:begin 		//R type instructions(with standard M extention)
				mux1_select = 1'b1;
                mux2_select = 1'b0;
                mux3_select = 2'b01;
                mux4_select = 1'b1;
                mux5_select = 1'bx;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                jump = 1'b0;
                branch = 1'b0;
                immediate_select = 3'bxxx;
				end        
		endcase
     end

endmodule