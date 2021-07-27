module programeCounter(CLK,RESET,nextPC,PC,busyWait);
input CLK,RESET,busyWait;
input [31:0] nextPC;
output [31:0] PC;
reg PC;


always @(RESET) begin   // when reset the pc
	    #1                               //pc write delay
		PC = -4;                      //initial pc value at reset
	end
	
	
always @(posedge CLK) begin    //always
    #1                            //pc write delay
    if(!busyWait)begin                  //update the pc only when busywait is 0
        PC = nextPC;              //pc write with the updated value using adder now pc changed so instruction read starts now
    end
end
endmodule