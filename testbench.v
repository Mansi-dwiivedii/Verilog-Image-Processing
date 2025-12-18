`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2025 18:55:55
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


module testbench(

    );



 
    parameter WIDTH  = 768;
    parameter HEIGHT = 512;
    

    reg HCLK;
    reg HRESETn;
    reg [1:0] sel ;

    wire ctrl_done;

    wire [7:0] R [0:(WIDTH-1)*(HEIGHT-1)];
    wire [7:0] G [0:(WIDTH-1)*(HEIGHT-1)];
    wire [7:0] B [0:(WIDTH-1)*(HEIGHT-1)];

 
    always #5 HCLK = ~HCLK;


    img_read #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .INFILE("C:/Users/268233/Desktop/5th sem/RGB.hex")) uut_read (
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .ctrl_done(ctrl_done),
        .sel(sel)    
    );



  
    initial begin
       
        HCLK = 0;
        HRESETn = 0;
        sel=2'b01;
        #50 HRESETn = 1; // release reset after 50ns
        
        // Wait until image processing completes
        wait (ctrl_done);
        #50; // small delay before
    #50; $finish;  
   end


endmodule

