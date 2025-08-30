`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2025 15:45:49
// Design Name: 
// Module Name: top_apb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module basys3_top (
    input wire CLK100MHZ,       
    input wire btnC,            
    input wire btnU,           
    input wire [15:0] SW,       
    output wire [15:0] LED      
);

    wire PCLK;
    wire PRESETn;
    wire [7:0] PADDR;
    wire PSEL;
    wire PENABLE;
    wire PWRITE;
    wire [31:0] PWDATA;
    wire [31:0] PRDATA;
    wire PREADY;
    wire PSLVERR;

    
    assign PCLK = CLK100MHZ;
    
    assign PRESETn = ~btnC;

    
    reg btnU_d;
    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            btnU_d <= 1'b0;
        end else begin
            btnU_d <= btnU;
        end
    end
    wire trigger = btnU & ~btnU_d;

   
    apb_master master_inst (
        .clk(PCLK),
        .rstn(PRESETn),
        .trigger(trigger),
        .PADDR(PADDR),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR)
    );

    
    apb_slave slave_inst (
        .PCLK(PCLK),
        .PRESETn(PRESETn),
        .PADDR(PADDR),
        .PSEL(PSEL),
        .PENABLE(PENABLE),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA),
        .PRDATA(PRDATA),
        .PREADY(PREADY),
        .PSLVERR(PSLVERR),
        .LED(LED),
        .SW(SW)
    );

endmodule
