module Memory(

input pclk_i,
input presetn_i,
input psel_i,
input penable_i,
input [7:0] paddr_i,
input [31:0] pwdata_i,
input pwrite_i,
output reg [31:0] prdata_o,
output pready_o,
output pslverr_o

);

reg [31:0] mem [0:255];
wire wr_en, rd_en;

localparam idle = 2'b00;
localparam setup = 2'b01;
localparam acces = 2'b11;

reg [1:0] stare, stare_urm;

assign wr_en = pwrite_i & penable_i & psel_i & pready_o;
assign rd_en = ~pwrite_i & penable_i & psel_i;

always@(posedge pclk_i)
if(wr_en)
mem[paddr_i] <= pwdata_i;

always@(*)
if(rd_en)
prdata_o = mem[paddr_i];
else
prdata_o = 0;

always@(posedge pclk_i)
begin
if(presetn_i == 0)
stare <= idle;
else
stare <= stare_urm;
end

always@(*)
begin

stare_urm = stare;

case(stare)

idle: 
if(psel_i && ~penable_i)
stare_urm = setup;

setup:
if(psel_i && penable_i)
stare_urm = acces;

acces:
begin
if(~psel_i)
stare_urm = idle;
else
if(~penable_i)
stare_urm = setup;  
end

default: stare_urm = idle;
endcase
 
end

assign pready_o = ~(stare==setup); 

assign pslverr_o = 0;

endmodule

