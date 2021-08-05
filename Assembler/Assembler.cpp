#include <iostream>
#include <string>
#include <fstream>
#include <vector>

using namespace std;

string getRegisterValue(string);
string hexaToBinaryConverter(string, int);
string getRtypeinstruction(string, string, string, string);
string getItypeinstruction(string, string, string, string);
string getStypeinstruction(string, string, string, string);
string getUtypeinstruction(string, string, string);
string getJtypeinstruction(string, string);
string getMtypeinstruction(string, string, string, string);
string getBtypeinstruction(string, string, string, string);
bool checkDataHazard(string ,string );

int main(int argc, char const *argv[])
{
    if (!(argc == 2 || argc == 3))
    {
        cout << "Invalid Format :./a.out <path to assembly file>  <output file name(optinal)>" << endl;
    }
    ofstream writefile;

    if (argc == 3)
    {
        writefile.open(*argv[2] + ".hex");
    }
    else
    {
        writefile.open("output.hex");
    }

    ifstream readfile(argv[1]);
    string line;
    string nop="00000000000000000000000000000000";
    string prev_instruction_rd="";
    string prev_prev_instruction_rd="";
    while (getline(readfile, line))
    {
        vector<string> instruction_keys;
        size_t pos = 0;  
        string delim=" ";
        pos = line.find(delim);
        instruction_keys.push_back(line.substr(0, pos));
        line.erase(0, pos + delim.length());
        delim=",";
        pos = 0;
        while (( pos = line.find (delim)) != std::string::npos)  
        {  
            instruction_keys.push_back(line.substr(0, pos));    
            line.erase(0, pos + delim.length());   
        }
        delim="(";
        pos = 0;
        if (( pos = line.find (delim)) != std::string::npos)
        {
            string imm=line.substr(0, pos);
            line.erase(0, pos + delim.length());
            delim=")";
            pos = 0;
            pos = line.find(delim);
            instruction_keys.push_back(line.substr(0, pos));
            instruction_keys.push_back(imm);
        }else{
            instruction_keys.push_back(line);
        }

        string binary_instruction;

        if ((!instruction_keys[0].compare("LUI"))||(!instruction_keys[0].compare("AUIPC")))
        {
            binary_instruction=getUtypeinstruction(instruction_keys[0],instruction_keys[1],instruction_keys[2]);
            prev_prev_instruction_rd=prev_instruction_rd;
            prev_instruction_rd=instruction_keys[1];
            writefile<<binary_instruction<<endl;
        }
        else if (!instruction_keys[0].compare("JAL"))
        {
            binary_instruction=getJtypeinstruction(instruction_keys[0],instruction_keys[1]);
            writefile<<binary_instruction<<endl;
            writefile<<nop<<endl;
            writefile<<nop<<endl;
        }
        else if ((!instruction_keys[0].compare("MUL"))||(!instruction_keys[0].compare("MULH"))||(!instruction_keys[0].compare("MULHSU"))||(!instruction_keys[0].compare("MULHU"))||(!instruction_keys[0].compare("DIV"))||(!instruction_keys[0].compare("DIVU"))||(!instruction_keys[0].compare("REM"))||(!instruction_keys[0].compare("REMU")))
        {
            binary_instruction=getMtypeinstruction(instruction_keys[0],instruction_keys[3],instruction_keys[2],instruction_keys[1]);
            if (checkDataHazard(instruction_keys[3],prev_prev_instruction_rd)||checkDataHazard(instruction_keys[2],prev_prev_instruction_rd))
            {
                writefile<<nop<<endl;
            }
            else if (checkDataHazard(instruction_keys[3],prev_instruction_rd)||checkDataHazard(instruction_keys[2],prev_instruction_rd))
            {
                writefile<<nop<<endl;
                writefile<<nop<<endl;
            }
            prev_prev_instruction_rd=prev_instruction_rd;
            prev_instruction_rd=instruction_keys[1];
            writefile<<binary_instruction<<endl;
            
        }
        else if ((!instruction_keys[0].compare("AND"))||(!instruction_keys[0].compare("ADD"))||(!instruction_keys[0].compare("OR"))||(!instruction_keys[0].compare("SLL"))||(!instruction_keys[0].compare("SLT"))||(!instruction_keys[0].compare("SLTUU"))||(!instruction_keys[0].compare("SRA"))||(!instruction_keys[0].compare("SRL"))||(!instruction_keys[0].compare("SUB"))||(!instruction_keys[0].compare("XOR")))
        {
            binary_instruction=getRtypeinstruction(instruction_keys[0],instruction_keys[3],instruction_keys[2],instruction_keys[1]);
            if (checkDataHazard(instruction_keys[3],prev_prev_instruction_rd)||checkDataHazard(instruction_keys[2],prev_prev_instruction_rd))
            {
                writefile<<nop<<endl;
            }
            else if (checkDataHazard(instruction_keys[3],prev_instruction_rd)||checkDataHazard(instruction_keys[2],prev_instruction_rd))
            {
                writefile<<nop<<endl;
                writefile<<nop<<endl;
            }
            prev_prev_instruction_rd=prev_instruction_rd;
            prev_instruction_rd=instruction_keys[1];
            writefile<<binary_instruction<<endl;
        }
        else if ((!instruction_keys[0].compare("SB"))||(!instruction_keys[0].compare("SH"))||(!instruction_keys[0].compare("SW")))
        {
            binary_instruction=getStypeinstruction(instruction_keys[0],instruction_keys[1],instruction_keys[2],instruction_keys[3]);
            if (checkDataHazard(instruction_keys[1],prev_prev_instruction_rd)||checkDataHazard(instruction_keys[2],prev_prev_instruction_rd))
            {
                writefile<<nop<<endl;
            }
            else if (checkDataHazard(instruction_keys[1],prev_instruction_rd)||checkDataHazard(instruction_keys[2],prev_instruction_rd))
            {
                writefile<<nop<<endl;
                writefile<<nop<<endl;
            }
            writefile<<binary_instruction<<endl;
        }
        else if ((!instruction_keys[0].compare("BEQ"))||(!instruction_keys[0].compare("BGE"))||(!instruction_keys[0].compare("BGEU"))||(!instruction_keys[0].compare("BLT"))||(!instruction_keys[0].compare("BLTU"))||(!instruction_keys[0].compare("BNE")))
        {
            binary_instruction=getBtypeinstruction(instruction_keys[0],instruction_keys[2],instruction_keys[1],instruction_keys[3]);
            writefile<<binary_instruction<<endl;
            writefile<<nop<<endl;
            writefile<<nop<<endl;
        }
        else{
            binary_instruction=getItypeinstruction(instruction_keys[0],instruction_keys[2],instruction_keys[3],instruction_keys[1]);
            if (binary_instruction.empty())
            {
                throw "Invalid instruction";
            }
            if (checkDataHazard(instruction_keys[2],prev_prev_instruction_rd))
            {
                writefile<<nop<<endl;
            }
            else if (checkDataHazard(instruction_keys[2],prev_instruction_rd))
            {
                writefile<<nop<<endl;
                writefile<<nop<<endl;
            }
            prev_prev_instruction_rd=prev_instruction_rd;
            prev_instruction_rd=instruction_keys[1];
            writefile<<binary_instruction<<endl;
        }
        
    }

    readfile.close();
    writefile.close();
    return 0;
}

