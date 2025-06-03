`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2024 08:46:39
// Design Name: 
// Module Name: top_module
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


module top_module(
        input enable,
        input reset,
        input clk,
        output done,
        output rx,
        output status
    );
    
    reg [31:0] a,b;
    wire [31:0] product;
    reg available;
    wire done_reg;
    wire clk_100;
    
    clk_wiz_1 clock
   (
    // Clock out ports
    .clk_out1(clk_100),     // output clk_out1
    // Status and control signals
    .reset(0), // input reset
    .locked(),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
   );
    wire serialize_enable;
    reg [1:0] next_state,current_state;
    localparam s_idle=2'b00,s_operation = 2'b01,s_done=2'b10;
    
    and G1(serialize_enable,~status,done_reg);
    FP_Multiplier M(.a(a),.b(b),.clk(clk_100),.available(available),.done(done_reg),.reset(reset),.product(product),.status_multiplication(status));
    serialize_output O(.enable(serialize_enable),.reset(reset),.number(product),.clk(clk_100),.Rx(rx));
    
    always @(posedge clk_100)
    begin
        if(~reset)
        begin
            a<={9'b100000001,2'b11,21'b0};
            b<={9'b000000001,2'b01,21'b0};
            current_state<=s_idle;
        end
        else
        begin
            current_state<=next_state;
        end
    end
    
    always @(*)
    begin
        case(current_state)
            s_idle:
            begin
                available = 0;
                if(enable)
                begin
                    next_state = s_operation;
                end
                else
                begin
                    next_state = s_idle;
                end
            end
            s_operation:
            begin
                available = 1;
                if(done_reg)
                begin
                    next_state = s_done;
                end
                else
                begin
                    next_state = s_operation;
                end
            end
            s_done:
            begin
                available = 0;
                next_state = s_idle;
            end
            default:
            begin
                available = 0;
                next_state = current_state;
            end
        endcase
    end
    
    assign done = done_reg;
    
endmodule
