//       ######### Data refine module  ##########

/* This module is an asynchronous module which do modifications to the data memory outputs
    according to the instruction   */

module Data_ref_module (
    func3,
    data_mem_in,
    data_ref_out,
    to_data_memory,
    DATA2
);
input [2:0] func3;
input [31:0] data_mem_in,DATA2;
output reg [31:0] data_ref_out,to_data_memory;
wire [31:0] lb,lbu,lh,lhu;

wire [31:0] sh,sb;

assign lb ={{24{data_mem_in[7]}},data_mem_in[7:0]};
assign lbu ={{24{1'b0}},data_mem_in[7:0]};
assign lh ={{16{data_mem_in[15]}},data_mem_in[15:0]};
assign lhu ={{16{1'b0}},data_mem_in[15:0]};


assign sb ={{24{1'b0}},DATA2[7:0]};
assign sh ={{16{1'b0}},DATA2[15:0]};

//block which check which data that should be stored in the cache memory
reg[31:0] writeData;
always @(*)begin
    case(func3)
        3'b000: begin    //store byte
            to_data_memory <= sb;
        end
        3'b001: begin   //store half word
            to_data_memory <= sh;
        end
        3'b010:begin       //store full word
            to_data_memory <= DATA2;
        end
        endcase
end

always @(*) begin
    case(func3)
        3'b000:begin
            data_ref_out<=lb;
        end
        3'b001:begin
            data_ref_out<=lh;
        end
        3'b010:begin
            data_ref_out<=data_mem_in;
        end
        3'b100:begin
            data_ref_out<=lbu;
        end
        3'b101:begin
            data_ref_out<=lhu;
        end
    endcase
end
endmodule