bool checkDataHazard(string rs,string rd){
    if (!rs.compare(rd))
    {
        return true;
    }
    return false; 
}

string getMtypeinstruction(string instype, string rs2, string rs1, string rd)
{
    string instruction = getRegisterValue(rd) + "0110011";
    string prepart = "0000001" + getRegisterValue(rs2) + getRegisterValue(rs1);
    if (!instype.compare("MUL"))
    {
        instruction = prepart + "000" + instruction;
    }
    else if (!instype.compare("MULH"))
    {
        instruction = prepart + "001" + instruction;
    }
    else if (!instype.compare("MULHSU"))
    {
        instruction = prepart + "010" + instruction;
    }
    else if (!instype.compare("MULHU"))
    {
        instruction = prepart + "011" + instruction;
    }
    else if (!instype.compare("DIV"))
    {
        instruction = prepart + "100" + instruction;
    }
    else if (!instype.compare("DIVU"))
    {
        instruction = prepart + "101" + instruction;
    }
    else if (!instype.compare("REM"))
    {
        instruction = prepart + "110" + instruction;
    }
    else if (!instype.compare("REMU"))
    {
        instruction = prepart + "111" + instruction;
    }
    else
    {
        return "";
    }

    return instruction;
}

string getJtypeinstruction(string rd, string imm)
{
    string binary_imm = hexaToBinaryConverter(imm, 5);
    string instruction = binary_imm[0] + binary_imm.substr(10, 10) + binary_imm[9] + binary_imm.substr(1, 8) + getRegisterValue(rd) + "1101111";
    return instruction;
}

