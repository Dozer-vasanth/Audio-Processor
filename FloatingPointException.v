`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.12.2024 12:25:56
// Design Name: 
// Module Name: FloatingPointException
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

//flag_structure: +0,-0,+inf,-inf,sNaN,qNaN,NaN

module FloatingPointException(
        input [31:0] a,
        input [31:0] b,
        input [6:0] flags_a, 
        input [6:0] flags_b,
        input clk,
        input reset,
        input enable,
        input Multiplication,
        input Addition,
        output [32:0] Answer,
        output [6:0] output_flags,
        output done,
        output status
    );
    
    reg done_reg,status_reg;
    wire sign_mul,flag_a,flag_b;
    wire decision,answer_a,answer_b;
    reg [31:0] number1,number2;
    reg [2:0] current_state,next_state;
    reg [31:0] answer;
    localparam s_idle=3'b000,s_initializing=3'b001,s_addition=3'b010,s_multiplication=3'b011,s_done=3'b100;
    xor X1(sign_mul,a[31],b[31]);
    or O1(flag_a,flags_a[6],flags_a[5],flags_a[4],flags_a[3],flags_a[2],flags_a[1],flags_a[0]);
    or O2(flag_b,flags_b[6],flags_b[5],flags_b[4],flags_b[3],flags_b[2],flags_b[1],flags_b[0]);
    or O3(answer_a,flags_a[2],flags_a[1],flags_a[0]);
    or O4(answer_b,flags_b[2],flags_b[1],flags_b[0]);
    or O5(decision,answer_a,answer_b);
    
    always @(posedge clk)
    begin
        if(~reset)
        begin
            current_state <= s_idle;
        end
        else
        begin
            current_state <= next_state;
        end
    end
    
    always @(*)
    begin
        case(current_state)
        s_idle:
        begin
            done_reg = 0;
            status_reg= 0;
            if(enable)
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
            number1 = a;
            number2 = b;
            done_reg = 0;
            status_reg = 1;
            if(Multiplication&&~Addition)
            begin
                next_state = s_multiplication;
            end
            else if(Addition&&~Multiplication)
            begin
                next_state = s_addition;
            end
            else
            begin
                next_state = done_reg;
            end
        end
        s_addition:
        begin
            if(flag_a&&~flag_b)
            begin
                if(flags_a[6])
                begin
                    answer = number2;
                end
                else if(flags_a[5])
                begin
                    answer = number2;
                end
                else if(flags_a[4])
                begin
                    answer = number1;
                end
                else if(flags_a[3])
                begin
                    answer = number1;
                end
                else if(flags_a[2])
                begin
                    answer = number1;
                end
                else if(flags_a[3])
                begin
                    answer = number1;
                end
                else
                begin
                    answer = number1;
                end
            end
            if(flag_b&&~flag_a)
            begin
                if(flags_b[6])
                begin
                    answer = number1;
                end
                else if(flags_b[5])
                begin
                    answer = number1;
                end
                else if(flags_b[4])
                begin
                    answer = number2;
                end
                else if(flags_b[3])
                begin
                    answer = number2;
                end
                else if(flags_b[2])
                begin
                    answer = number2;
                end
                else if(flags_b[3])
                begin
                    answer = number2;
                end
                else
                begin
                    answer = number2;
                end
            end
            else
            begin
                if(decision)
                begin
                    answer = {1'b0,31'b1};
                end
                else
                begin
                    if(flags_a[6]&&flags_b[6])
                    begin
                        answer = number1;
                    end
                    else if(flags_a[6]&&flags_b[5])
                    begin
                        answer = number2;
                    end
                    else if(flags_a[6]&&flags_b[4])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    else if(flags_a[6]&&flags_b[3])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    if(flags_a[5]&&flags_b[6])
                    begin
                        answer = number1;
                    end
                    else if(flags_a[5]&&flags_b[5])
                    begin
                        answer = number2;
                    end
                    else if(flags_a[5]&&flags_b[4])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    else if(flags_a[5]&&flags_b[3])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    if(flags_a[4]&&flags_b[6])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    else if(flags_a[4]&&flags_b[5])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    else if(flags_a[4]&&flags_b[4])
                    begin
                        answer = number2;
                    end
                    else if(flags_a[4]&&flags_b[3])
                    begin
                        answer = number2;
                    end
                    if(flags_a[4]&&flags_b[6])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    else if(flags_a[4]&&flags_b[5])
                    begin
                        answer = {1'b0,31'b1};
                    end
                    else if(flags_a[4]&&flags_b[4])
                    begin
                        answer = number2;
                    end
                    else if(flags_a[4]&&flags_b[3])
                    begin
                        answer = number2;
                    end
                end
            end
        end
        endcase
    end
    
    assign done = done_reg;
    assign status = status_reg;
    
endmodule
