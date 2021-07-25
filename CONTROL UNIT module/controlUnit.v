//       #########         CONTROL UNIT        ########

//Delays should be introduced..
//compatible with the new datapath.. updated 6/7/2021

module controlUnit(Instruction,mux1_select,mux2_select,mux3_select,mux4_select,memRead,memWrite,branch,jump,writeEnable,AlUop);          //control unit module
	
    //port declaration
    input  [31:0] Instruction;
    output [4:0] AlUop;
    output branch,Jump;
    output [1:0] mux4_select;
    output [2:0] mux2_select;
	output mux1_select,mux3_select,
            mux5_select,memRead,memWrite,branch,jump,writeEnable;
        
	reg [6:0] OPCODE;
    reg [2:0] funct3;
    reg funct7_A,funct7_B;
    reg [1:0] mux3_select;                                //mux at the end of the pipeline which differentiate aluOut,data mem out and pc+4 value for JAL instructions
    reg mux1_select,mux2_select,mux4_select,
            mux5_select,memRead,memWrite,branch,jump,writeEnable;
    wire [8:0] specific_OP;
    reg  [2:0] branch_Jump;
    reg  [2:0] Immidiate;
    reg  [3:0] instr_type;
    reg  [4:0] AlUop;

	always@(Instruction)begin
	#1                                                      //decode delay
	OPCODE = Instruction[6:0];                              //instruction decoding
    funct3 = Instruction[14:12];                            //funct3 field
    funct7_A = Instruction[30];                             //7th bit of funct7
    funct7_B = Instruction[25];                             //1st bit of funct7
	end
	
	always @(OPCODE) begin     
		case(OPCODE)
			7'b0110111:begin 		//U type (lui) instruction
                instr_type  = 4'b0000;          
                mux4_select = 2'b00;
                writeEnable = 1'b1;
                memRead     = 1'b0;
                memWrite    = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
			7'b0010111:begin 		//U type (auipc) instruction
                instr_type = 4'b0001;
                mux4_select = 2'b01;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
			7'b1101111:begin 		//jal instruction
                instr_type = 4'b0010;
                mux4_select = 2'b10;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b1;
				end
			7'b1100111:begin 		//jalr instruction
                instr_type = 4'b0011;
                mux4_select = 2'b10;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b1;
				end
            7'b1100011:begin 		//B type instructions
                instr_type = 4'b0100;
                mux4_select = 2'b01;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b1;
                jump        = 1'b0;
				end
            7'b0000011:begin 		//I type (load) instructions
                instr_type = 4'b0101;
                mux4_select = 2'b01;
                writeEnable = 1'b1;
                memRead = 1'b1;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0100011:begin 		//S type instructions
                instr_type = 4'b0110;
                mux4_select = 2'b01;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b1;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0010011:begin 		//I type instructions
                instr_type = 4'b0111;
                mux4_select = 2'b01;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0110011:begin 		//R type instructions(with standard M extention)
                instr_type = 4'b1000;
                mux4_select = 2'b01;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end        
		endcase
    end

    
    assign specific_OP = {funct7_A,funct7_B,funct3,instr_type};      //concatenation
    always @(specific_OP) begin
        casex(specific_OP)
            9'bxxxxx0000: begin                             //LUI//
                AlUop         = 5'bxxxxx;
                mux1_select = 1'bx;
                mux2_select = 3'b011; //forward
                mux3_select = 1'b0;
                mux5_select = 1'bx;
            end
            9'bxxxxx0001: begin                             //AUIPC//
                AlUop         = 5'b00000;
                mux1_select = 1'b1;
                mux2_select = 3'b011;
                mux3_select = 1'b0;
                mux5_select = 1'b0;
            end
            9'bxxxxx0010: begin                             //JAL//
                AlUop         = 5'b00000;
                mux1_select = 1'b1;
                mux2_select = 3'b100;
                mux3_select = 1'b0;
                mux5_select = 1'b0;
            end
            9'bxxxxx0011: begin                             //JALR//
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'b100;
                mux3_select = 1'b0;
                mux5_select = 1'b0;
            end
            9'bxx0000100: begin                           //B type instructions specific opcodes (BEQ) //
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx0010100: begin                          //BNE //     
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1000100: begin                         //BLT//             
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1010100: begin                         //BGE//        
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1100100: begin                        //BLTU//   
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1110100: begin                       //BGEU //        
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            //I type(Load) and store type specific opcodes have to be finalized

            9'bxxxxx0101: begin                       //Load instructions//        
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'b001;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end

            9'bxxxxx0110: begin                       //store instructions//        
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'b001;
                mux3_select = 1'b1;
                mux5_select = 1'b1;
            end
            
            9'bxx0000111: begin                          //I type instructions(ADDI)//            
                AlUop         = 5'b00000;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx0100111: begin                         //SLTI            //             
                AlUop         = 5'b10000;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx0110111: begin                        //SLTiU        //                            
                AlUop         = 5'b00001;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx1000111: begin                        //XORI           //                      
                AlUop         = 5'b00100;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx1100111: begin                       //ORI         //                
                AlUop         = 5'b00011;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx1110111: begin                       //ANDI      //                              
                AlUop         = 5'b00010;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b000010111: begin                       //SLLI    //                                
                AlUop         = 5'b00101;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001010111: begin                       //SRLI  //     
                AlUop         = 5'b00110;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b101010111: begin                       //SRAI//       
                AlUop         = 5'b00111;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                       //R type(ADD)   //              
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b101011000: begin                         //SUB //
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                        //SLL //                         
                AlUop         = 5'b00101;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //SLT //      
                AlUop         = 5'b10000;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //SLTU //    
                AlUop         = 5'b10001;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                        //XOR //   
                AlUop         = 5'b00100;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                        //SRL //      
                AlUop         = 5'b00110;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b101011000: begin                         //SRA //      
                AlUop         = 5'b00111;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //OR  //   
                AlUop         = 5'b00011;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //AND //          
                AlUop         = 5'b00010;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin                //M extention instructions (MUL)    //                     
                AlUop         = 5'b01000;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //MULH //                               
                AlUop         = 5'b01001;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin                                    
                AlUop         = 5'b01010;     //MULHSU//
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //MULHU  //                       
                AlUop         = 5'b01011;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //DIV  //                   
                AlUop         = 5'b01100;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin                //DIVU //                   
                AlUop         = 5'b01101;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //REM //                              
                AlUop         = 5'b01110;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin              //REMU  //                         
                AlUop         = 5'b01111;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
        endcase       
    end

endmodule