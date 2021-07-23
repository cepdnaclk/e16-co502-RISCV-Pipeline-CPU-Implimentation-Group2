//       #########         Data output refining        ########

//Delays should be introduced..
//whole module is asynchronous(no clock needed)


module dataRefine(LOAD,STORE,from_Dmem,DATA_IN,DATA_OUT,FUNCT3);	//module for Data refine for Data memory
    input LOAD,STORE;                                               //control signals for load or store
    input [31:0] from_Dmem,DATA_IN;                                 //get inputs from registers and data memory
	input [2:0] FUNCT3;                                             //funct3 field to identify which potion is needed from the data(either full word or hard word or byte etc.)
	output [31:0] DATA_OUT;                                         //module dataoutput                              	    
	
    //Detecting an incoming Load or store
    reg loadaccess,storeaccess;
	always @(LOAD, STORE)
    begin
        loadaccess = (LOAD && !STORE)? 1 : 0;
        storeaccess = (!LOAD && STORE)? 1 : 0;
    end

    //temporary register to store data
    reg [31:0] buffer;

    always @(*)
    begin
        if (loadaccess && !storeaccess)
        begin
            //if load, insert data from data memory to the buffer
            buffer = from_Dmem;
        end
        else if (!loadaccess && storeaccess)
        begin
            //if store, insert data from register to the buffer
            buffer = DATA_IN;   
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
	
endmodule
