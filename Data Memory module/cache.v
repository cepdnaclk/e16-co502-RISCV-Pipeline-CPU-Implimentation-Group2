`timescale  1ns/100ps
module cache(
	clock,
    reset,
    read,
    write,
    address,
    writedata,
    dataOut,
    Busywait,
    cachemem_read,cachemem_write,cachemem_address,cachemem_writedata,cachemem_readdata,cachemem_Busywait,Inst_hit,funct3);    


input            clock;
input            reset;
input            read;
input            write;
input[31:0]      address;            
input[31:0]      writedata;           
output reg [31:0]     dataOut;           
output           Busywait;

output reg           cachemem_read,cachemem_write;
output reg [7:0]      cachemem_writedata;      
output reg [31:0]     cachemem_address;
input [7:0]      cachemem_readdata;       
input            cachemem_Busywait; 
input            Inst_hit;           //this signal is used to check wether theres a hit in instruction cache.
                                     //in other words using this, I identify wether the instruction is correct for the respective PC.
                                    //since theres an asynchronous output to instruction cache, there may be incorrect instructions fetched
                                    //before the correct instruction come.so here before executing i check Inst_hit is asserted


input [1:0]      funct3;           //!to check which type of store instr(byte,half,full,upper)


reg [31:0] baseAddress,Address_1,Address_2,Address_3;

reg [7:0] dataExtracted_1,dataExtracted_2,dataExtracted_3,dataExtracted_4;
// reg [31:0] Address_1;
// reg [31:0] Address_2;
// reg [31:0] Address_3;

/*set busywait whenever a write or read signal received*/
reg Busywait;                                        
reg readaccess, writeaccess;
always @(read, write)
begin
    if(Inst_hit)begin                            //checking Inst_hit is asserted
    Busywait = (read || write)? 1 : 0;                 
    readaccess = (read && !write)? 1 : 0;
    writeaccess = (!read && write)? 1 : 0;
    end
end


/* dividing address to respective tag index and offset Asynchronousyly */
always@(address) begin
 if(Inst_hit)begin               //checking Inst_hit is asserted
     if(read || write)begin
     #1
    baseAddress = address;
    Address_1 = address + 1;
    Address_2 = address + 2;
    Address_3 = address + 3;    
     end
 end    
end


//cache writing
always @(*)begin
    if (!readaccess && writeaccess)begin
        case(funct3)
        2'b00: begin    //store byte
            cachemem_address = baseAddress;
            cachemem_writedata = writedata[7:0];
            cachemem_write = 1;
            cachemem_read = 0;
            while(!cachemem_Busywait);
            Busywait = 0;
        end
        2'b01: begin   //store half word
            cachemem_address = baseAddress;
            cachemem_writedata = writedata[7:0];
            cachemem_write = 1;
            cachemem_read = 0;
            while(!cachemem_Busywait);
            cachemem_address = Address_1;
            cachemem_writedata = writedata[15:8];
            cachemem_write = 1;
            cachemem_read = 0;
            while(!cachemem_Busywait);
            Busywait = 0;
        end
        2'b10:begin       //store full word
            cachemem_address = baseAddress;
            cachemem_writedata = writedata[7:0];
            cachemem_write = 1;
            cachemem_read = 0;
            while(!cachemem_Busywait);
            cachemem_address = Address_1;
            cachemem_writedata = writedata[15:8];
            cachemem_write = 1;
            cachemem_read = 0;
            while(!cachemem_Busywait);
            cachemem_address = Address_2;
            cachemem_writedata = writedata[23:16];
            cachemem_write = 1;
            cachemem_read = 0;
            while(!cachemem_Busywait);
            cachemem_address = Address_3;
            cachemem_writedata = writedata[31:24];
            cachemem_write = 1;
            cachemem_read = 0;
            while(!cachemem_Busywait);
            Busywait = 0;
        end
        endcase
    end
end

//cache Reading
always @(*) begin
    if (readaccess && !writeaccess)begin
        cachemem_address = baseAddress;
        cachemem_write = 0;
        cachemem_read = 1;
        while(!cachemem_Busywait);
        dataExtracted_1 = cachemem_readdata;

        cachemem_address = Address_1;
        cachemem_write = 0;
        cachemem_read = 1;
        while(!cachemem_Busywait);
        dataExtracted_2 = cachemem_readdata;

        cachemem_address = Address_2;
        cachemem_write = 0;
        cachemem_read = 1;
        while(!cachemem_Busywait);
        dataExtracted_3 = cachemem_readdata;

        cachemem_address = Address_3;
        cachemem_write = 0;
        cachemem_read = 1;
        while(!cachemem_Busywait);
        dataExtracted_4 = cachemem_readdata;
        Busywait = 0;
    end
end

always @(posedge clock ) begin
    dataOut = {dataExtracted_1,dataExtracted_2,dataExtracted_3,dataExtracted_4};
end

//Reset Cache memory
always @(posedge reset)
begin
    if (reset)
    begin
        readaccess = 0;
        writeaccess = 0;
        Busywait = 0;
    end
end
endmodule





