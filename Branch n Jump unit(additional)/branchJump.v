//       #########         Branch and Jump unit(not completed)        ########

//Delays should be introduced..
//whole module is asynchronous(no clock needed)


module dataRefine(BRANCH,JUMP,ALUout,ALUflag,FUNC3,AdderOut,nextPC,PC_mux);	//module for Data refine for Data memory
    input BRANCH,JUMP;                                               //control signals for load or store
    input [31:0] ALUout,AdderOut;                                   //get inputs from ALU and the adder
    input [1:0] ALUflag;                                             //flags set by ALU(to resolve conditions)
	input [2:0] FUNCT3;                                             //funct3 field to identify which potion is needed from the data(either full word or hard word or byte etc.)
	output [31:0] nextPC;                                          //address that the PC should next fetch
    output PC_mux;     //should be zero by default                             	    
	
    //Detecting an incoming Load or store
    reg branchaccess,jumpaccess;
	always @(LOAD, STORE)
    begin
        branchaccess = (BRANCH && !JUMP)? 1 : 0;
        jumpaccess = (!BRANCH && JUMP)? 1 : 0;
    end

    //temporary register to store data
    reg [31:0] buffer;

    always @(*)
    begin
        if (branchaccess && !jumpaccess)
        begin
            buffer = ALUout;
        end
        else if (!branchaccess && jumpaccess)
        begin
            //if jump, no need to check any condition just jump
            buffer = AdderOut;
            PC_mux = 1;   
        end
    end

    always @(*)
    begin
        case(FUNCT3)
        3'b000: DATA_OUT = //bite
        3'b001: DATA_OUT = //half word
        3'b010: DATA_OUT = //full word 
        3'b100: DATA_OUT = //upper bite
        3'b101: DATA_OUT = //half word upper
    end

    //temporary registers for condition evaluation
    reg equal,greater;
    always @(*)
    begin
    //if load, insert data from data memory to the buffer
        case(ALUflag)
        //4 possible conditions (equal.not equal,greater than,less than)
        //zero(z) flag to check equality
        //Greater(G) flag to check greater than
        //ALUflag two bits are concatenation of Z and G
        2'b00:    //inequal & lessthan              (LT) 
            begin
                equal = 0;
                greater = 0;
            end                                               
        2'b01:    //inequal & greater than          (GT)
            begin
                equal = 0;
                greater = 1;
            end 
        2'b1x:    //equal                           (EQ)
            begin
                equal = 1;
                greater = 0;
            end 
        // 2'b11:    //equal & greater than
    end
	
endmodule