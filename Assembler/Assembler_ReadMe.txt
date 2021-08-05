----------------------------------------------------------------------------------------------------
Every Assembly code instruction should be in capital form.

CPU Registers
The registers are names x0 through x31
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
U Type
Here immidate value should be given in 5  bit hexadecimal format
Ex 
LUI x20 0xAA024
----------------------------------------------------------------------------------------------------

J Type
Here immidate value should be given in 5  bit hexadecimal format
Ex 
JAL x13,0xAA024
----------------------------------------------------------------------------------------------------
R Type
Ex 
ADD x13,x20,x11
----------------------------------------------------------------------------------------------------
I Type
Here I type instructions can be given in two formats,immidate value should be given in 3 bits hexadecimal format.
EX
ANDI x2,x10,0xF23

LB x3,0xF23(x6)
----------------------------------------------------------------------------------------------------

S Type
Immidate value should be given in 3 bits hexadecimal format.

SB x3,0xF23(x6)

----------------------------------------------------------------------------------------------------

B Type
Immidate value should be given in 3 bits hexadecimal format.
BEQ x4,x5,0x004

----------------------------------------------------------------------------------------------------
