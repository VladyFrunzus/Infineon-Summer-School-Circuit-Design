module Sampler(

input pclk_i,
input presetn_i,
input [31:0] data_i,
output reg psel_o,
output reg penable_o,
output reg [7:0] paddr_o,
output reg [31:0] pwdata_o,
output reg pwrite_o,
input [31:0] prdata_i,
input pready_i,
input pslverr_i

);

localparam idle = 2'b00;
localparam setup = 2'b01;
localparam acces = 2'b11;

reg [1:0] stare, stare_urm;

localparam numar_s = 19'd1000;

wire sample_s;
reg [18:0] counter_s;
reg [7:0] counter_a;

//Counter pt sample

always@(posedge pclk_i)
if(presetn_i == 0)
counter_s <= numar_s;
else
if(counter_s == 0)
counter_s <= numar_s;
else
counter_s <= counter_s - 1;

assign sample_s = (counter_s == 0);

//Counter pt adrese

always@(posedge pclk_i)
begin
if(~presetn_i)
counter_a<= 0;
else
if(stare == acces  && pready_i)
counter_a <= counter_a + 1;
end

//FSM

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
if(sample_s)
stare_urm = setup;

setup:
stare_urm = acces;

acces:
begin
if(pready_i && sample_s)
stare_urm = setup;
else
if(pready_i)
stare_urm = idle;  
end

default: stare_urm = idle;
endcase
 
end

always@(*) 
begin

case(stare)

setup:
begin
paddr_o = counter_a;
pwrite_o = 1;
psel_o = 1;
penable_o = 0;
pwdata_o = data_i;
end

acces:
begin
paddr_o = counter_a;
pwrite_o = 1;
psel_o = 1;
penable_o = 1;
pwdata_o = data_i;
end

default: 
begin
psel_o = 0;
penable_o = 0;
paddr_o = 0;
pwdata_o = 0;
pwrite_o = 0;
end

endcase
end

endmodule
