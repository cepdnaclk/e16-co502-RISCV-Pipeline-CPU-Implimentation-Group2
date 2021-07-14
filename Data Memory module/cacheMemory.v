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
    mem_Read,mem_Write,mem_Address,mem_Writedata,mem_Readdata,mem_BusyWait,Inst_hit);    

input               clock;
input               reset;
input               read;
input               write;
input[31:0]          address;            //32 bit address
input[31:0]         writedata;           //32 bit input
output[31:0]         readdata;           //32 bit output
output           busywait;

output           mem_Read,mem_Write;
output[31:0]     mem_Writedata;
output[5:0]      mem_Address;
input [31:0]     mem_Readdata;
input            mem_BusyWait; 
input            Inst_hit;           //this signal is used to check wether theres a hit in instruction cache.
                                     //in other words using this, I identify wether the instruction is correct for the respective PC.
                                    //since theres an asynchronous output to instruction cache, there may be incorrect instructions fetched
                                    //before the correct instruction come.so here before executing i check Inst_hit is asserted

/* Cache memory storage register files */
reg[31:0] cache [0:7];
reg[2:0] cacheTag [0:7];
reg cacheDirty [0:7];
reg cacheValid [0:7];

reg[1:0] Offset;
reg[2:0] Index;
reg[2:0] Tag;

/* dividing address to respective tag index and offset Asynchronousyly */
always@(address) begin
 if(Inst_hit)begin               //LAB6 PART3 UPDATE:- checking Inst_hit is asserted
     if(read || write)begin
     #1
     Offset <= address[1:0];     //need to check 
     Index <= address[4:2];
     Tag <= address[7:5];
     end
 end    
end

/*Asynchronous comparator to compare tag and AND gate to check valid bit is set */
wire comparatorOut;
wire hit,dirty;
wire[2:0] comparatorTagIN;
assign comparatorTagIN = cacheTag[Index];
comparator  e16203_comparator(Tag,comparatorTagIN,comparatorOut);
ANDgate     e16203_ANDgate(cacheValid[Index],comparatorOut,hit);

/*for future usage*/
assign dirty = cacheDirty[Index];


/*Asynchronous data extraction and assigning*/
wire[7:0] dataExtractMuxOut;
wire[31:0] data;
assign data = cache[Index];
multiplexerType4   e16203_dataExtractMux(data[7:0],data[15:8],data[23:16],data[31:24],dataExtractMuxOut,Offset);
wire readdata;
assign #1 readdata = dataExtractMuxOut;

/*set busywait whenever a write or read signal received*/
reg Busywait;                                        
reg readaccess, writeaccess;
always @(read, write)
begin
    if(Inst_hit)begin                            //LAB6 PART3 UPDATE:- checking Inst_hit is asserted
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
        cache[Index][31:24] = writedata;
    2'b10:
        cache[Index][23:16] = writedata;
    2'b01:
        cache[Index][15:8] = writedata;
    2'b00: 
        cache[Index][7:0] = writedata;
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