string getUtypeinstruction(string instype, string rd, string imm)
{
    string instruction = hexaToBinaryConverter(imm, 5) + getRegisterValue(rd);
    if (!instype.compare("LUI"))
    {
        instruction = instruction + "0110111";
    }
    else if (!instype.compare("AUIPC"))
    {
        instruction = instruction + "0010111";
    }
    else
    {
        return "";
    }

    return instruction;
}

string getBtypeinstruction(string instype, string rs2, string rs1, string imm)
{

    string binary_imm = hexaToBinaryConverter(imm, 3);
    string instruction = binary_imm.substr(8, 4) + binary_imm[1] + "1100011";

    if (!instype.compare("BEQ"))
    {
        instruction = binary_imm[0] + binary_imm.substr(2, 6) + getRegisterValue(rs2) + getRegisterValue(rs1) + "000" + instruction;
    }
    else if (!instype.compare("BNE"))
    {
        instruction = binary_imm[0] + binary_imm.substr(2, 6) + getRegisterValue(rs2) + getRegisterValue(rs1) + "001" + instruction;
    }
    else if (!instype.compare("BLT"))
    {
        instruction = binary_imm[0] + binary_imm.substr(2, 6) + getRegisterValue(rs2) + getRegisterValue(rs1) + "100" + instruction;
    }
    else if (!instype.compare("BGE"))
    {
        instruction = binary_imm[0] + binary_imm.substr(2, 6) + getRegisterValue(rs2) + getRegisterValue(rs1) + "101" + instruction;
    }
    else if (!instype.compare("BLTU"))
    {
        instruction = binary_imm[0] + binary_imm.substr(2, 6) + getRegisterValue(rs2) + getRegisterValue(rs1) + "110" + instruction;
    }
    else if (!instype.compare("BGEU"))
    {
        instruction = binary_imm[0] + binary_imm.substr(2, 6) + getRegisterValue(rs2) + getRegisterValue(rs1) + "111" + instruction;
    }
    else
    {
        return "";
    }
    return instruction;
}

string getStypeinstruction(string instype, string rs2, string rs1, string imm)
{

    string binary_imm = hexaToBinaryConverter(imm, 3);
    string instruction = binary_imm.substr(7, 5) + "0100011";

    if (!instype.compare("SB"))
    {
        instruction = binary_imm.substr(0, 7) + getRegisterValue(rs2) + getRegisterValue(rs1) + "000" + instruction;
    }
    else if (!instype.compare("SH"))
    {
        instruction = binary_imm.substr(0, 7) + getRegisterValue(rs2) + getRegisterValue(rs1) + "001" + instruction;
    }
    else if (!instype.compare("SW"))
    {
        instruction = binary_imm.substr(0, 7) + getRegisterValue(rs2) + getRegisterValue(rs1) + "010" + instruction;
    }
    else
    {
        return "";
    }

    return instruction;
}

