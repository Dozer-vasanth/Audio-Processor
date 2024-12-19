`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2024 15:52:11
// Design Name: 
// Module Name: Multiplier
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


module Multiplier(
        input [23:0] a,
        input [23:0] b,
        input available,
        input reset,
        input clk,
        output [23:0] product,
        output status,
        output done
    );
    
    reg [23:0] number1,number2;
    reg [24:0] product_holder,product_holder_reserve;
    localparam s_idle=2'b00,s_initializing=2'b01,s_calculating=2'b10,s_done=2'b11;
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg carry;
    reg status_register,done_register,carry_next;
    reg [5:0]current_pointer,next_pointer;
    
    always @(posedge clk)
    begin
        if(~reset)
        begin
            current_state<=s_idle;
            product_holder<=0;
            current_pointer<=0;
            carry<=carry_next;
        end
        else
        begin
            current_state<=next_state;
            product_holder<=product_holder_reserve;
            current_pointer <= next_pointer;
            carry<=carry_next;
        end
    end
    
    always @(*)
    begin
        case(current_state)
            s_idle:
            begin
                number1<=0;
                number2<=0;
                carry_next = carry;
                product_holder_reserve = 0;
                next_pointer = 0;
                done_register<=0;
                if(available)
                begin
                    next_state = s_initializing;
                    status_register<=1;
                end
                else
                begin
                    next_state = s_idle;
                    status_register<=0;
                end
            end
            s_initializing:
            begin
                status_register<=0;
                done_register<=0;
                next_pointer = 0;
                number1<=a;
                number2<=b;
                product_holder_reserve = 0;
                next_state = s_calculating;
                carry_next = carry;
            end
            s_calculating:
            begin
                status_register <=0;
                number1<=a;
                number2<=b;
                done_register<=0;
                if(current_pointer==23)
                begin
                    next_state = s_done;
                end
                else
                begin
                    next_state = s_calculating;
                end
                if(number1[current_pointer]==1)
                begin
                    product_holder_reserve = (product_holder + {1'b0,number2})>>1;
                    
                end
                else
                begin
                    product_holder_reserve = product_holder>>1;
                    
                end
                next_pointer = current_pointer +5'b00001;
                carry_next = product_holder[0];
            end
            s_done:
            begin
                status_register<=0;
                number1<=0;
                number2<=0;
                next_pointer = current_pointer;
                product_holder_reserve = product_holder;
                done_register<=1;
                next_state = s_idle;
                carry_next = carry;
            end
            default:
            begin
                next_state = current_state;
                product_holder_reserve = product_holder;
                number1<=0;
                number2<=0;
                status_register<=0;
                carry_next =0;
                next_pointer =0;
                done_register = 0;
            end
            
        endcase
    end
    
    assign product = {product_holder[22:0],carry};
    assign done = done_register;
    assign status = status_register;
    
endmodule
