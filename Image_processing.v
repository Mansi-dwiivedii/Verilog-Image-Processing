`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.10.2025 18:55:36
// Design Name: 
// Module Name: img_read
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

///////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2025 17:05:08
// Design Name: 
// Module Name: img_read
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 

//////////////////////////////////////////////////////////////////////////////////


module img_read
#(
    parameter WIDTH  = 768,
         HEIGHT = 512,
     INFILE = "C:/Users/268233/Desktop/5th sem/RGB.hex",
     VALUE  = 100,       // brightness adjustment        // 1 = addition, 0 = subtraction
     THRESHOLD = 90// for threshold operation
      
)
(
    input HCLK,
    input HRESETn,
    input [1:0] sel,
    output reg [7:0] DATA_R0,
    output reg [7:0] DATA_G0,
    output reg [7:0] DATA_B0,
    output reg [7:0] DATA_R1,
    output reg [7:0] DATA_G1,
    output reg [7:0] DATA_B1,
    output reg ctrl_done
);


// Internal signals

parameter sizeOfLengthReal = WIDTH*HEIGHT*3; // total bytes in image

reg [7:0] total_memory [0 : sizeOfLengthReal-1];
integer org_R [0:WIDTH*HEIGHT-1];
integer org_G [0:WIDTH*HEIGHT-1];
integer org_B [0:WIDTH*HEIGHT-1];
reg [7:0] R [0:(WIDTH)*(HEIGHT)-1];
reg [7:0] G [0:(WIDTH)*(HEIGHT)-1];
reg [7:0] B [0:(WIDTH)*(HEIGHT)-1];
integer x, y;
real matrix [0:2][0:2];
reg [18:0] data_count;
integer value,value1,value2,value4;

integer tempR0,tempR1,tempG0,tempG1,tempB0,tempB1;

//-------------------------------------------------
// Read image file
//-------------------------------------------------
initial begin
    $readmemh(INFILE, total_memory, 0, sizeOfLengthReal-1);
    // Separate RGB components
    for (x=0; x<HEIGHT; x=x+1) begin
        for (y=0; y<WIDTH; y=y+1) begin
            org_R[WIDTH*x+y] = total_memory[WIDTH*3*(x)+3*y + 0];
//            $display("a=%h",total_memory[WIDTH*3*(HEIGHT-x-1)+3*y + 0]);
            org_G[WIDTH*x+y] = total_memory[WIDTH*3*(x)+3*y + 1];
            org_B[WIDTH*x+y] = total_memory[WIDTH*3*(x)+3*y + 2];
        end
    end
    
//            $display("a=%h",total_memory[sizeOfLengthReal-1]);
    
//    for (x = 0; x<WIDTH*HEIGHT; x=x+1) begin
//        R[x] = org_R[x];
//        G[x] = org_G[x];
//        B[x] = org_B[x];    
//    end
    #20;
 $display("sel=%d",sel);
 
 
 
 
 
   case (sel) 
   
   //edge detection
	2'b00 : begin	
	

        matrix[0][0] = -1;
      matrix[0][1] = 0;
      matrix[0][2] = +1;
        matrix[1][0] = -2;
          matrix[1][1] = 0;
            matrix[1][2] = 2;
              matrix[2][0] = -1;  matrix[2][1] = 0;
                matrix[2][2] = 1;
   for (x=1; x<HEIGHT-1; x=x+1) begin
        for (y=1; y<WIDTH-1; y=y+1) begin
          R[((x)*(WIDTH) + y)] = 
      (org_R[(x-1)*WIDTH + (y-1)] * matrix[0][0] +
      org_R[(x-1)*WIDTH + y    ] * matrix[0][1] +
      org_R[(x-1)*WIDTH + (y+1)] * matrix[0][2] +
      org_R[x    * WIDTH + (y-1)] * matrix[1][0] +
      org_R[x    * WIDTH + y    ] * matrix[1][1] +
      org_R[x    * WIDTH + (y+1)] * matrix[1][2] +
      org_R[(x+1)* WIDTH + (y-1)] * matrix[2][0] +
      org_R[(x+1)* WIDTH + y    ] * matrix[2][1] +
      org_R[(x+1)* WIDTH + (y+1)] * matrix[2][2])/9.0;
      
          B[((x)*(WIDTH) + y)] = 
      (org_B[(x-1)*WIDTH + (y-1)] * matrix[0][0] +
      org_B[(x-1)*WIDTH + y    ] * matrix[0][1] +
      org_B[(x-1)*WIDTH + (y+1)] * matrix[0][2] +
      org_B[x    * WIDTH + (y-1)] * matrix[1][0] +
      org_B[x    * WIDTH + y    ] * matrix[1][1] +
      org_B[x    * WIDTH + (y+1)] * matrix[1][2] +
      org_B[(x+1)* WIDTH + (y-1)] * matrix[2][0] +
      org_B[(x+1)* WIDTH + y    ] * matrix[2][1] +
      org_B[(x+1)* WIDTH + (y+1)] * matrix[2][2])/9.0;
      
          G[(x)*(WIDTH) + y] = 
      (org_G[(x-1)*WIDTH + (y-1)] * matrix[0][0] +
      org_G[(x-1)*WIDTH + y    ] * matrix[0][1] +
      org_G[(x-1)*WIDTH + (y+1)] * matrix[0][2] +
      org_G[x    * WIDTH + (y-1)] * matrix[1][0] +
      org_G[x    * WIDTH + y    ] * matrix[1][1] +
      org_G[x    * WIDTH + (y+1)] * matrix[1][2] +
      org_G[(x+1)* WIDTH + (y-1)] * matrix[2][0] +
      org_G[(x+1)* WIDTH + y    ] * matrix[2][1] +
      org_G[(x+1)* WIDTH + (y+1)] * matrix[2][2])/9.0;     
//        R[(y) *(WIDTH) + (x)] = org_R[(y)*WIDTH + (x)];
//        G[(y) *(WIDTH) + (x)] = org_G[(y)*WIDTH + (x)];
//        B[(y) *(WIDTH) + (x)] = org_B[(y)*WIDTH + (x)];
      data_count=data_count+1;
           
        end
    end
    
    end 
    
    
  

	//invert
	//pixel by pixel
   2'b01 : begin
      DATA_R0 = 0;
      DATA_G0 = 0;
      DATA_B0 = 0;                                       
    
 
   for (x=0; x<HEIGHT; x=x+1) begin
        for (y=0; y<WIDTH; y=y+1) begin
   
          
           DATA_R0=255-org_B[WIDTH * x +y  ] ;
           DATA_G0=255-org_R[WIDTH * x + y  ];
           DATA_B0=255-org_G[WIDTH * x + y  ];
//            value4 = (org_B[WIDTH * x + y+1  ] + org_R[WIDTH * x + y+1  ] +org_G[WIDTH * x + y+1  ])/3;
//           DATA_R1=255-value4;
//           DATA_G1=255-value4;
//           DATA_B1=255-value4;
           
            R[WIDTH* x+y]=DATA_R0;
           G[WIDTH* x+y]=DATA_G0;
           B[WIDTH* x+y]=DATA_B0;
//            R[WIDTH* x+y+1]=DATA_R1;
//           G[WIDTH* x+y+1]=DATA_G1;
//           B[WIDTH* x+y+1]=DATA_B1;
              data_count=data_count+1;
           
   
   end
   end
 
   
   end
    
    
    //grayscale
    //pixel by pixel
    2'b10 : begin
    DATA_R0 = 0;
      DATA_G0 = 0; 
      DATA_B0 = 0;                                       
    
 
   for (x=0; x<HEIGHT; x=x+1) begin
        for (y=0; y<WIDTH; y=y+1) begin
   
          
          
            value4 = (org_B[WIDTH * x + y ] + org_R[WIDTH * x + y ] +org_G[WIDTH * x + y  ])/3;
           DATA_R0=value4;
           DATA_G0=value4;
           DATA_B0=value4;
           
            R[WIDTH* x+y]=DATA_R0;
           G[WIDTH* x+y]=DATA_G0;
           B[WIDTH* x+y]=DATA_B0;
              data_count=data_count+1;
           
   
   end
   end
  
  end
  
  //blur
  //kernel operation
  
  2'b11 : begin	
	

        matrix[0][0] = 1;
      matrix[0][1] = 1;
      matrix[0][2] = 1;
        matrix[1][0] = 1;
          matrix[1][1] = 1;
            matrix[1][2] = 1;
              matrix[2][0] = 1;  matrix[2][1] = 1;
                matrix[2][2] = 1;
   for (x=1; x<HEIGHT-1; x=x+1) begin
        for (y=1; y<WIDTH-1; y=y+1) begin
          R[((x)*(WIDTH) + y)] = 
      (org_R[(x-1)*WIDTH + (y-1)] * matrix[0][0] +
      org_R[(x-1)*WIDTH + y    ] * matrix[0][1] +
      org_R[(x-1)*WIDTH + (y+1)] * matrix[0][2] +
      org_R[x    * WIDTH + (y-1)] * matrix[1][0] +
      org_R[x    * WIDTH + y    ] * matrix[1][1] +
      org_R[x    * WIDTH + (y+1)] * matrix[1][2] +
      org_R[(x+1)* WIDTH + (y-1)] * matrix[2][0] +
      org_R[(x+1)* WIDTH + y    ] * matrix[2][1] +
      org_R[(x+1)* WIDTH + (y+1)] * matrix[2][2])/9.0;
      
          B[((x)*(WIDTH) + y)] = 
      (org_B[(x-1)*WIDTH + (y-1)] * matrix[0][0] +
      org_B[(x-1)*WIDTH + y    ] * matrix[0][1] +
      org_B[(x-1)*WIDTH + (y+1)] * matrix[0][2] +
      org_B[x    * WIDTH + (y-1)] * matrix[1][0] +
      org_B[x    * WIDTH + y    ] * matrix[1][1] +
      org_B[x    * WIDTH + (y+1)] * matrix[1][2] +
      org_B[(x+1)* WIDTH + (y-1)] * matrix[2][0] +
      org_B[(x+1)* WIDTH + y    ] * matrix[2][1] +
      org_B[(x+1)* WIDTH + (y+1)] * matrix[2][2])/9.0;
      
          G[(x)*(WIDTH) + y] = 
      (org_G[(x-1)*WIDTH + (y-1)] * matrix[0][0] +
      org_G[(x-1)*WIDTH + y    ] * matrix[0][1] +
      org_G[(x-1)*WIDTH + (y+1)] * matrix[0][2] +
      org_G[x    * WIDTH + (y-1)] * matrix[1][0] +
      org_G[x    * WIDTH + y    ] * matrix[1][1] +
      org_G[x    * WIDTH + (y+1)] * matrix[1][2] +
      org_G[(x+1)* WIDTH + (y-1)] * matrix[2][0] +
      org_G[(x+1)* WIDTH + y    ] * matrix[2][1] +
      org_G[(x+1)* WIDTH + (y+1)] * matrix[2][2])/9.0;     
//        R[(y) *(WIDTH) + (x)] = org_R[(y)*WIDTH + (x)];
//        G[(y) *(WIDTH) + (x)] = org_G[(y)*WIDTH + (x)];
//        B[(y) *(WIDTH) + (x)] = org_B[(y)*WIDTH + (x)];
      data_count=data_count+1;
           
        end
    end
    
    end
endcase
    
    
    ctrl_done = 1'b1;
//    $writememh("C:/Users/268233/Desktop/5th sem/total.hex",total_memory);
    $writememh("C:/Users/268233/Desktop/5th sem/R_dump.hex",R);
    $writememh("C:/Users/268233/Desktop/5th sem/G_dump.hex",G);
    $writememh("C:/Users/268233/Desktop/5th sem/B_dump.hex",B);
  end

    

endmodule  

