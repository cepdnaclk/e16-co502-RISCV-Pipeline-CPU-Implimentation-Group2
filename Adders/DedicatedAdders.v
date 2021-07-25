//dedicated adder to ADD PC to Branch immidiate to resolve branch address

module adder(IN_1,IN_2,OUT);   
input[31:0] IN_1;
input[31:0] IN_2;
output[31:0] OUT;
reg OUT;
always@(*)begin
#2                                                  //adder delay
OUT = IN_1+IN_2;
end
endmodule

