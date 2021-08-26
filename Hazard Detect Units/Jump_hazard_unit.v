module Jump_hazard_unit (
    jump,
    flush
);

input jump;
output reg flush;
always @(*) begin
    if (jump) begin
        flush=1'b1; 
    end else begin
        flush=1'b0; 
    end
end
    
endmodule