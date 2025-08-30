`timescale 1ns / 1ps
module apb_master (
    input wire clk,
    input wire rstn,
    input wire trigger,  e
    output reg [7:0] PADDR,
    output reg PSEL,
    output reg PENABLE,
    output reg PWRITE,
    output reg [31:0] PWDATA,
    input wire [31:0] PRDATA,
    input wire PREADY,
    input wire PSLVERR  
);

    reg [2:0] state;
    localparam IDLE = 3'd0,
               SETUP_READ = 3'd1,
               ACCESS_READ = 3'd2,
               SETUP_WRITE = 3'd3,
               ACCESS_WRITE = 3'd4;

    reg [31:0] read_data;

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= IDLE;
            PADDR <= 8'b0;
            PSEL <= 1'b0;
            PENABLE <= 1'b0;
            PWRITE <= 1'b0;
            PWDATA <= 32'b0;
            read_data <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (trigger) begin
                        state <= SETUP_READ;
                        PADDR <= 8'h04;  
                        PWRITE <= 1'b0;  
                        PSEL <= 1'b1;
                        PENABLE <= 1'b0;
                    end
                end
                SETUP_READ: begin
                    state <= ACCESS_READ;
                    PENABLE <= 1'b1;
                end
                ACCESS_READ: begin
                    if (PREADY) begin
                        read_data <= PRDATA;
                        state <= SETUP_WRITE;
                        PADDR <= 8'h00; 
                        PWRITE <= 1'b1;  
                        PSEL <= 1'b1;
                        PENABLE <= 1'b0;
                    end
                end
                SETUP_WRITE: begin
                    PWDATA <= read_data;
                    state <= ACCESS_WRITE;
                    PENABLE <= 1'b1;
                end
                ACCESS_WRITE: begin
                    if (PREADY) begin
                        state <= IDLE;
                        PSEL <= 1'b0;
                        PENABLE <= 1'b0;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
