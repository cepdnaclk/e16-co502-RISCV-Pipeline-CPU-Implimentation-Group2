//       #########         ALU        ########

//Delays should be introduced..


module alu(DATA1,DATA2,RESULT,SELECT,zero_signal,sign_bit_signal,sltu_bit_signal);	//module for ALU
    input [31:0]DATA1,DATA2;                                             //define 32bit tw0 inputs DATA1 and DATA2
	input [4:0] SELECT;                                                  //define 5bit SELECT port
	output [31:0]RESULT;                                   	             //define 32bit output port
	output     zero_signal,sign_bit_signal,sltu_bit_signal;
	wire[31:0] ADD,SUB,AND,OR,XOR,
			   SLL,SRL,SRA,
			   MUL,MULH,MULHU,MULHSU,
			   DIV,DIVU,REM,REMU,
			   SLT,SLTU;                                       
    reg[31:0] RESULT;													 //(output is declared as type reg since it is used in procedural block)
	
	assign zero_signal= ~(|RESULT);                                      //zero flag set when data 1 and data 2 is equal
	assign sign_bit_signal=RESULT[31];
	assign sltu_bit_signal=SLTU[0];

	//forwarding removed
	// assign FORWARD=DATA2;                                  //forward DATA2 to output

    //R type instructions
    assign ADD=DATA1 + DATA2;                             //Addition
	assign SUB=DATA1 - DATA2;                             //Substraction
    assign AND=DATA1 & DATA2;                             //bitwise AND
    assign OR=DATA1 | DATA2;                              //bitwise OR
    assign XOR=DATA1 ^ DATA2;                             //bitwise XOR

	//shift operations
    assign SLL = DATA1 << DATA2;                          //shift left logical
    assign SRL = DATA1 >> DATA2;						  //shift right logical
    assign SRA = DATA1 >>> DATA2;						  //shift roght arithmetic

	//multiplication and division instructions
	assign MUL = DATA1 * DATA2;                            // Multiplication
    assign MULH = DATA1 * DATA2;                           // Multiplication (Signed)
    assign MULHU = $unsigned(DATA1) * $unsigned(DATA2);    // Multiplication (Unsigned)
    assign MULHSU = $signed(DATA1) * $unsigned(DATA2);     // Multiplication (Signed x UnSigned)

	assign DIV = DATA1 / DATA2;                           // Division
    assign DIVU = $unsigned(DATA1) / $unsigned(DATA2);    // Division Unsigned
    assign REM = DATA1 % DATA2;                           // Remainder
    assign REMU = DATA1 % DATA2;                          // Remainder Unsigned


	assign SLT = ($signed(DATA1) < $signed(DATA2)) ? 32'd1 : 32'd0;         // set less than (signed)
    assign SLTU = ($unsigned(DATA1) < $unsigned(DATA2)) ? 32'd1 : 32'd0;    // set less than (unsigned)

	always@(*)                          //always block calls whenever a signal changes
	begin
		case(SELECT)
			5'b00000: begin 
			        RESULT = ADD;                                                  
					end
			5'b00001: begin 
                 	RESULT = SUB;		         
					end
			5'b00010: begin 
			        RESULT = AND;          
					end
            5'b00011: begin 
			        RESULT = OR;        
					end
            5'b00100: begin
					RESULT = XOR;	             							
                     end
   			5'b00101: begin                                                             
			        RESULT = SLL;                   
					 end
            5'b00110: begin
			        RESULT = SRL;                 			            							
                    end
            5'b00111: begin
			        RESULT = SRA;                 			            							
                    end
            5'b01000: begin
			        RESULT = MUL;                 			            							
                    end
            5'b01001: begin
			        RESULT = MULH;                 			            							
                    end
			5'b01010: begin
			        RESULT = MULHU;                 			            							
                    end
			5'b01011: begin
			        RESULT = MULHSU;                 			            							
                    end
			5'b01100: begin
			        RESULT = DIV;                 			            							
                    end
			5'b01101: begin
			        RESULT = DIVU;                 			            							
                    end                                              			  
			5'b01110: begin
			        RESULT = REM;                 			            							
                    end
			5'b01111: begin
			        RESULT = REMU;                 			            							
                    end
			5'b10000: begin
			        RESULT = SLT;                 			            							
                    end
			5'b10001: begin
			        RESULT = SLTU;                 			            							
                    end
		    default:RESULT = 31'd0;				                              //unused select combination makes output 0
		endcase
	end
	
endmodule




 module alu_testbench();		                                      //testbench of ALU
	reg [31:0] DATA1,DATA2;
	reg [4:0] SELECT;
	wire [31:0] RESULT;
	wire zero_signal,sign_bit_signal,sltu_bit_signal;
	 
	 alu alu_test(DATA1,DATA2,RESULT,SELECT,zero_signal,sign_bit_signal,sltu_bit_signal);	
		
		initial
		begin
		$monitor("DATA1: %b,DATA2: %b,SELECT: %b,RESULT: %b",DATA1,DATA2,SELECT,RESULT);
		end
		
		initial
		begin
		
		DATA1 = 32'd25;
		DATA2 = 32'd20;
		SELECT = 5'b00000;
		 #5 
		$display("TEST 1 Passed!");
		SELECT = 5'b00001;
		 #5
		 $display("TEST 2 Passed!");
		SELECT = 5'b00010;
		 #5
		SELECT = 5'b00011;
		 #5
		SELECT = 5'b00100;
		 #5
		SELECT = 5'b00100;
		end
		
 endmodule
