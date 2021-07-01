module alu(DATA1,DATA2,RESULT,SELECT,ZERO);	//module for ALU
    input [31:0]DATA1,DATA2;                                             //define 32bit tw0 inputs DATA1 and DATA2
	input [3:0] SELECT;                                                      //define 4bit SELECT port
	output [31:0]RESULT;                                   	             //define 32bit output port
	output ZERO;
	wire[31:0] FORWARD,ADD,AND,OR,BEQnBNE,MULT;
	wire ZERO;                                                     //output is declared as type reg since it is used in procedural block
    reg[31:0] A1,A2,A3,A4,RESULT;
    integer i;
	


    //ADD,SUB,SLL,SRL,XOR,OR,AND,SRA,MUL
    assign FORWARD=DATA2;                                  //forward DATA2 to output
    assign ADD=DATA1+DATA2;                               //ADD
    assign AND=DATA1 & DATA2;                            //AND
    assign OR=DATA1 | DATA2;                             //OR
    assign XOR=DATA1 ~^ DATA2;                             //XOR
    assign MULT = DATA1 * DATA2;                         //multiplication

	//shift operations
    assign SLL = DATA1 << DATA2;
    assign SRL = DATA1 >> DATA2;
    assign SRA = DATA1 >>> DATA2;

    //branching
	assign ZERO = ADD | ADD;                  //bitwise OR the result to set the zero flag 

	always@(*)                          //always block calls whenever a signal changes
	begin
		case(SELECT)
			4'b0000: begin 
			        RESULT = FORWARD;                                                  
					end
			4'b0001: begin 
                 	RESULT = ADD;		         
					end
			4'b0010: begin 
			        RESULT = AND;          
					end
            4'b0011: begin 
			        RESULT = OR;        
					end
            // 4'b0100: begin
			//         // ZERO = ~(|BEQnBNE);
			// 		RESULT = ADD;	             							
            //          end
   			4'b0101: begin                                                               //multiplication
			        RESULT = MULT;                   
					 end
            4'b0110: begin
			        RESULT = XOR;                 			            							
                    end
            4'b0111: begin
			        RESULT = SLL;                 			            							
                    end
            4'b1000: begin
			        RESULT = SRL;                 			            							
                    end
            4'b1001: begin
			        RESULT = SRA;                 			            							
                    end                                              			  
		    default:RESULT =1'd0;				                              //unused select combination makes output 0
		endcase
	end
	
endmodule



//in this test bench, the value already in RESULT  is printed instantly before the calculation take place and then print the correct value

 module alu_testbench();		                                      //testbench of ALU
	reg [31:0] DATA1,DATA2;
	reg [3:0] SELECT;
	wire [31:0] RESULT;
	wire ZERO;

	alu alu_test(DATA1,DATA2,RESULT,SELECT,ZERO);	
		
		initial
		begin
		$monitor("DATA1: %b,DATA2: %b,SELECT: %b,RESULT: %b,ZERO: %b",DATA1,DATA2,SELECT,RESULT,ZERO);
		end
		
		initial
		begin
		
		DATA1 = 32'b00000000000000000000000000001010;
		DATA2 = 32'b00000000000000000000000000010100;
		SELECT = 4'b0000;
		 #5
		SELECT = 4'b0001;
		 #5
		SELECT = 4'b0010;
		 #5
		SELECT = 4'b0011;
		 #5
		SELECT = 4'b0100;
		 #5
		SELECT = 4'b0100;
		end
		
 endmodule
