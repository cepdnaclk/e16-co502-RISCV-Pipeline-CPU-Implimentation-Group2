module Branch_hazard_unit (
    pc,
    reset,
    ID_stage_branch,
    ALU_stage_branch,
    ALU_stage_branch_result,
    flush,
    early_prediction_is_branch_taken,
    signal_to_take_branch,
);

input [31:0] pc;
input reset,ID_stage_branch,ALU_stage_branch,ALU_stage_branch_result;
output flush,early_prediction_is_branch_taken,signal_to_take_branch;
reg  [1:0] prediction[0:7];


parameter BRANCH_TAKEN_1 = 2'b00,BRANCH_TAKEN_2=2'b01,BRANCH_NOTTAKEN_1=2'b10,BRANCH_NOTTAKEN_2=2'b11;
integer i;
always @(reset) begin
    flush=1'b0;
    for (i =0 ;i<8 ;i++ ) begin
        prediction[i]=2'b00;
    end
end

always @(*) begin
    if (ALU_stage_branch) begin
        case (prediction[pc[2:0]])
            BRANCH_TAKEN_1:
                if (ALU_stage_branch_result) begin
                    prediction[pc[2:0]]=2'b00;
                    flush=1'b0;
                end
                else begin
                    prediction[pc[2:0]]=2'b01;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b1;
                end
            BRANCH_TAKEN_2:
                if (ALU_stage_branch_result) begin
                    prediction[pc[2:0]]=2'b00;
                    flush=1'b0;
                end
                else begin
                    prediction[pc[2:0]]=2'b10;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b1;
                end
            BRANCH_NOTTAKEN_1:
                if (ALU_stage_branch_result) begin
                    prediction[pc[2:0]]=2'b01;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b0;
                end
                else begin
                    prediction[pc[2:0]]=2'b11;
                    flush=1'b0;
                end
            BRANCH_NOTTAKEN_2:
                if (ALU_stage_branch_result) begin
                    prediction[pc[2:0]]=2'b10;
                    flush=1'b1;
                    early_prediction_is_branch_taken=1'b0;
                end
                else begin
                    prediction[pc[2:0]]=2'b11;
                    flush=1'b0;
                end
        endcase   
    end

    
end

always @(*) begin
    if (ID_stage_branch) begin
        case (prediction[pc[2:0]])
            BRANCH_TAKEN_1:
                signal_to_take_branch=1'b1;
            BRANCH_TAKEN_2:
                signal_to_take_branch=1'b1;
            BRANCH_NOTTAKEN_1:
                signal_to_take_branch=1'b0;
            BRANCH_NOTTAKEN_2:
                signal_to_take_branch=1'b0;
        endcase   
    end
    else begin
        signal_to_take_branch=1'b0;
    end
end
    
endmodule