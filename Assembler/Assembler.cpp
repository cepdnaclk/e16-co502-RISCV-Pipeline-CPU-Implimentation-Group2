#include <iostream>
#include <string>



using namespace std;


string getRegisterValue(string);
string hexaToBinaryConverter(string ,int);
string getRtypeinstruction(string ,string ,string ,string);
string getItypeinstruction(string ,string ,string,string);
string getStypeinstruction(string ,string ,string ,string);
string getUtypeinstruction(string ,string,string);
string getJtypeinstruction(string ,string );



int main(int argc, char const *argv[])
{
    cout<< hexaToBinaryConverter("0xF2",2);
    // cout<< getRegisterValue("x13");;
    return 0;
}

string getJtypeinstruction(string rd,string imm){
    string binary_imm=hexaToBinaryConverter(imm,5);
    string instruction=binary_imm[0]+binary_imm.substr(10,10)+binary_imm[9]+binary_imm.substr(1,8)+getRegisterValue(rd)+"1101111";
    return instruction;
}

string getUtypeinstruction(string instype,string rd,string imm){
    string instruction=hexaToBinaryConverter(imm,5)+getRegisterValue(rd);
    if (!instype.compare("LUI"))
    {
        instruction=instruction+"0110111";
    }
    else if (!instype.compare("AUIPC"))
    {
        instruction=instruction+"0010111";
    }
    else
    {
        return NULL;
    }
    
    return instruction;
}

string getBtypeinstruction(string instype,string rs2,string rs1,string imm){

    string binary_imm=hexaToBinaryConverter(imm,3);
    string instruction=binary_imm.substr(8,4)+binary_imm[1]+"1100011";     

    if (!instype.compare("BEQ"))
    {
        instruction=binary_imm[0]+binary_imm.substr(2,6)+getRegisterValue(rs2)+getRegisterValue(rs1)+"000"+instruction;
    }
    else if (!instype.compare("BNE"))
    {
        instruction=binary_imm[0]+binary_imm.substr(2,6)+getRegisterValue(rs2)+getRegisterValue(rs1)+"001"+instruction;
    }
    else if (!instype.compare("BLT"))
    {
        instruction=binary_imm[0]+binary_imm.substr(2,6)+getRegisterValue(rs2)+getRegisterValue(rs1)+"100"+instruction;
    }
    else if (!instype.compare("BGE"))
    {
        instruction=binary_imm[0]+binary_imm.substr(2,6)+getRegisterValue(rs2)+getRegisterValue(rs1)+"101"+instruction;
    }
    else if (!instype.compare("BLTU"))
    {
        instruction=binary_imm[0]+binary_imm.substr(2,6)+getRegisterValue(rs2)+getRegisterValue(rs1)+"110"+instruction;
    }
    else if (!instype.compare("BGEU"))
    {
        instruction=binary_imm[0]+binary_imm.substr(2,6)+getRegisterValue(rs2)+getRegisterValue(rs1)+"111"+instruction;
    }else{
        return NULL;
    }
    return instruction;
}

string getStypeinstruction(string instype,string rs2,string rs1,string imm){

    string binary_imm=hexaToBinaryConverter(imm,3);
    string instruction=binary_imm.substr(7,5)+"0100011";     

    if (!instype.compare("SB"))
    {
        instruction=binary_imm.substr(0,7)+getRegisterValue(rs2)+getRegisterValue(rs1)+"000"+instruction;
    }
    else if (!instype.compare("SH"))
    {
        instruction=binary_imm.substr(0,7)+getRegisterValue(rs2)+getRegisterValue(rs1)+"001"+instruction;
    }
    else if (!instype.compare("SW"))
    {
        instruction=binary_imm.substr(0,7)+getRegisterValue(rs2)+getRegisterValue(rs1)+"010"+instruction;
    }
    else
    {
        return NULL;
    }

    return instruction;
}

