`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.01.2025 19:15:14
// Design Name: 
// Module Name: subtraction
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


module subtraction(input [31:0] a,b,input clk,input[4:0] flag_a,flag_b,input available,output [31:0] out,output done,status);
parameter IDLE = 4'd0,START = 4'd1,EXCEPTION=4'd2,CASE1=4'd3,CASE1A=4'd4,CASE1B=4'd5,CASE2=4'd6,SHIFT=4'd7,SUB=4'd8,DONE=4'd9;
wire[31:0] a_oper,b_oper;
wire check;
wire check2;
wire [7:0] exp_diff;
reg [7:0] diff_exp;
reg [3:0] state_reg,next_state;
reg [31:0] ans;
reg [22:0] b_shift;
initial diff_exp = 8'b0; 
assign {a_oper,b_oper} = (a[30:23]<b[30:23])?{b,a}:{a,b};
assign check = (a_oper[30:23]==b_oper[30:23]);
assign check2 =(check)?(a_oper==b_oper):(1'b0);
assign exp_diff = (check)?a_oper[30:23]:(a_oper[30:23]-b_oper[30:23]);
always@(*)
begin
case(state_reg)
IDLE:next_state = (available)?START:IDLE;
START:next_state = ((|flag_a) || (|flag_b) )?EXCEPTION:((check)?CASE1:CASE2);
CASE1:next_state = check2?CASE1A:CASE1B;
CASE1A:next_state = DONE;
CASE1B:next_state = DONE;
CASE2:next_state = SHIFT;
SHIFT:next_state = (diff_exp==exp_diff)?SHIFT:SUB;
SUB:next_state = DONE;
DONE:next_state = available?START: DONE;
default:next_state = IDLE;
endcase 
end
always@(posedge clk)
begin
if(!available)
state_reg<=IDLE;
else
state_reg<=next_state;
end
always@(posedge clk)
begin
if(state_reg==CASE1A)
ans <= 32'd0;
else if(state_reg==CASE1B)
ans <= {a_oper[31],exp_diff,(a_oper[22:0]-b_oper[22:0])};
else if(state_reg==SHIFT) begin
b_shift <= b_oper[22:0] >> 1;
diff_exp <=diff_exp+1;
end
else if (state_reg==SUB) ans<={a[31],exp_diff,(a_oper[22:0]-b_shift)};
end
assign out = ans;
assign status = (state_reg == START || state_reg ==CASE1 ||state_reg == CASE1A ||state_reg == CASE1B ||state_reg == CASE2 ||state_reg == SHIFT || state_reg ==SUB);
assign done = (state_reg == DONE); 
endmodule
