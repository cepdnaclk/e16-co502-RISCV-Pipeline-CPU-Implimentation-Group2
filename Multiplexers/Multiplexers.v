`timescale  1ns/100ps

// 1 type - two 32 bit inputs, 1 bit select signal, 32 bit output
// mux 1, mux 5, mux 3 and pc mux are this type of multiplexers (in the datapath)
module multiplexer_type1(IN1,IN2,OUT,SELECT);		
	input [31:0] IN1,IN2;
	input SELECT;
	output [31:0] OUT;

	assign OUT = (SELECT) ? IN1 : IN2 ;
	
endmodule

// 2 type - five 32 bit inputs, 3 bit select signal, 32 bit output
// mux 2 is this type of multiplexer (in the datapath)
module multiplexer_type2(IN1,IN2,IN3,IN4,IN5,OUT,SELECT);		//multiplexer
	input [31:0] IN1,IN2,IN3,IN4,IN5;
	input [2:0] SELECT;
	output [31:0] OUT;

    //!is there anyway that we can "dont care" with unused select signals????
	assign OUT = (SELECT[2]) ? ((SELECT[1]) ? (SELECT[0]? 32'bx:32'bx) : (SELECT[0]? 32'bx:IN5)) : ((SELECT[1]) ? (SELECT[0]? IN4:IN3) : (SELECT[0]? IN2:IN1)) ;
	
endmodule

// 3 type - three 32 bit inputs, 2 bit select signal, 32 bit output
// mux 4 is this type of multiplexer (in the datapath)
module multiplexer_type3(IN1,IN2,IN3,OUT,SELECT);		//multiplexer
	input [31:0] IN1,IN2,IN3;
	input [1:0] SELECT;
	output [31:0] OUT;

	assign OUT = (SELECT[1]) ? (SELECT[0]? 32'bx:IN3) : (SELECT[0]? IN2:IN1) ;
	
endmodule
