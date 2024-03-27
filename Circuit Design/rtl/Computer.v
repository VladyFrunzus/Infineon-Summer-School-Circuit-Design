module Computer(

    
    input pclk_i,
    input presetn_i,
    input compute_req_i,
    output [31:0] data_o,
    output reg psel_o,
    output reg penable_o,
    output valid_o,
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
    
    reg [7:0] counter_a;
    
    reg [31:0] data_mem;
    
    always@(posedge pclk_i)
    begin
    if(~presetn_i)
    counter_a <= 0;
    else
    if(stare == acces  && pready_i)
    counter_a <= counter_a + 1;
    end
    
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
    if(compute_req_i)   
    stare_urm = setup;

    setup:
    stare_urm = acces;

    acces:
    begin
    if(pready_i && ((counter_a[0] == 0)||compute_req_i))
    stare_urm = setup;
    else
    if(pready_i)
    stare_urm = idle;  
    end

    default: stare_urm = idle;
    endcase
 
    end
    
    always@(posedge pclk_i)
    begin
    if(~presetn_i)
    data_mem <= 0;
    else
    if(stare == acces  && pready_i)
    data_mem <= prdata_i;
    end

    
    assign data_o = prdata_i + data_mem;
    
    assign valid_o = ((counter_a[0] == 1) && (stare == acces) && pready_i);
    
    always@(*) 
    begin

    case(stare)

    setup:
    begin
    paddr_o = counter_a;
    psel_o = 1;
    end

    acces:
    begin
    paddr_o = counter_a;
    psel_o = 1;
    penable_o = 1;
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
