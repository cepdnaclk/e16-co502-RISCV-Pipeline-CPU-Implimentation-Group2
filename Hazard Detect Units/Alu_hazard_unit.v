module Alu_hazard_unit (
    clk,
    destination_address,
    rs1_address_alu_stage,
    rs2_address_alu_stage,
    rs1_address_mem_stage,
    rs2_address_mem_stage,
    forward_enable_from_mem_stage_signal,
    forward_enable_from_wb_stage_signal
);

input clk;
input [4:0]rs1_address_alu_stage,rs2_address_alu_stage,rs1_address_mem_stage,rs2_address_mem_stage,destination_address;

output reg forward_enable_from_mem_stage_signal,forward_enable_from_wb_stage_signal;

wire [4:0] alu_xnor_wire,mem_xnor_wire;
wire alu_comparing,mem_comparing;


assign alu_xnor_wire=(rs1_address_alu_stage~^rs2_address_alu_stage);
assign alu_comparing= (&alu_xnor_wire);   

assign mem_xnor_wire=(rs1_address_mem_stage~^rs2_address_mem_stage);
assign mem_comparing= (&mem_xnor_wire);

always @(posedge clk) begin
    forward_enable_from_mem_stage_signal=alu_comparing;
    forward_enable_from_wb_stage_signal=mem_comparing;
end

    
endmodule