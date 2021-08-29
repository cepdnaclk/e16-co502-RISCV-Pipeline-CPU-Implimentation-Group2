`timescale  1ns/100ps

module Branch_hazard_unit (
    ID_pc,ALU_pc,
    reset,
    ID_stage_branch,
    ALU_stage_branch,
    ALU_stage_branch_result,
    flush,
    early_prediction_is_branch_taken,
    signal_to_take_branch
);

input [2:0] ID_pc,ALU_pc;
input reset,ID_stage_branch,ALU_stage_branch,ALU_stage_branch_result;
output reg flush,early_prediction_is_branch_taken,signal_to_take_branch;
reg  [1:0] prediction[0:7];                 //branch target buffer


parameter BRANCH_TAKEN_strong = 2'b00, BRANCH_TAKEN_weak =2'b01, BRANCH_NOTTAKEN_weak =2'b10, BRANCH_NOTTAKEN_strong =2'b11;
integer i;
always @(reset) begin
    flush=1'b0;
    for (i =0 ;i<8 ;i++ ) begin
        prediction[i]=2'b00;
    end
end

//checking weather the prediction is correct
always @(*) begin
    if (ALU_stage_branch) begin    //"branch control signal" getting from alu to check wether our prediction is correct
        case (prediction[ALU_pc])
            BRANCH_TAKEN_strong:
                if (ALU_stage_branch_result) begin
                    prediction[ALU_pc]=2'b00;
                    flush=1'b0;
                end
                else begin
                    prediction[ALU_pc]=2'b01;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b1;       // pc should be given pc+4 value that got from alu stage
                end
            BRANCH_TAKEN_weak:
                if (ALU_stage_branch_result) begin
                    prediction[ALU_pc]=2'b00;
                    flush=1'b0;
                end
                else begin
                    prediction[ALU_pc]=2'b10;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b1;
                end
            BRANCH_NOTTAKEN_weak:
                if (ALU_stage_branch_result) begin
                    prediction[ALU_pc]=2'b01;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b0;      // pc should be given the (b_imm + pc) from ALU stage(ALU stage should have the calculaed value from the dedicated adder)
                end
                else begin
                    prediction[ALU_pc]=2'b11;
                    flush=1'b0;
                end
            BRANCH_NOTTAKEN_strong:
                if (ALU_stage_branch_result) begin
                    prediction[ALU_pc]=2'b10;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b0;
                end
                else begin
                    prediction[ALU_pc]=2'b11;
                    flush=1'b0;
                end
        endcase   
    end
    else begin
        flush = 1'b0;
    end

    
end

//prediction
always @(*) begin
    if (ID_stage_branch) begin
        case (prediction[ID_pc])
            BRANCH_TAKEN_strong:
                signal_to_take_branch=1'b1;   //when this signal is set to 1 (i) update pc with the calculated value from the adder in ID stage (ii) flush the pipeline reg 1
            BRANCH_TAKEN_weak:
                signal_to_take_branch=1'b1;
            BRANCH_NOTTAKEN_weak:
                signal_to_take_branch=1'b0;   //when this signal is set to 0, no problem regular operation happen in pc
            BRANCH_NOTTAKEN_strong:
                signal_to_take_branch=1'b0;
        endcase   
    end
    else begin
        signal_to_take_branch=1'b0;
    end
end
    
endmodule