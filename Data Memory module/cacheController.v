`timescale  1ns/100ps
module cacheController(
	clock,
    reset,
    read,
    write,
    address,
    writedata,
    busywait,
    mem_Busywait,
    Tag1,writedata1,Tag,Index,hit,dirty,mem_Read,mem_Write,mem_Writedata,mem_Address);

    input[7:0] address,writedata;
    input[31:0] writedata1;
    input[2:0] Tag1,Tag,Index;
    input mem_Busywait,read,write,clock,reset,hit,dirty;
    output busywait,mem_Read,mem_Write;
    output[31:0] mem_Writedata;
    output[5:0] mem_Address;
    reg [31:0] mem_Writedata;
    reg[5:0] mem_Address;
    reg mem_Read,mem_Write,busywait;


    /* Cache Controller FSM Start */

    /*    here i used three states
          cache controller is used to set data memory control signals whenever a miss
              occured in cache memory
          please find the attached state diagrame for better understanding    */     


    parameter IDLE = 2'b00, MEM_READ = 2'b01, WRITE_BACK = 2'b10; 
    reg [1:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:
                 if ((read || write) && dirty && !hit)
                    begin
                     next_state = WRITE_BACK;
                    end             
                 else if ((read || write) && !dirty && !hit)
                    begin
                     next_state = MEM_READ;
                    end  
                 else 
                    begin
                     next_state = IDLE;
                    end            
            
            MEM_READ:
                 if (!mem_Busywait)
                    begin
                     next_state = IDLE;
                    end
                 else 
                    begin   
                     next_state = MEM_READ;
                    end  

            WRITE_BACK:
                 if (!mem_Busywait)
                    begin
                     next_state = MEM_READ;
                    end
                 else 
                    begin   
                     next_state = WRITE_BACK;
                    end

        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_Read = 0;
                mem_Write = 0;
                mem_Address = 6'dx;
                mem_Writedata = 32'dx;
                busywait = 0;
            end

            MEM_READ: 
            begin
                mem_Read = 1;
                mem_Write = 0;
                mem_Address = {Tag, Index};
                mem_Writedata = 32'dx;
                busywait = 1;
            end
            
            WRITE_BACK:
            begin
            	mem_Read = 0;
                mem_Write = 1;
                mem_Address = {Tag1, Index};
                mem_Writedata = writedata1;
                busywait = 1;
            end
        endcase
    end

    // sequential logic for state transitioning 
    always @(posedge clock, reset)
    begin
        if(reset)
            state = IDLE;
        else
            state = next_state;
    end

    /* Cache Controller FSM End */
endmodule