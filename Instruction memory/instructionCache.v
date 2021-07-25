`timescale  1ns/100ps
module instructionCache(
	clock,
    reset,
    PC,
    readInstruction,
    busywait,
    mem_Read,mem_Address,mem_Readdata,mem_BusyWait,hit);

input               clock;
input               reset;
input[31:0]          PC;
output[31:0]        readInstruction;
output              busywait;
output              mem_Read;
output[27:0]         mem_Address;
input [127:0]       mem_Readdata;
input               mem_BusyWait; 
output              hit;                     //hit status should be output to sense from the cache memory

/* Cache memory storage register files */
reg[127:0] cache [0:7];
reg[24:0] cacheTag [0:7];
reg cacheValid [0:7];

reg[3:0] Offset;
reg[2:0] Index;
reg[24:0] Tag;
// reg[31:0] address;

// always@(PC)begin
//    if(!PC[31])begin             //ignore when PC = -4,since the cpu supports upto 255 instructions per time,theres no way 31st bit of pc can be 1 if it isnt -4.
//    address = PC[9:0];
//    end 
// end

/* dividing address to respective tag index and offset Asynchronousyly */
always@(PC) begin
 #1
 if(!PC[31])begin
    Offset <= PC[3:2];
    Index <= PC[6:4];
    Tag <= PC[31:7];
 end
end

/*Asynchronous comparator to compare tag and AND gate to check valid bit is set */
// wire comparatorOut;
// wire hit;
// wire[2:0] comparatorTagIN;
// assign comparatorTagIN = cacheTag[Index];
// comparator  e16203_comparator1(Tag,comparatorTagIN,comparatorOut);
// ANDgate     e16203_ANDgate1(cacheValid[Index],comparatorOut,hit);

wire comparatorOut;
wire hit,dirty;
assign comparatorOut = (Tag == cacheTag[Index])? 1:0;     //compare tags to check wether theres an entry in the cache memory_array
assign hit =  (comparatorOut && cacheValid[Index])? 1:0;  //resolve hit state when tag matches and entry is valid


/*Asynchronous instruction extraction and assigning*/
// wire[31:0] instructionExtractMuxOut;
// wire[127:0] data;
// assign data = cache[Index];
// multiplexerType5   e16203_instructionExtractMux(data[31:0],data[63:32],data[95:64],data[127:96],instructionExtractMuxOut,Offset);
// wire[31:0] readInstruction;
// assign #1 readInstruction = instructionExtractMuxOut;

reg[7:0] instExtract;      //!check this
wire[127:0] data;
assign data = cache[Index];
always @(*)
begin
    case(Offset)        //!relevent 32 bits are selected
    2'b00: instExtract = data[31:0] ;
    2'b01: instExtract = data[63:32] ;
    2'b10: instExtract = data[95:64] ;
    2'b11: instExtract = data[127:96] ;
    endcase
end
wire readInstruction;
assign #1 readInstruction = instExtract;

/*set busywait whenever a address signal received*/
reg Busywait;                                        
always @(PC)                                             
begin
    Busywait = 1;               
end


/* to set busywait to zero when a hit occured on a clock edge*/
always@(posedge clock)begin
 if (hit)
    begin
    Busywait = 1'b0;                                
    end	
end


/*here i put the bit data block provided by instruction memory to the correct place in cache
and set valid bit to 1*/
always@(mem_BusyWait)begin
    if(!mem_BusyWait)
    begin
    #1
	cache[Index] = mem_Readdata;
    cacheValid[Index] = 1'b1;
    cacheTag[Index] = Tag;
    end
end

/* cache controller to handle instruction memory control signals(mem_Read etc) whenever a miss occured in instruction cachememory */
wire ControllerBusywait;                                  
instructionCacheCTRL    e16203_instructionCacheCTRL(clock,reset,ControllerBusywait,mem_BusyWait,Tag,Index,hit,mem_Read,mem_Address);

/* overall busywait is set to zero whenever cachecontroller busywait and cachememory busywait both set to zero */
wire busywait;                                           
assign busywait = (Busywait || ControllerBusywait)? 1:0;        
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
            cacheValid[i] = 0;
            end
        Busywait = 0;
    end
end
endmodule