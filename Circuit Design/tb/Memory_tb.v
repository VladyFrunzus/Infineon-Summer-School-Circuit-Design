`timescale 1ns/1ps

module Memory_tb();

reg pclk_i_tb;
reg presetn_i_tb;
reg psel_i_tb;
reg penable_i_tb;
reg pwrite_i_tb;
reg [7:0] paddr_i_tb;
reg [31:0] pwdata_i_tb;
wire [31:0] prdata_o_tb;
wire pready_o_tb;
wire pslverr_o_tb;

Memory dut(.pclk_i(pclk_i_tb), .presetn_i(presetn_i_tb), .psel_i(psel_i_tb),
.penable_i(penable_i_tb), .pwrite_i(pwrite_i_tb), .paddr_i(paddr_i_tb),
.pwdata_i(pwdata_i_tb), .prdata_o(prdata_o_tb), .pready_o(pready_o_tb),
.pslverr_o(pslverr_o_tb));

initial begin
pclk_i_tb = 0;
forever #1 pclk_i_tb = ~pclk_i_tb;
end

initial begin
presetn_i_tb = 0;
psel_i_tb = 0;
penable_i_tb = 1;
paddr_i_tb = 0;
pwdata_i_tb = 0;
pwrite_i_tb = 0;
#2
presetn_i_tb = 1;
#10
//Write 1
@(posedge pclk_i_tb) 
psel_i_tb <= 1;
penable_i_tb <= 0;
paddr_i_tb <= 8'd1;
pwdata_i_tb <= 32'd15;
pwrite_i_tb <= 1;
@(posedge pclk_i_tb) 
penable_i_tb <= 1;
@(posedge pready_o_tb)
#1;
@(posedge pclk_i_tb) 
psel_i_tb <= 0;
penable_i_tb <= 1;
paddr_i_tb <= 0;
pwdata_i_tb <= 0;
pwrite_i_tb <= 0;

//Write 2
@(posedge pclk_i_tb) 
psel_i_tb <= 1;
penable_i_tb <= 0;
paddr_i_tb <= 8'd2;
pwdata_i_tb <= 32'd30;
pwrite_i_tb <= 1;
@(posedge pclk_i_tb) 
penable_i_tb <= 1;
@(posedge pready_o_tb)
@(posedge pclk_i_tb) 
psel_i_tb <= 0;
penable_i_tb <= 1;
paddr_i_tb <= 0;
pwdata_i_tb <= 0;
pwrite_i_tb <= 0;

#10

//READ 1
@(posedge pclk_i_tb) 
psel_i_tb <= 1;
penable_i_tb <= 0;
paddr_i_tb <= 8'd1;
pwrite_i_tb <= 0;
@(posedge pclk_i_tb) 
penable_i_tb <= 1;
@(posedge pready_o_tb)
#1;
@(posedge pclk_i_tb) 
psel_i_tb <= 0;
penable_i_tb <= 1;
paddr_i_tb <= 0;
pwdata_i_tb <= 0;
pwrite_i_tb <= 0;

//READ 2
@(posedge pclk_i_tb) 
psel_i_tb <= 1;
penable_i_tb <= 0;    
paddr_i_tb <= 8'd2;
pwrite_i_tb <= 0;
@(posedge pclk_i_tb)
penable_i_tb <= 1;
@(posedge pready_o_tb)
#1;
@(posedge pclk_i_tb) 
psel_i_tb <= 0;
penable_i_tb <= 1;
paddr_i_tb <= 0;
pwdata_i_tb <= 0;
pwrite_i_tb <= 0;

#10
$stop();

end

endmodule
