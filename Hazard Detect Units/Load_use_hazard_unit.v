`timescale  1ns/100ps

module Load_use_hazard_unit (
    clk,
    reset,
    load_signal,
    Memstage_Rd,
    // IFstage_Rs1,
    // IFstage_Rs2,
    ALustage_Rs1,
    ALustage_Rs2,
    enable_rs1_forward_from_wb,
    enable_rs2_forward_from_wb,
    enable_bubble
);

input clk,reset,load_signal;
input [4:0] Memstage_Rd,IFstage_Rs1,IFstage_Rs2,ALustage_Rs1,ALustage_Rs2;

output reg enable_rs1_forward_from_wb,enable_rs2_forward_from_wb,enable_bubble;

wire [4:0] if_rs1_xnor_wire,if_rs2_xnor_wire,alu_rs1_xnor_wire,alu_rs2_xnor_wire;
wire if_rs_1comparing,if_rs_2comparing,alu_rs1comparing,alu_rs2comparing,buble;

// Has to remove this part additional beacuse alu hazard unit also cover
// assign #1 if_rs2_xnor_wire=(Memstage_Rd~^IFstage_Rs2);
// assign #1 if_rs1_xnor_wire=(Memstage_Rd~^IFstage_Rs1);
// assign #1 if_rs_1comparing= (&if_rs1_xnor_wire);   
// assign #1 if_rs_2comparing= (&if_rs2_xnor_wire);

//hazard detection (check wether sourse registers and destination registers are equal)
assign #1 alu_rs1_xnor_wire=(Memstage_Rd~^ALustage_Rs1);   //xnoring
assign #1 alu_rs2_xnor_wire=(Memstage_Rd~^ALustage_Rs2);   //xnoring
assign #1 alu_rs1comparing= (&alu_rs1_xnor_wire);          //anding
assign #1 alu_rs2comparing= (&alu_rs2_xnor_wire);          //anding
assign #1 buble=alu_rs1comparing | alu_rs2comparing;   //bubble introduced to the pipeline(this is unavoidable)

always @(posedge clk) begin
    #1                                                //combinational logic delay
    if (load_signal) begin
        enable_rs1_forward_from_wb=alu_rs1comparing;
        enable_rs2_forward_from_wb=alu_rs2comparing;
        enable_bubble=buble;
    end
    else begin
        enable_rs1_forward_from_wb=1'b0;
        enable_rs2_forward_from_wb=1'b0;
        enable_bubble=1'b0;    
    end
    
end

always @(reset) begin
    if (reset) begin
        enable_rs1_forward_from_wb=1'b0;
        enable_rs2_forward_from_wb=1'b0;
        enable_bubble=1'b0;
    end
end
endmodule