string getItypeinstruction(string instype, string rs1, string imm, string rd)
{

    string instruction = getRegisterValue(rd) + "0010011";

    if (!instype.compare("ADDI"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "000" + instruction;
    }
    else if (!instype.compare("ANDI"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "111" + instruction;
    }
    else if (!instype.compare("ORI"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "110" + instruction;
    }
    else if (!instype.compare("SLLI"))
    {
        instruction = "0000000" + hexaToBinaryConverter(imm, 2).substr(3, 5) + getRegisterValue(rs1) + "001" + instruction;
    }
    else if (!instype.compare("SLTI"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "010" + instruction;
    }
    else if (!instype.compare("SLTIU"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "011" + instruction;
    }
    else if (!instype.compare("SRAI"))
    {
        instruction = "0100000" + hexaToBinaryConverter(imm, 2).substr(3, 5) + getRegisterValue(rs1) + "101" + instruction;
    }
    else if (!instype.compare("SRLI"))
    {
        instruction = "0000000" + hexaToBinaryConverter(imm, 2).substr(3, 5) + getRegisterValue(rs1) + "101" + instruction;
    }
    else if (!instype.compare("XORI"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "100" + instruction;
    }
    else if (!instype.compare("LB"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "000" + getRegisterValue(rd) + "0000011";
    }
    else if (!instype.compare("LH"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "001" + getRegisterValue(rd) + "0000011";
    }
    else if (!instype.compare("LW"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "010" + getRegisterValue(rd) + "0000011";
    }
    else if (!instype.compare("LBU"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "100" + getRegisterValue(rd) + "0000011";
    }
    else if (!instype.compare("LHU"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "101" + getRegisterValue(rd) + "0000011";
    }
    else if (!instype.compare("JALR"))
    {
        instruction = hexaToBinaryConverter(imm, 3) + getRegisterValue(rs1) + "000" + getRegisterValue(rd) + "1100111";
    }
    else
    {
        return "";
    }

    return instruction;
}

string getRtypeinstruction(string instype, string rs2, string rs1, string rd)
{
    string instruction = getRegisterValue(rd) + "0110011";
    if (!instype.compare("ADD"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "000" + instruction;
    }
    else if (!instype.compare("AND"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "111" + instruction;
    }
    else if (!instype.compare("OR"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "110" + instruction;
    }
    else if (!instype.compare("SLL"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "001" + instruction;
    }
    else if (!instype.compare("SLT"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "010" + instruction;
    }
    else if (!instype.compare("SLTU"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "011" + instruction;
    }
    else if (!instype.compare("SRA"))
    {
        instruction = "0100000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "101" + instruction;
    }
    else if (!instype.compare("SRL"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "101" + instruction;
    }
    else if (!instype.compare("SUB"))
    {
        instruction = "0100000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "000" + instruction;
    }
    else if (!instype.compare("XOR"))
    {
        instruction = "0000000" + getRegisterValue(rs2) + getRegisterValue(rs1) + "100" + instruction;
    }
    else
    {
        return "";
    }

    return instruction;
}

string getRegisterValue(string reg)
{
    for (unsigned char i = 0; i < 32; i++)
    {
        string comparedReg = "x" + to_string(i);
        if (!reg.compare(comparedReg))
        {
            string value;
            for (int bit = 0; bit < 5; bit++)
            {
                if ((i >> bit) & 1 == 1)
                {
                    value = "1" + value;
                }
                else
                {
                    value = "0" + value;
                }
            }
            return value;
        }
    }
    throw "Invalid Register value";
}

string hexaToBinaryConverter(string hexvalue, int noOfHexBits)
{
    if (!((hexvalue[0] == '0') && (hexvalue[1] == 'x') && (hexvalue.length() == noOfHexBits + 2)))
    {
        throw "Invalid hex value ";
    }

    string value;

    for (int i = 2; i < noOfHexBits + 2; i++)
    {
        if (hexvalue[i] == '0')
        {
            value = value + "0000";
        }
        else if (hexvalue[i] == '1')
        {
            value = value + "0001";
        }
        else if (hexvalue[i] == '2')
        {
            value = value + "0010";
        }
        else if (hexvalue[i] == '3')
        {
            value = value + "0011";
        }
        else if (hexvalue[i] == '4')
        {
            value = value + "0100";
        }
        else if (hexvalue[i] == '5')
        {
            value = value + "0101";
        }
        else if (hexvalue[i] == '6')
        {
            value = value + "0110";
        }
        else if (hexvalue[i] == '7')
        {
            value = value + "0111";
        }
        else if (hexvalue[i] == '8')
        {
            value = value + "1000";
        }
        else if (hexvalue[i] == '9')
        {
            value = value + "1001";
        }
        else if (hexvalue[i] == 'A')
        {
            value = value + "1010";
        }
        else if (hexvalue[i] == 'B')
        {
            value = value + "1011";
        }
        else if (hexvalue[i] == 'C')
        {
            value = value + "1100";
        }
        else if (hexvalue[i] == 'D')
        {
            value = value + "1101";
        }
        else if (hexvalue[i] == 'E')
        {
            value = value + "1110";
        }
        else if (hexvalue[i] == 'F')
        {
            value = value + "1111";
        }
        else
        {
            throw "Invalid hex value ";
        }
    }
    return value;
}
