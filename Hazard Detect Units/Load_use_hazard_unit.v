module Load_use_hazard_unit (
    clk,
    reset,
    Memstage_Rd,
    IFstage_Rs1,
    IFstage_Rs2,
    ALustage_Rs1,
    ALustage_Rs2,
    enable_rs1_forward_from_wb,
    enable_rs2_forward_from_wb,
    enable_bubble
);

input clk,reset;
input [4:0] Memstage_Rd,IFstage_Rs1,IFstage_Rs2,ALustage_Rs1,ALustage_Rs2;

output reg enable_rs1_forward_from_wb,enable_rs2_forward_from_wb,enable_bubble;

wire [4:0] if_rs1_xnor_wire,if_rs2_xnor_wire,alu_rs1_xnor_wire,alu_rs2_xnor_wire;
wire if_rs_1comparing,if_rs_2comparing,alu_rs1comparing,alu_rs2comparing,buble;


assign if_rs1_xnor_wire=(Memstage_Rd~^IFstage_Rs1);
assign if_rs2_xnor_wire=(Memstage_Rd~^IFstage_Rs2);
assign if_rs_1comparing= (&if_rs1_xnor_wire);   
assign if_rs_2comparing= (&if_rs2_xnor_wire);

assign alu_rs1_xnor_wire=(Memstage_Rd~^ALustage_Rs1);
assign alu_rs2_xnor_wire=(Memstage_Rd~^ALustage_Rs2);
assign alu_rs1comparing= (&alu_rs1_xnor_wire);   
assign alu_rs2comparing= (&alu_rs2_xnor_wire);
assign buble=alu_rs1comparing | alu_rs_2comparing;

always @(posedge clk) begin
    enable_rs1_forward_from_wb=if_rs_1comparing|alu_rs1comparing;
    enable_rs2_forward_from_wb=if_rs_2comparing|alu_rs2comparing;
    enable_bubble=buble;
end

always @(reset) begin
    enable_rs1_forward_from_wb=0;
    enable_rs2_forward_from_wb=0;
    enable_bubble=0;
end
endmodule