module lfsr_t1(input logic clk, [7:0]a, output logic [0:7]Q, [7:0]r_addr);
logic [5:0]opcode;
logic shamt;
logic [6:0]funct;
logic [6:0]tap;
logic [7:0] M[0:255];
logic [13:0]rd;

always_comb			//instruction_memory_data
begin				//14-bit instrunctions
case(a)
8'b00000000: rd= 14'b00000100100101;
8'b00000001: rd= 14'b00001011111111;
8'b00000010: rd= 14'b00001100000000;
8'b00000011: rd= 14'b00001100000000;
8'b00000100: rd= 14'b00011000001001;
8'b00000101: rd= 14'b00001100000000;
8'b00000110: rd= 14'b00010000000000;
8'b00000111: rd= 14'b00001100000000;
8'b00001000: rd= 14'b00011111111110;
8'b00001001: rd= 14'b00010000000000;
8'b00001010: rd= 14'b00011100000010;
8'b00001011: rd= 14'b00010100000000;
8'b00001100: rd= 14'b00001100000000;
8'b00001101: rd= 14'b11111111111111;

endcase
end

always@(posedge clk)  		
begin

opcode = rd[13:8];		//instruction has opcode, shamt & funct
shamt = rd[7];
funct = rd[6:0];

if(opcode==6'b000001 && shamt==1'b0)   //config_tap
begin 
tap=funct;
end

if(opcode==6'b000010)        //init_L
begin
Q={shamt, funct[6:0]};
end

if(opcode==6'b000011)    //run
begin
Q[0]<=Q[7];

if(tap[6]==1)
Q[1]<=Q[0]^Q[7];
else
Q[1]<=Q[0];

if(tap[5]==1)
Q[2]<=Q[1]^Q[7];
else
Q[2]<=Q[1];

if(tap[4]==1)
Q[3]<=Q[2]^Q[7];
else
Q[3]<=Q[2];

if(tap[3]==1)
Q[4]<=Q[3]^Q[7];
else
Q[4]<=Q[3];

if(tap[2]==1)
Q[5]<=Q[4]^Q[7];
else
Q[5]<=Q[4];

if(tap[1]==1)
Q[6]<=Q[5]^Q[7];
else
Q[6]<=Q[5];

if(tap[0]==1)
Q[7]<=Q[6]^Q[7];
else
Q[7]<=Q[6];
end

if(opcode==6'b000110)   //init_adder
begin
r_addr={shamt, funct[6:0]};
end

if(opcode==6'b000100)  //store
begin 
M[r_addr]=Q;
end

if(opcode==6'b000111)			//add_addr num
begin
r_addr =r_addr + {shamt, funct[6:0]};
end

if(opcode==6'b000101)			//load
begin 
Q=M[r_addr];
end

if(opcode==6'b000110)			//init_addr
begin
r_addr={shamt, funct[6:0]};
end

if(opcode==6'b111111)			//halt
begin
$stop;
end
end
endmodule 