string getItypeinstruction(string instype,string rs1,string imm,string rd){

    string instruction=getRegisterValue(rd)+"0010011";

    if (!instype.compare("ADDI"))
    {
        instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"000"+instruction;
    }
    else if (!instype.compare("ANDI"))
    {
        instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"111"+instruction;
    }
    else if (!instype.compare("ORI"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"110"+instruction;
    }
    else if (!instype.compare("SLLI"))
    {
        instruction="0000000"+hexaToBinaryConverter(imm,2).substr(3,5)+getRegisterValue(rs1)+"001"+instruction;
    }
    else if (!instype.compare("SLTI"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"010"+instruction;
    }
    else if (!instype.compare("SLTIU"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"011"+instruction;
    }
    else if (!instype.compare("SRAI"))
    {
        instruction="0100000"+hexaToBinaryConverter(imm,2).substr(3,5)+getRegisterValue(rs1)+"101"+instruction;
    }
    else if (!instype.compare("SRLI"))
    {
        instruction="0000000"+hexaToBinaryConverter(imm,2).substr(3,5)+getRegisterValue(rs1)+"101"+instruction;
    }
    else if (!instype.compare("XORI"))
    {
        instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"100"+instruction;
    }
    else if (!instype.compare("LB"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"000"+getRegisterValue(rd)+"0000011";
    }
    else if (!instype.compare("LH"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"001"+getRegisterValue(rd)+"0000011";
    }
    else if (!instype.compare("LW"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"010"+getRegisterValue(rd)+"0000011";
    }
    else if (!instype.compare("LBU"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"100"+getRegisterValue(rd)+"0000011";
    }
    else if (!instype.compare("LHU"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"101"+getRegisterValue(rd)+"0000011";
    }
    else if (!instype.compare("JALR"))
    {
       instruction=hexaToBinaryConverter(imm,3)+getRegisterValue(rs1)+"000"+getRegisterValue(rd)+"1100111";
    }
    else{
        return NULL;
    }
    
    return instruction;
}

string getRtypeinstruction(string instype,string rs2,string rs1,string rd){
    string instruction=getRegisterValue(rd)+"0110011";
    if (!instype.compare("ADD"))
    {
        instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"000"+instruction;
    }
    else if (!instype.compare("AND"))
    {
        instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"111"+instruction;
    }
    else if (!instype.compare("OR"))
    {
       instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"110"+instruction;
    }
    else if (!instype.compare("SLL"))
    {
        instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"001"+instruction;
    }
    else if (!instype.compare("SLT"))
    {
       instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"010"+instruction;
    }
    else if (!instype.compare("SLTU"))
    {
       instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"011"+instruction;
    }
    else if (!instype.compare("SRA"))
    {
        instruction="0100000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"101"+instruction;
    }
    else if (!instype.compare("SRL"))
    {
        instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"101"+instruction;
    }
    else if (!instype.compare("SUB"))
    {
        instruction="0100000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"000"+instruction;
    }
    else if (!instype.compare("XOR"))
    {
        instruction="0000000"+getRegisterValue(rs2)+getRegisterValue(rs1)+"100"+instruction;
    }
    else{
        return NULL;
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


string hexaToBinaryConverter(string hexvalue,int noOfHexBits){
    if (!((hexvalue[0]=='0') && (hexvalue[1]=='x') && (hexvalue.length()==noOfHexBits+2)))
    {
        throw "Invalid hex value ";
    }
    
    string value;

    for (int i = 2; i < noOfHexBits+2; i++)
    {
        if (hexvalue[i]=='0')
        {
            value=value+"0000";
        }
        else if (hexvalue[i]=='1')
        {
            value=value+"0001";
        }
        else if (hexvalue[i]=='2')
        {
            value=value+"0010";
        }
        else if (hexvalue[i]=='3')
        {
            value=value+"0011";
        }
        else if (hexvalue[i]=='4')
        {
            value=value+"0100";
        }
        else if (hexvalue[i]=='5')
        {
            value=value+"0101";
        }
        else if (hexvalue[i]=='6')
        {
            value=value+"0110";
        }
        else if (hexvalue[i]=='7')
        {
            value=value+"0111";
        }
        else if (hexvalue[i]=='8')
        {
            value=value+"1000";
        }
        else if (hexvalue[i]=='9')
        {
            value=value+"1001";
        }
        else if (hexvalue[i]=='A')
        {
            value=value+"1010";
        }
        else if (hexvalue[i]=='B')
        {
            value=value+"1011";
        }
        else if (hexvalue[i]=='C')
        {
            value=value+"1100";
        }
        else if (hexvalue[i]=='D')
        {
            value=value+"1101";
        }
        else if (hexvalue[i]=='E')
        {
            value=value+"1110";
        }
        else if (hexvalue[i]=='F')
        {
            value=value+"1111";
        }
        else
        {
            throw "Invalid hex value ";
        }
        
    }
    return value;
}
