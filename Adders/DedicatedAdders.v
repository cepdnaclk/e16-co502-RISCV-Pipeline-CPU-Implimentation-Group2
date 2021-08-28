//dedicated adder to ADD PC to Branch immidiate to resolve branch address
`timescale  1ns/100ps

module adder(IN_1,IN_2,OUT);   
input[31:0] IN_1;
input[31:0] IN_2;
output reg[31:0] OUT;
always@(*)begin
#2                                                  //adder delay
OUT = IN_1+IN_2;
end
endmodule

//dedicated adder to ADD +4 to PC

// module adder_type2(IN_1,OUT);   
// input[31:0] IN_1;
// output[31:0] OUT;
// reg OUT;
// always@(*)begin
// #2                                                  //adder delay
// OUT = IN_1+ 4;
// end
// endmodule

