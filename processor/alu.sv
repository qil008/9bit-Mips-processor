// combinational -- no clock
module alu(
  input[3:0] alu_cmd,    
  input[7:0] inA, inB,	     
  output logic[7:0] rslt,
  output logic isZero
);

always_comb begin 
  // default values
  rslt = 0;               
  isZero = 0;
  case (alu_cmd)
	4'b0000, 4'b0011, 4'b0101 : begin  // unsigned add 2 8-bit
	  rslt = inA + inB;
	end
	4'b0001: begin           // xor 2 8-bit
	  rslt = inA ^ inB;
	end
	4'b0010: begin           // xor all bits of second operand
	  rslt = ^ inB;
	end
	4'b0100: begin           // pass through second operand
	  rslt = inB;
	end
	4'b0110: begin           // test equality
	  if(inA == inB)
	    isZero = 1;
	end
	4'b0111: begin           // test inequality
	  if(inA != inB)
	    isZero = 1;
	end
	4'b1000: begin           // unsigned add immediate
	  rslt = inB + inA + 1;
	end
	4'b1001: begin           // unsigned sub immediate
	  rslt = inB - (inA + 1);
	end
	4'b1010: begin           // logical shift left
	  rslt = inB << (inA + 1);     
	end
	4'b1011: begin           // logical shift right
	  rslt = inB >> (inA + 1);    
	end
	default: begin
		rslt = 0;
		isZero = 0;
	end
  endcase
end
   
endmodule