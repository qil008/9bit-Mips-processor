// lookup table
// deep 
// 9 bits wide; as deep as you wish
module instr_ROM #(parameter D=10, parameter K = 0)(
  input       [D-1:0] prog_ctr,    // prog_ctr	  address pointer
  output logic[ 8:0] mach_code);

  logic[8:0] core[2**D];
  initial							    // load the program
    case(K)
	   0: $readmemb("C:/Users/qianq/Desktop/cse141L/assembler/program1_mc.txt",core);
		1: $readmemb("C:/Users/qianq/Desktop/cse141L/assembler/program2_mc.txt",core);
		2: $readmemb("C:/Users/qianq/Desktop/cse141L/assembler/program3_mc.txt",core);
		default: $readmemb("C:/Users/qianq/Desktop/cse141L/assembler/program1_mc.txt",core);
    endcase
  always_comb  mach_code = core[prog_ctr];

endmodule
