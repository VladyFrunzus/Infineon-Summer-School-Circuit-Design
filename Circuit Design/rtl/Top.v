module Top(

    input clk,
    input resetn,
    input [31:0] data_i,
    input compute_req,
    output [31:0] data_o,
    output valid_o

    );
    
    wire psel_c, psel_s, penable_c, penable_s, pwrite_c, pwrite_s;
    wire [7:0] paddr_c, paddr_s, paddr;
    wire [31:0] pwdata_c, pwdata_s, pwdata;
    wire [31:0] prdata;
    wire pready, pslverr;
    wire psel, penable, pwrite;
    
    Computer computer(.pclk_i(clk),
    .presetn_i(resetn),
    .compute_req_i(compute_req),
    .data_o(data_o),
    .psel_o(psel_c),
    .penable_o(penable_c),
    .valid_o(valid_o),
    .paddr_o(paddr_c),
    .pwdata_o(pwdata_c),
    .pwrite_o(pwrite_c),
    .prdata_i(prdata),
    .pready_i(pready),
    .pslverr_i(pslverr)
    );
    
    Sampler sampler(.pclk_i(clk),
    .presetn_i(resetn),
    .data_i(data_i),
    .psel_o(psel_s),
    .penable_o(penable_s),
    .paddr_o(paddr_s),
    .pwdata_o(pwdata_s),
    .pwrite_o(pwrite_s),
    .prdata_i(prdata),
    .pready_i(pready),
    .pslverr_i(pslverr)
    );
		
		assign paddr 	= paddr_c | paddr_s;
	  assign psel 	= psel_s    | psel_c;
    assign penable = penable_s | penable_c;
	  assign pwrite 	= pwrite_s  | pwrite_c;
	  assign pwdata	= pwdata_s  | pwdata_c;
    
    Memory memory(.pclk_i(clk),
    .presetn_i(resetn),
    .psel_i(psel),
    .penable_i(penable),
    .paddr_i(paddr),
    .pwdata_i(pwdata),
    .pwrite_i(pwrite),
    .prdata_o(prdata),
    .pready_o(pready),
    .pslverr_o(pslverr)
    );
    
endmodule
