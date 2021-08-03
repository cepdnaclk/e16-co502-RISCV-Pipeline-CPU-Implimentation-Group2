#include <iostream>
#include <string>



using namespace std;


string getRegisterValue(string);

int main(int argc, char const *argv[])
{
    cout<< getRegisterValue("x13");;
    return 0;
}

string getRtypeInstruction(string instruction,string rs2,string rs1,string rd){

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

