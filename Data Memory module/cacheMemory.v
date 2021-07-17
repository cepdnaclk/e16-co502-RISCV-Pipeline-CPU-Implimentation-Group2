`timescale  1ns/100ps
module cacheMemory(
	clock,
    reset,
    read,
    write,
    address,
    writedata,
    readdata,
    busywait,
    mem_Read,mem_Write,mem_Address,mem_Writedata,mem_Readdata,mem_BusyWait,Inst_hit,funct3);    

input               clock;
input               reset;
input               read;
input               write;
input[31:0]          address;            //TODO: should be 32 bit
input[31:0]         writedata;           //TODO: should be 32 bit
output[31:0]         readdata;           //TODO: should be 32 bit
output           busywait;

output           mem_Read,mem_Write;
output[31:0]     mem_Writedata;      //TODO: should be 32 bit
output[5:0]      mem_Address;
input [31:0]     mem_Readdata;       //TODO: should be 32 bit
input            mem_BusyWait; 
input            Inst_hit;           //this signal is used to check wether theres a hit in instruction cache.
                                     //in other words using this, I identify wether the instruction is correct for the respective PC.
                                    //since theres an asynchronous output to instruction cache, there may be incorrect instructions fetched
                                    //before the correct instruction come.so here before executing i check Inst_hit is asserted
input [1:0]      funct3;           //!to check which type of store instr(byte,half,full,upper)


/* Cache memory storage register files */
reg[127:0] cache [0:7];
reg[24:0] cacheTag [0:7];
reg cacheDirty [0:7];
reg cacheValid [0:7];

reg[3:0] Offset;
reg[2:0] Index;
reg[24:0] Tag;

/* dividing address to respective tag index and offset Asynchronousyly */
always@(address) begin
 if(Inst_hit)begin               //LAB6 PART3 UPDATE:- checking Inst_hit is asserted
     if(read || write)begin
     #1
     Offset <= address[3:0];     //need to check 
     Index <= address[6:4];
     Tag <= address[31:7];
     end
 end    
end

/*Asynchronous comparator to compare tag and AND gate to check valid bit is set */
// wire comparatorOut;
// wire hit,dirty;
// wire[2:0] comparatorTagIN;
// assign comparatorTagIN = cacheTag[Index];
// comparator  group2_comparator(Tag,comparatorTagIN,comparatorOut);
// ANDgate     group2_ANDgate(cacheValid[Index],comparatorOut,hit);

assign comparatorOut = (Tag == cacheTag[Index])? 1:0;     //compare tags to check wether theres an entry in the cache memory_array
assign hit =  (comparatorOut && cacheValid[Index])? 1:0;  //resolve hit state when tag matches and entry is valid

/*for future usage*/
assign dirty = cacheDirty[Index];


/*Asynchronous data extraction and assigning*/
// wire[31:0] dataExtractMuxOut;
// wire[127:0] data;
// assign data = cache[Index];
// multiplexerType4   group2_dataExtractMux(data[7:0],data[15:8],data[23:16],data[31:24],dataExtractMuxOut,Offset);
// wire readdata;
// assign #1 readdata = dataExtractMuxOut;
wire[31:0] dataExtract;
wire[127:0] data;
assign data = cache[Index];
always @(*)
begin
    case(Offset[3:2])
    2'b00: dataExtract = data[31:0];
    2'b01: dataExtract = data[63:31];
    2'b10: dataExtract = data[95:64];
    2'b11: dataExtract = data[127:96];
end
wire readdata;
assign #1 readdata = dataExtract;


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


/* to set busywait to zero when a hit occured */
always@(posedge clock)begin
 if (readaccess && hit)
    begin
    Busywait = 1'b0;                                
    end
 else if (writeaccess && hit)   
    begin
    Busywait = 1'b0;                                
    #1   
    cacheDirty[Index] = 1'b1;            //setting dirty bit to 1,this is the only place where dirty bit is set to 1                                //here cache write undergo even after busywait set to zero  

    case(Offset)                         //then set the input data into correct place in the cache block
    2'b11:
        cache[Index][31:24] = writedata;   //TODO: should be 32 bit
    2'b10:
        cache[Index][23:16] = writedata;   //TODO: should be 32 bit
    2'b01:
        cache[Index][15:8] = writedata;    //TODO: should be 32 bit
    2'b00: 
        cache[Index][7:0] = writedata;     //TODO: should be 32 bit
    endcase 
    end	
end


/*here i put the 32bit data block provided by data memory to the correct place in cache
and set valid bit to 1 and dirty bit to zero */
always@(mem_BusyWait)begin
    if(!mem_BusyWait)
    begin
    #1
	cache[Index] = mem_Readdata;
    cacheValid[Index] = 1'b1;
    cacheDirty[Index] = 1'b0;
    cacheTag[Index] = Tag;
    end
end

/* here i provide the block tag and the data to be written to the data memory when there was a miss occured and 
   the block is dirty (to complete WRITE_BACK state) */
reg[31:0] writedata1;   //these are inputs to my cache controller
reg[2:0] Tag1;          //these are inputs to my cache controller
always@(hit)begin
	if(!hit && dirty)
       begin
	   writedata1 = cache[Index];
       Tag1 = cacheTag[Index];
       end
end


/* cache controller to handle data memory control signals(mem_Read,mem_Write etc) whenever a miss occured in cachememory */
wire controllerBusywait;                                  
cacheController    e16203_cacheController(clock,reset,read,write,address,writedata,controllerBusywait,mem_BusyWait,Tag1,writedata1,Tag,Index,hit,dirty,mem_Read,mem_Write,mem_Writedata,mem_Address);

/* overall busywait is set to zero whenever cachecontroller busywait and cachememory busywait both set to zero */
wire busywait;                                           
assign busywait = (Busywait || controllerBusywait)? 1:0;        
integer i;

//Reset Cache memory
always @(posedge reset)
begin
    if (reset)
    begin
        for (i=0;i<8; i=i+1)
            begin
            cache[i] = 0;
            cacheTag[i] = 0;
            cacheDirty[i] = 0;
            cacheValid[i] = 0;
            end
        readaccess = 0;
        writeaccess = 0;
        Busywait = 0;
    end
end
endmodule





