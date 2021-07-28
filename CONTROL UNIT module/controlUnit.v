//       #########         CONTROL UNIT        ########

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
        
	reg [6:0] OPCODE;
    reg [2:0] funct3;
    reg funct7_A,funct7_B;
    reg [1:0] mux4_select;                                
    reg mux1_select,mux2_select,mux3_select,
            mux5_select,memRead,memWrite,branch,jump,writeEnable;
    wire [8:0] specific_OP;
    reg  [2:0] Immidiate;
    reg  [3:0] instr_type;
    reg  [4:0] AlUop;

	always@(Instruction)begin
	OPCODE = Instruction[6:0];                              //instruction decoding
    funct3 = Instruction[14:12];                            //funct3 field
    funct7_A = Instruction[30];                             //7th bit of funct7
    funct7_B = Instruction[25];                             //1st bit of funct7
	end
	

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
                mux4_select = 2'b00;
                writeEnable = 1'b1;
                memRead     = 1'b0;
                memWrite    = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
			7'b0010111:begin 		//U type (auipc) instruction
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0001;
                mux4_select = 2'b01;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
			7'b1101111:begin 		//jal instruction
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0010;
                mux4_select = 2'b10;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b1;
				end
			7'b1100111:begin 		//jalr instruction
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0011;
                mux4_select = 2'b10;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b1;
				end
            7'b1100011:begin 		//B type instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0100;
                mux4_select = 2'b01;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b1;
                jump        = 1'b0;
				end
            7'b0000011:begin 		//I type (load) instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0101;
                mux4_select = 2'b01;
                writeEnable = 1'b1;
                memRead = 1'b1;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0100011:begin 		//S type instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0110;
                mux4_select = 2'b01;
                writeEnable = 1'b0;
                memRead = 1'b0;
                memWrite = 1'b1;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0010011:begin 		//I type instructions
                #1                                          //delay occured by combinational logic
                instr_type = 4'b0111;
                mux4_select = 2'b01;
                writeEnable = 1'b1;
                memRead = 1'b0;
                memWrite = 1'b0;
                branch      = 1'b0;
                jump        = 1'b0;
				end
            7'b0110011:begin 		//R type instructions(with standard M extention)
                #1                                          //delay occured by combinational logic
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

    /* 
    -----
     instruction specific control signals
    -----
    */    
    assign specific_OP = {funct7_A,funct7_B,funct3,instr_type};      //concatenation
    always @(specific_OP) begin
        casex(specific_OP)
            9'bxxxxx0000: begin                             //LUI//                                                            U type (lui) instruction
                #1                                         //delay occured by combinational logic
                AlUop         = 5'bxxxxx;
                mux1_select = 1'bx;
                mux2_select = 3'b011; //forward
                mux3_select = 1'b0;
                mux5_select = 1'bx;
            end
            9'bxxxxx0001: begin                             //AUIPC//                                                          auipc
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00000;
                mux1_select = 1'b1;
                mux2_select = 3'b011;
                mux3_select = 1'b0;
                mux5_select = 1'b0;
            end
            9'bxxxxx0010: begin                             //JAL//                                                            jal
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00000;
                mux1_select = 1'b1;
                mux2_select = 3'b100;
                mux3_select = 1'b0;
                mux5_select = 1'b0;
            end
            9'bxxxxx0011: begin                             //JALR//                                                           jalr instruction
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'b100;
                mux3_select = 1'b0;
                mux5_select = 1'b0;
            end
            9'bxx0000100: begin                           //BEQ //                                                             B type instructions
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx0010100: begin                          //BNE //
                #1                                         //delay occured by combinational logic     
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1000100: begin                         //BLT//
                #1                                         //delay occured by combinational logic             
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1010100: begin                         //BGE//
                #1                                         //delay occured by combinational logic        
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1100100: begin                        //BLTU//  
                #1                                         //delay occured by combinational logic 
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            9'bxx1110100: begin                       //BGEU //   
                #1                                         //delay occured by combinational logic     
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'b000;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end
            //I type(Load) and store type specific opcodes have to be finalized

            9'bxxxxx0101: begin                       //Load instructions//                                             I type (load) instructions
                #1                                         //delay occured by combinational logic   
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'b001;
                mux3_select = 1'bx;
                mux5_select = 1'b1;
            end

            9'bxxxxx0110: begin                       //store instructions//                                             S type instructions
                #1                                         //delay occured by combinational logic    
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'b001;
                mux3_select = 1'b1;
                mux5_select = 1'b1;
            end
            
            9'bxx0000111: begin                          //ADDI//                                                       I type instructions
                #1                                         //delay occured by combinational logic           
                AlUop         = 5'b00000;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx0100111: begin                         //SLTI            //  
                #1                                         //delay occured by combinational logic           
                AlUop         = 5'b10000;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx0110111: begin                        //SLTiU        //   
                #1                                         //delay occured by combinational logic                         
                AlUop         = 5'b00001;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx1000111: begin                        //XORI           //   
                #1                                         //delay occured by combinational logic                   
                AlUop         = 5'b00100;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx1100111: begin                       //ORI         //   
                #1                                         //delay occured by combinational logic             
                AlUop         = 5'b00011;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'bxx1110111: begin                       //ANDI      //    
                #1                                         //delay occured by combinational logic                          
                AlUop         = 5'b00010;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b000010111: begin                       //SLLI    //     
                #1                                         //delay occured by combinational logic                           
                AlUop         = 5'b00101;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001010111: begin                       //SRLI  //     
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00110;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b101010111: begin                       //SRAI//       
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00111;
                mux1_select = 1'b1;
                mux2_select = 3'b010;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                       //R type(ADD)   //                                                  R type instructions
                #1                                         //delay occured by combinational logic             
                AlUop         = 5'b00000;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b101011000: begin                         //SUB //
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00001;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                        //SLL //   
                #1                                         //delay occured by combinational logic                      
                AlUop         = 5'b00101;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //SLT //    
                #1                                         //delay occured by combinational logic  
                AlUop         = 5'b10000;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //SLTU //  
                #1                                         //delay occured by combinational logic  
                AlUop         = 5'b10001;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                        //XOR //   
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00100;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                        //SRL //   
                #1                                         //delay occured by combinational logic   
                AlUop         = 5'b00110;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b101011000: begin                         //SRA //      
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00111;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //OR  //   
                #1                                         //delay occured by combinational logic
                AlUop         = 5'b00011;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b001011000: begin                         //AND //     
                #1                                         //delay occured by combinational logic     
                AlUop         = 5'b00010;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin                //M extention instructions (MUL)    //                                           M extention instructions
                #1                                         //delay occured by combinational logic                   
                AlUop         = 5'b01000;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //MULH //         
                #1                                         //delay occured by combinational logic                      
                AlUop         = 5'b01001;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin                //MULHSU//
                #1                                         //delay occured by combinational logic                                  
                AlUop         = 5'b01010;     
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //MULHU  //        
                #1                                         //delay occured by combinational logic               
                AlUop         = 5'b01011;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //DIV  //        
                #1                                         //delay occured by combinational logic           
                AlUop         = 5'b01100;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin                //DIVU //       
                #1                                         //delay occured by combinational logic            
                AlUop         = 5'b01101;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin               //REM //            
                #1                                         //delay occured by combinational logic                  
                AlUop         = 5'b01110;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
            9'b011011000: begin              //REMU  //          
                #1                                         //delay occured by combinational logic               
                AlUop         = 5'b01111;
                mux1_select = 1'b0;
                mux2_select = 3'bxxx;
                mux3_select = 1'b0;
                mux5_select = 1'b1;
            end
        endcase       
    end

endmodule