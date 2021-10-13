`timescale  1ns/100ps

module Alu_hazard_unit (
    clk,
    reset,
    destination_address_mem_stage,
    destination_address_alu_stage,
    rs1_address_id_stage,
    rs2_address_id_stage,
    forward_enable_to_rs1_from_mem_stage_signal,
    forward_enable_to_rs2_from_mem_stage_signal,
    forward_enable_to_rs1_from_wb_stage_signal,
    forward_enable_to_rs2_from_wb_stage_signal
);

input clk,reset;
input [4:0]    destination_address_mem_stage,destination_address_alu_stage,rs1_address_id_stage,rs2_address_id_stage;

output reg forward_enable_to_rs1_from_mem_stage_signal,forward_enable_to_rs2_from_mem_stage_signal,forward_enable_to_rs1_from_wb_stage_signal,forward_enable_to_rs2_from_wb_stage_signal;

wire [4:0] alu_rs1_xnor_wire,alu_rs2_xnor_wire,mem_rs1_xnor_wire,mem_rs2_xnor_wire;
wire alu_rs_1comparing,alu_rs_2comparing,mem_rs1comparing,mem_rs2comparing;


// comparing destination address and sourse register address to identify hazards(alu stage with instruction decode stage)
assign #1 alu_rs1_xnor_wire=(destination_address_alu_stage~^rs1_address_id_stage);    //bitwise xnoring
assign #1 alu_rs2_xnor_wire=(destination_address_alu_stage~^rs2_address_id_stage);    //bit wise xnoring
assign #1 alu_rs_1comparing= (&alu_rs1_xnor_wire);                                    //all bits are anding
assign #1 alu_rs_2comparing= (&alu_rs2_xnor_wire);                                    //all bits anding

// comparing destination address and sourse register address to identify hazards(mem stage with instruction decode stage)
assign #1 mem_rs1_xnor_wire=(destination_address_mem_stage~^rs1_address_id_stage);    //bitwise xnoring
assign #1 mem_rs2_xnor_wire=(destination_address_mem_stage~^rs2_address_id_stage);    //bit wise xnoring
assign #1 mem_rs1comparing= (&mem_rs1_xnor_wire);                                     //all bits are anding
assign #1 mem_rs2comparing= (&mem_rs2_xnor_wire);                                     //all bits anding


always @(posedge clk) begin
    #1                                                               //delay occured by combinational logic

    //setting relevent outputs
    forward_enable_to_rs1_from_mem_stage_signal=alu_rs_1comparing;
    forward_enable_to_rs2_from_mem_stage_signal=alu_rs_2comparing;
    forward_enable_to_rs1_from_wb_stage_signal=mem_rs1comparing;
    forward_enable_to_rs2_from_wb_stage_signal=mem_rs2comparing;
end

always @(reset) begin
	if(reset==1'b1) begin
        #1                                                          //reset delay
        //when reset all outputs set to zero allowing normal functionality in the pipeline
        forward_enable_to_rs1_from_mem_stage_signal=1'b0;
        forward_enable_to_rs2_from_mem_stage_signal=1'b0;
        forward_enable_to_rs1_from_wb_stage_signal=1'b0;
        forward_enable_to_rs2_from_wb_stage_signal=1'b0;	                        
	end
end

    
endmodule