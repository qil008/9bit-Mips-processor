module PC_LUT #(parameter D=10)(
  input       [ 4:0]  addr,	   // possibly 2^5 different locations
  output logic[D-1:0] target
);

  always_comb case(addr)
    0: target = 6;   
	 1: target = 19;   
	 2: target = 27;
    3: target = 35;
	 4: target = 42;
	 5: target = 59;
	 6: target = 67;
	 7: target = 75;
	 8: target = 82;
	 9: target = 104;
	 10:target = 112;
	 11:target = 120;
	 12:target = 127;
	 13:target = 139;
	 14:target = 156;
	 15:target = 2;
	 16:target = 202;
	 17:target = 214;
	 18:target = 264;
	 
	default: target = 0;  
  endcase

endmodule
