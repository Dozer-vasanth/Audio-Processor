`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.12.2024 14:35:30
// Design Name: 
// Module Name: testbench
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


module testbench();
    
    reg reset, clk,enable;
    wire status,done;
    
    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0,testbench);
    end
    
    top_module M1(.enable(enable),.reset(reset),.clk(clk),.done(done),.rx(rx),.status(status));
    initial
    begin
        clk = 0;
        enable = 0;
        reset = 1;
        #10 reset = 0;
        #10 reset = 1;
        #500 enable = 1;
        #10 reset = 0;
        #10 reset = 1;
        #20 enable =0;
        #400 enable = 1;
        #20 enable =0;
        
        
    end
    
    initial
    begin
        #10000 $finish ;
    end
    
    initial
    begin
        forever
            #5 clk = ~clk;
    end
    
endmodule
