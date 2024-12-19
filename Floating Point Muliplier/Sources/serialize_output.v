`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.12.2024 10:50:49
// Design Name: 
// Module Name: serialize_output
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


module serialize_output(
        input [31:0] number,
        input enable,
        input clk,
        input reset,
        output Rx
    );
    
    reg [32:0] number_next,number_current;
    reg [5:0] pointer_current,pointer_next;
    reg [1:0] next_state,current_state;
    
    localparam s_idle =2'b00,s_doing=2'b01;
    
    always @(posedge clk)
    begin
        if(~reset)
        begin
            current_state<=s_idle;
            number_current<=number;
            pointer_current<=0;
        end
        else
        begin
            current_state<=next_state;
            pointer_current <= pointer_next;
            number_current<=number_next;
        end
    end
    
    always @(*)
    begin
        case(current_state)
            s_idle:
            begin
                number_next = {1'b0,number};
                pointer_next = 0;
                if(enable)
                begin
                    next_state = s_doing;
                end
                else
                begin
                    next_state = s_idle;
                end
            end
            s_doing:
            begin
                if(pointer_current==31)
                begin
                    next_state = s_idle;
                end
                else
                begin
                    next_state = s_doing;
                end
                pointer_next = pointer_current+1;
                number_next = {1'b0,number_current}>>1;
            end
            default:
            begin
                pointer_next = pointer_current;
                next_state = current_state;
                number_next = number_current;
            end
        endcase
    end
    
    assign Rx = number_current[0];
    
endmodule
