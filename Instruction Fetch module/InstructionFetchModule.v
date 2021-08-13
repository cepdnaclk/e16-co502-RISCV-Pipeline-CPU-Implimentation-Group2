`timescale  1ns/100ps

module InstructionfetchModule (
    CLK,
    RESET,
    instruction_mem_busywait,
    data_mem_busywait,
    jump_branch_signal,
    PC,
    INCREMENTED_PC_by_four,
    Jump_Branch_PC
);

output reg [31:0] PC,INCREMENTED_PC_by_four;
input wire CLK,RESET,instruction_mem_busywait,data_mem_busywait,jump_branch_signal;
input wire [31:0] Jump_Branch_PC;

wire busywait;



// busywait signal enable whenever data memmory busywait or instruction memory busywait enables
or(busywait,instruction_mem_busywait,data_mem_busywait);


always @(RESET) begin //set the pc value depend on the RESET to start the programme
    PC= -4;
end

// incrementing PC by 4 to get next PC value
always @(PC) begin
    #2                              //adder delay
    INCREMENTED_PC_by_four=PC+4;
end


always @(posedge CLK) begin //update the pc value depend on the positive clock edge
    #2                         //!delay updated because PC wont update as soon as busywait zeroed
    if(busywait == 1'b0)begin //update the pc when only busywait is zero 
        case (jump_branch_signal)
            1'b1:begin
                PC=Jump_Branch_PC;
            end
            1'b0:begin
                PC=INCREMENTED_PC_by_four;
            end
        endcase
    end
end  
    
endmodule