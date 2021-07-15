`timescale  1ns/100ps
module comparator(IN1,IN2,OUT);
input[0:2] IN1,IN2;
output OUT;

assign #0.9 OUT = IN1[0]~^IN2[0] && IN1[1]~^IN2[1] && IN1[2]~^IN2[2];   //xnor each bit and did and operation 
endmodule