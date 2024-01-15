// control decoder
module Control #(parameter opwidth = 4, mcodebits = 4)(
  input [mcodebits-1:0] instr,

  output logic [opwidth-1:0] ALUOp,
  output logic MemOrALU,			  
				   MemWrite,
				   Branch,
				   rd_default,
				   wr_default,
				   ALUsrc1,
				   ALUsrc2,
				   RegWrite,
				   RegWriteSrc,
				   exit
);

  always_comb begin
    // defaults
	 ALUOp       = 0;
	 MemOrALU    = 0;			  
	 MemWrite    = 0;
	 Branch      = 0;
	 rd_default  = 0;
	 wr_default  = 0;
	 ALUsrc1     = 0;
	 ALUsrc2     = 0;
	 RegWrite    = 0;
	 RegWriteSrc = 0;
	 exit        = 0;
    
    case(instr)    
      4'b0000, 4'b0001: begin		// ADD 
                 ALUOp = 4'b0000;      
					  MemOrALU    = 1;			  
					  wr_default  = 1;
					  RegWrite    = 1;		
               end
      4'b0010: begin             // XOR
                 ALUOp = 4'b0001;      
					  MemOrALU    = 1;			  
					  rd_default  = 1;
					  RegWrite    = 1;
               end
      4'b0011: begin             // XORB
                 ALUOp = 4'b0010;      
					  MemOrALU    = 1;			  
					  rd_default  = 1;
					  RegWrite    = 1;
               end
		4'b0100: begin             // LW
					  ALUOp = 4'b0011;      
					  rd_default  = 1;
					  wr_default  = 1;
					  ALUsrc2     = 1;
					  RegWrite    = 1;
					end
		4'b0101: begin             // LWI
					  ALUOp = 4'b0100;      
					  MemOrALU    = 1;			    
					  wr_default  = 1;
					  ALUsrc2     = 1;
					  RegWrite    = 1;
               end
		4'b0110: begin             // SW
					  ALUOp = 4'b0101;      		  
					  MemWrite    = 1;
					  rd_default  = 1;
					  ALUsrc2     = 1;	
					end
      4'b0111: begin             // EXIT
					  exit        = 1;	
					end
		4'b1000: begin             // BRE
					  ALUOp = 4'b0110;      
					  Branch      = 1;
					  rd_default  = 1;	
					end
		4'b1001: begin             // BRNE
					  ALUOp = 4'b0111;      
					  Branch      = 1;
					  rd_default  = 1;
					end 
		4'b1010: begin             // ADDI + (add immediate)
					  ALUOp = 4'b1000;      
					  MemOrALU    = 1;			  
					  wr_default  = 1;
					  ALUsrc1     = 1;
					  RegWrite    = 1;
					end
      4'b1011: begin             // ADDI - (sub immediate)
					  ALUOp = 4'b1001;      
					  MemOrALU    = 1;			  
					  wr_default  = 1;
					  ALUsrc1     = 1;
					  RegWrite    = 1;
					end	
      4'b1100: begin             // SHIFTI + (shift left)
					  ALUOp = 4'b1010;      
					  MemOrALU    = 1;			  
					  wr_default  = 1;
					  ALUsrc1     = 1;
					  RegWrite    = 1;
					end
      4'b1101: begin             // SHIFTI - (shift right)
					  ALUOp = 4'b1011;      
					  MemOrALU    = 1;			  
					  wr_default  = 1;
					  ALUsrc1     = 1;
					  RegWrite    = 1;
					end		
      4'b1110, 4'b1111: begin    // MOV
					  RegWrite    = 1;
					  RegWriteSrc = 1;
               end
    endcase
  end
	
endmodule