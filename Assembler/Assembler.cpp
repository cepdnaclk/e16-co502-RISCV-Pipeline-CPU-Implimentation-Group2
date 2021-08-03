#include <iostream>
#include <string>



using namespace std;


string getRegisterValue(string);

int main(int argc, char const *argv[])
{
    cout<< getRegisterValue("x13");;
    return 0;
}

string getRtypeinstype(string instype,string rs2,string rs1,string rd){
    string instruction=getRegisterValue(rd)+"0110011";
    if (instype.compare("ADD"))
    {
        instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"000"+instruction;
    }
    else if (instype.compare("AND"))
    {
        instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"111"+instruction;
    }
    else if (instype.compare("OR"))
    {
       instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"110"+instruction;
    }
    else if (instype.compare("SLL"))
    {
        instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"001"+instruction;
    }
    else if (instype.compare("SLT"))
    {
       instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"010"+instruction;
    }
    else if (instype.compare("SLTU"))
    {
       instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"011"+instruction;
    }
    else if (instype.compare("SRA"))
    {
        instruction="0100000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"101"+instruction;
    }
    else if (instype.compare("SRL"))
    {
        instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"101"+instruction;
    }
    else if (instype.compare("SUB"))
    {
        instruction="0100000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"000"+instruction;
    }
    else if (instype.compare("XOR"))
    {
        instruction="0000000"+getRegisterValue(rs1)+getRegisterValue(rs1)+"100"+instruction;
    }
    
    return instruction;
}

string getRegisterValue(string reg){
    for (unsigned char i = 0; i < 32; i++)
    {
        string comparedReg="x"+to_string(i);
        if (!reg.compare(comparedReg))
        {
            string value;
            for (int bit = 0; bit < 5; bit++)
            {
                if ((i>>bit)&1==1)
                {
                    value="1"+value;
                }else{
                    value="0"+value;
                }
                
            }
            return value;
        }
    }
    throw "Invalid Register value";    
}

