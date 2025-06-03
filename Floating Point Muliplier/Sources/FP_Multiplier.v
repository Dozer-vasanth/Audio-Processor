`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.12.2024 16:58:47
// Design Name: 
// Module Name: FP_Multiplier
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


module FP_Multiplier(
        input [31:0] a,
        input [31:0] b,
        input available,
        input clk,
        input reset,
        output [31:0] product,
        output done,
        output status_multiplication
    );
    
    reg done_register;
    reg [7:0] sum,sum_final;
    wire answer;
    reg [31:0] FP1, FP2;
    reg [23:0] number1,number2;
    reg [31:0] product_holder, product_holder_reserve;
    reg [2:0] current_state, next_state;
    reg avail_for_multiplication;
    wire done_multiplication;
    wire [23:0] product_multiplication;
    wire multiplication_indicator;
    localparam s_idle= 3'b000,s_initializing = 3'b001,s_powerpart = 3'b010,s_multiplication = 3'b011,s_sign = 3'b100,s_done = 3'b101,s_sum =3'b110;
    
    Multiplier FP_multiplier(.a(number1),.b(number2),.available(avail_for_multiplication),.reset(reset),.clk(clk),.product(product_multiplication),.done(done_multiplication),.status(status_multiplication));
    xor (answer,FP1[31],FP2[31]);
    nor (multiplication_indicator,1'b0,product_multiplication[23]);
    
    
    always @(posedge clk)
    begin
        if(~reset)
        begin
            current_state<=s_idle;
            product_holder <= product_holder_reserve;
            sum_final<=sum;
        end
        else
        begin
            current_state<=next_state;
            product_holder <= product_holder_reserve;
            sum_final<=sum;
        end
    end
    
    always @(*)
    begin
        case(current_state)
            s_idle:
            begin
                sum =0;
                FP1 <= a;
                FP2 <= b;
                number1 =0;
                number2 =0;
                avail_for_multiplication =0;
                product_holder_reserve = 0;
                done_register = 0;
                if(available==1)
                begin
                    next_state = s_initializing;
                end
                else
                begin
                    next_state = s_idle;
                end
            end
            s_initializing:
            begin
                sum =0;
                number1 =0;
                number2 =0;
                avail_for_multiplication =0;
                done_register = 0;
                product_holder_reserve = 0;
                FP1 <= a;
                FP2 <= b;
                next_state = s_sign;
            end
            s_sign:
            begin
                sum =0;
                FP1 <=a;
                FP2 <= b;
                avail_for_multiplication =0;
                done_register = 0;
                product_holder_reserve = {answer,product_holder[30:0]};
                next_state = s_multiplication;
                number1 ={1'b1,FP1[22:0]};
                number2 ={1'b1,FP2[22:0]};
                next_state = s_multiplication;
            end
            s_multiplication:
            begin
                FP1<=a;
                FP2<=b;
                done_register = 0;
                avail_for_multiplication =1;
                sum =0;
                if(multiplication_indicator)
                begin
                    product_holder_reserve = {product_holder[31:23],product_multiplication[23:1]};
                    
                end
                else
                begin
                    product_holder_reserve = {product_holder[31:23],product_multiplication[22:0]};
                    
                end
                if(done_multiplication)
                begin
                    next_state = s_sum;
                    number1 =0;
                    number2 =0;
                end
                else
                begin
                    next_state = s_multiplication;
                    number1 ={1'b1,FP1[22:0]};
                    number2 ={1'b1,FP2[22:0]};
                end
            end
            s_sum:
            begin
                FP1<=a;
                FP2<=b;
                number1 =0;
                number2 =0;
                done_register = 0;
                avail_for_multiplication =0;
                if(multiplication_indicator)
                begin
                    sum = {~FP1[30],FP1[29:23]} + FP2[30:23] +1;
                end
                else
                begin
                    sum = {~FP1[30],FP1[29:23]} + FP2[30:23] ;
                end
                next_state = s_powerpart;
                product_holder_reserve = product_holder;
            end
            s_powerpart:
            begin
                FP1<=0;
                FP2<=0;
                sum =0;
                number1 =0;
                number2 =0;
                avail_for_multiplication =0;
                done_register =0;
                product_holder_reserve = {product_holder[31],sum_final,product_holder[22:0]};
                next_state = s_done;
            end
            s_done:
            begin
                sum =0;
                FP1<=32'b0;
                number1 =0;
                number2 =0;
                FP2<=32'b0;
                product_holder_reserve = product_holder;
                avail_for_multiplication =0;
                done_register =1;
                next_state = s_idle;
            end
            default:
            begin
                sum =0;
                FP1<=32'b0;
                number1 =0;
                number2 =0;
                done_register =0;
                FP2<= 32'b0;
                product_holder_reserve = product_holder;
                next_state = current_state;
                avail_for_multiplication = 0;
            end
        endcase
    end
    
    assign done = done_register;
    assign product = product_holder;
    
endmodule
