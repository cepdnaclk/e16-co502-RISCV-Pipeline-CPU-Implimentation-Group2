`timescale  1ns/100ps
module instructionCacheCTRL(
	clock,
    reset,
    busywait,
    mem_Busywait,Tag,Index,hit,mem_Read,mem_Address);

    input[24:0] Tag;
    input[2:0] Index;
    input mem_Busywait,clock,reset,hit;
    output busywait,mem_Read;
    output[27:0] mem_Address;
    reg[27:0] mem_Address;
    reg mem_Read,busywait;


    /* Cache Controller FSM Start */

    /*    here i used 2 states
          cache controller is used to set instruction memory control signals whenever a miss
              occured in instruction cache memory   */     


    parameter IDLE = 2'b00, MEM_READ = 2'b01; 
    reg [1:0] state, next_state;

    // combinational next state logic
    always @(*)
    begin
        case (state)
            IDLE:             
                 if (!hit)
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
        endcase
    end

    // combinational output logic
    always @(*)
    begin
        case(state)
            IDLE:
            begin
                mem_Read = 0;
                mem_Address = 28'dx;
                busywait = 0;
            end

            MEM_READ: 
            begin
                mem_Read = 1;
                mem_Address = {Tag, Index};
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