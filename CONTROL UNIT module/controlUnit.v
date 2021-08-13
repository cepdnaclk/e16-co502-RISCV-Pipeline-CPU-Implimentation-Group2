//       #########         CONTROL UNIT        ########
`timescale  1ns/100ps
//Delays are introduced..
//compatible with the new datapath.. updated 26/7/2021

module controlUnit(Instruction,mux1_select,mux2_select,mux3_select,mux4_select,mux5_select,memRead,memWrite,branch,jump,writeEnable,AlUop);          //control unit module
	
    //port declaration
    input  [31:0] Instruction;
    output [4:0] AlUop;
    output [1:0] mux4_select;
    output [2:0] mux2_select;
	output mux1_select,mux3_select,
            mux5_select,memRead,memWrite,branch,jump,writeEnable;
        
	wire [6:0] OPCODE;
    wire [2:0] funct3;
    wire funct7_A,funct7_B;
    reg [1:0] mux4_select;                                
    reg mux1_select,mux2_select,mux3_select,
            mux5_select,memRead,memWrite,branch,jump,writeEnable;
    wire [8:0] specific_OP;
    reg  [2:0] Immidiate;
    reg  [3:0] instr_type;
    reg  [4:0] AlUop;

	// always@(Instruction)begin
	// OPCODE = Instruction[6:0];                              //instruction decoding
    // funct3 = Instruction[14:12];                            //funct3 field
    // funct7_A = Instruction[30];                             //7th bit of funct7
    // funct7_B = Instruction[25];                             //1st bit of funct7
	// end
	
    assign OPCODE = Instruction[6:0];                       //opcode
    assign funct3 = Instruction[14:12];                     //funct3 field
    assign funct7_A = Instruction[30];                      //7th bit of funct7
    assign funct7_B = Instruction[25];                      //1st bit of funct7

    /* 
    -----
     general control signals for instruction type
    -----
    */   
	always @(OPCODE) begin     
		case(OPCODE)
			7'b0110111:begin 		//U type (lui) instruction
                #1                                          //delay occured by combinational logic
                instr_type  = 4'b0000;
                mux1_select = 1'bx;
                mux2_select = 3'b011; 
                mux3_select = 1'b0;         
                mux4_select = 2'b00;
                mux5_select = 1'bx; 
                writeEnable = 1'b1;
                memRead     = 1'b0;
                memWrite    = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
			7'b0010111:begin 		//U type (auipc) instruction
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0001;
                mux1_select = 1'b1;
                mux2_select = 3'b011;
                mux3_select = 1'b0;
                mux4_select = 2'b01;
                mux5_select = 1'b0;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
			7'b1101111:begin 		//jal instruction
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0010;
                mux1_select = 1'b1;
                mux2_select = 3'b100;
                mux3_select = 1'b0;
                mux4_select = 2'b10;
                mux5_select = 1'b0;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b1;
				end
			7'b1100111:begin 		//jalr instruction
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0011;
                mux1_select = 1'b0;
                mux2_select = 3'b100;
                mux3_select = 1'b0;
                mux4_select = 2'b10;
                mux5_select = 1'b0;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b1;
				end
            7'b1100011:begin 		//B type instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0100;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux4_select = 2'bxx;
                mux5_select = 1'b1;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b1;
                jump        = 1'b0;
				end
            7'b0000011:begin 		//I type (load) instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0101;
                mux1_select = 1'b0;
                mux2_select = 3'b001;
                mux3_select = 1'b1;
                mux4_select = 2'b01;
                mux5_select = 1'b0;
                writeEnable = 1'b1;
                memRead = 1'b1;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0100011:begin 		//S type instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0110;
                mux1_select = 1'b0;
                mux2_select = 3'b001;
                mux3_select = 1'b1;
                mux4_select = 2'b01;
                mux5_select = 1'b0;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b1;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0010011:begin 		//I type instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0111;
                mux1_select = 1'b0;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux4_select = 2'b01;
                mux5_select = 1'b0;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0110011:begin 		//R type instructions(with standard M extention)
                #1                                          //delay occured by combinational logic
                instr_type = 4'b1000;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux4_select = 2'b01;
                mux5_select = 1'b1;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0000000:begin 		//nop instruction
                #1                                          //delay occured by combinational logic
                instr_type = 4'b1001;
                mux1_select = 1'bx;
                mux2_select = 3'bxxx;
                mux3_select = 1'bx;
                mux4_select = 2'bxx;
                mux5_select = 1'bx;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end        
		endcase
    end

    /* 
    -----
     instruction specific control signals
    -----
    */    
    assign specific_OP = {funct7_A,funct7_B,funct3,instr_type};      //concatenation
    always @(*) begin
        #1                                                   //delay occured by combinational logic
        casex(specific_OP)
            9'bxxxxx0000: begin                             //LUI//                                                            U type (lui) instruction
                AlUop         = 5'bxxxxx;

            end
            9'bxxxxx0001: begin                             //AUIPC//                                                          auipc
                AlUop         = 5'b00000;

            end
            9'bxxxxx0010: begin                             //JAL//                                                            jal
                AlUop         = 5'b00000;

            end
            9'bxxxxx0011: begin                             //JALR//                                                           jalr instruction
                AlUop         = 5'b00000;

            end
            9'bxx0000100: begin                           //BEQ //                                                             B type instructions
                AlUop         = 5'b00001;

            end
            9'bxx0010100: begin                          //BNE //     
                AlUop         = 5'b00001;

            end
            9'bxx1000100: begin                         //BLT//             
                AlUop         = 5'b00001;

            end
            9'bxx1010100: begin                         //BGE//        
                AlUop         = 5'b00001;

            end
            9'bxx1100100: begin                        //BLTU//   
                AlUop         = 5'b00001;

            end
            9'bxx1110100: begin                       //BGEU //        
                AlUop         = 5'b00001;

            end
            //I type(Load) and store type specific opcodes have to be finalized

            9'bxxxxx0101: begin                       //Load instructions//                                             I type (load) instructions   
                AlUop         = 5'b00000;
            end

            9'bxxxxx0110: begin                       //store instructions//                                             S type instructions    
                AlUop         = 5'b00000;
            end
            
            9'bxx0000111: begin                          //ADDI//                                                       I type instructions           
                AlUop         = 5'b00000;
            end
            9'bxx0100111: begin                         //SLTI            //             
                AlUop         = 5'b10000;
            end
            9'bxx0110111: begin                        //SLTiU        //                            
                AlUop         = 5'b00001;
            end
            9'bxx1000111: begin                        //XORI           //                      
                AlUop         = 5'b00100;
            end
            9'bxx1100111: begin                       //ORI         //                
                AlUop         = 5'b00011;
            end
            9'bxx1110111: begin                       //ANDI      //                              
                AlUop         = 5'b00010;
            end
            9'b000010111: begin                       //SLLI    //                                
                AlUop         = 5'b00101;
            end
            9'b001010111: begin                       //SRLI  //     
                AlUop         = 5'b00110;
            end
            9'b101010111: begin                       //SRAI//       
                AlUop         = 5'b00111;
            end
            9'b001011000: begin                       //R type(ADD)   //                                                  R type instructions             
                AlUop         = 5'b00000;
            end
            9'b101011000: begin                         //SUB //
                AlUop         = 5'b00001;
            end
            9'b001011000: begin                        //SLL //                         
                AlUop         = 5'b00101;
            end
            9'b001011000: begin                         //SLT //      
                AlUop         = 5'b10000;
            end
            9'b001011000: begin                         //SLTU //    
                AlUop         = 5'b10001;
            end
            9'b001011000: begin                        //XOR //   
                AlUop         = 5'b00100;
            end
            9'b001011000: begin                        //SRL //      
                AlUop         = 5'b00110;
            end
            9'b101011000: begin                         //SRA //      
                AlUop         = 5'b00111;
            end
            9'b001011000: begin                         //OR  //   
                AlUop         = 5'b00011;
            end
            9'b001011000: begin                         //AND //          
                AlUop         = 5'b00010;
            end
            9'b011011000: begin                //M extention instructions (MUL)    //                                           M extention instructions                   
                AlUop         = 5'b01000;
            end
            9'b011011000: begin               //MULH //                               
                AlUop         = 5'b01001;
            end
            9'b011011000: begin                //MULHSU//                                  
                AlUop         = 5'b01010;     
            end
            9'b011011000: begin               //MULHU  //                       
                AlUop         = 5'b01011;
            end
            9'b011011000: begin               //DIV  //                   
                AlUop         = 5'b01100;
            end
            9'b011011000: begin                //DIVU //                   
                AlUop         = 5'b01101;
            end
            9'b011011000: begin               //REM //                              
                AlUop         = 5'b01110;
            end
            9'b011011000: begin              //REMU  //                         
                AlUop         = 5'b01111;
            end
            9'b000001001: begin              //nop  //                         
                AlUop         = 5'bxxxxx;
            end
        endcase       
    end

endmodule