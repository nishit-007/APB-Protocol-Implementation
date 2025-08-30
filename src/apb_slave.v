`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.08.2025 15:48:45
// Design Name: 
// Module Name: apb_slave
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
module apb_slave (
    input wire PCLK,
    input wire PRESETn,
    input wire [7:0] PADDR,
    input wire PSEL,
    input wire PENABLE,
    input wire PWRITE,
    input wire [31:0] PWDATA,
    output reg [31:0] PRDATA,
    output wire PREADY,
    output wire PSLVERR,
    output reg [15:0] LED, 
    input wire [15:0] SW
);

    assign PREADY = 1'b1;  
    assign PSLVERR = 1'b0; 


    always @(posedge PCLK or negedge PRESETn) begin
        if (!PRESETn) begin
            LED <= 16'b0;  
        end else if (PSEL && PENABLE && PWRITE) begin
            case (PADDR)
                8'h00: LED <= PWDATA[15:0];  
                default: ;  
            endcase
        end
    end

    
    always @(*) begin
        PRDATA = 32'b0;
        if (PSEL && PENABLE && !PWRITE) begin
            case (PADDR)
                8'h00: PRDATA = {16'b0, LED};  
                8'h04: PRDATA = {16'b0, SW};   
                default: PRDATA = 32'b0;
            endcase
        end
    end

endmodule
