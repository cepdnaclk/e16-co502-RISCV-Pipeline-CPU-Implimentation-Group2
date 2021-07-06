module reg_file(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS,WRITE,CLK,RESET); 		//register file
	input [4:0] OUT1ADDRESS,OUT2ADDRESS,INADDRESS;   //5 bit addresses
	input [31:0] IN;
	input CLK,RESET;
	input WRITE;
	output wire [31:0] OUT1,OUT2;
	integer n;
	reg [31:0] regFile [0:31];	//regfile
	
	assign OUT1 = regFile[OUT1ADDRESS];   //register read with delay
	assign OUT2 = regFile[OUT2ADDRESS];

	always @(posedge CLK) begin 	//writing to the register file
	    if(WRITE == 1'b1 && RESET != 1'b1 )begin
		regFile[INADDRESS] = IN;                //Writing to the corresponding register
		end
	end
	
	always@(RESET) begin     //level triggered RESET 
	 if(RESET==1'b1) begin
	     for(n=0; n<32;n=n+1)regFile[n] = 0;                      
	     end
     end
endmodule



module regfile_testbed();		//testbed of register file
	reg [4:0] OUT1ADDRESS,OUT2ADDRESS,INADDRESS;
	reg [31:0] IN;
	reg CLK,RESET,WRITE;
	wire [31:0] OUT1,OUT2;
	integer i;

	always #5 CLK = ~CLK;

	reg_file r1(IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS,WRITE,CLK,RESET);

	initial
	begin
		$dumpfile("wavedata.vcd");
		$dumpvars(0,regfile_testbed);	
		 CLK = 1'b1;
		 
		      //assigning values
        RESET = 1'b0;
        WRITE = 1'b0;
        
        #1
        RESET = 1'b1;
        OUT1ADDRESS = 5'd0;
        OUT2ADDRESS = 5'd4;
        
        #5
        INADDRESS = 5'd2;
        IN = 32'd95;
        WRITE = 1'b1;
        
        #10
        WRITE = 1'b0;
        
        #1
        OUT1ADDRESS = 5'd2;
		
		  #8
        RESET = 1'b0;
        
        #9
        INADDRESS = 5'd1;
        IN = 32'd28;
        WRITE = 1'b1;
        OUT1ADDRESS = 5'd1;
		OUT2ADDRESS = 5'd2;
        
        #10
        WRITE = 1'b0;
		INADDRESS = 5'd6;
        IN = 8'd108;
		OUT2ADDRESS = 5'd6;
        
        #10
        INADDRESS = 5'd4;
        IN = 32'd6;
        WRITE = 1'b1;
        
        #10
        IN = 31'd15;
        WRITE = 1'b1;
        
        #10
        WRITE = 1'b0;
        
        #6
        INADDRESS = 5'd1;
        IN = 32'd50;
        WRITE = 1'b1;
        
        #5
        WRITE = 1'b0;
        
        #10
        $finish;
		
	end
endmodule