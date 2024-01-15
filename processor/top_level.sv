// sample top level design
module top_level #(parameter K = 0)(
  input        clk, reset, 
  output logic done);
  parameter D = 10,             // program counter width
				A = 4;              // ALU command bit width

  wire        jump_en;          // pc singals
  wire[D-1:0] target,           
				  prog_ctr;
				  
  wire[8:0]   instr;            // instruction singals
  wire[3:0]   instr85;
  wire[1:0]   instr43;
  wire[2:0]   instr53,
				  instr20;
  wire[4:0]   instr40;
  
  assign instr85 = instr[8:5];
  assign instr43 = instr[4:3];
  assign instr53 = instr[5:3];
  assign instr20 = instr[2:0];
  assign instr40 = instr[4:0];
  				  			  
  wire[A-1:0] ALUOp;            // control decoder signals
  wire        MemOrALU,			  
				  MemWrite,
				  Branch,
				  rd_default,
				  wr_default,
				  ALUsrc1,
				  ALUsrc2,
				  RegWrite,
				  RegWriteSrc,
				  exit;
 
  wire[7:0]   regOut1,		     // RegFile signals, in addition to what is defined above
              regOut2,
				  regIn; 
			     
  wire[7:0]	  ALUout,           // ALU signals, in addition to what is defined above
              ALUin1,
				  ALUin2;
  wire        ALUis0;
  
  
  wire[7:0]   dataMem_out,      // data mem signals, in addition...
				  ALUMem_rslt;      // ALU mem rslt is the result out of the mux chosing whether alu or mem out 

				  
				  
				  

  PC #(.D(D)) 					     // program counter width D
    pc (.reset   ,
        .clk     ,
		  .jump_en ,
		  .target  ,
		  .prog_ctr);
  
  assign jump_en = ALUis0 && Branch;

  PC_LUT #(.D(D))               // lookup table width D
    lut (.addr  (instr40),
         .target         );   


  instr_ROM #(.D(D), .K(K)) 
			  ir(.prog_ctr,       // instruction rom
              .mach_code(instr));
 
  Control ctl(.instr(instr85),  // control decoder
   			  .ALUOp         ,
				  .MemOrALU      ,			  
				  .MemWrite      ,
				  .Branch        ,
				  .rd_default    ,
				  .wr_default    ,
				  .ALUsrc1       ,
				  .ALUsrc2       ,
				  .RegWrite      ,
				  .RegWriteSrc   ,
				  .exit          );

  reg_file #(.pw(3)) 
	 regf(.clk              ,     // register file
	      .reset            ,
			.dat_in(regIn)    ,
         .wr_en(RegWrite)  ,
			.wr_default       ,
			.rd_default       ,
         .rd_addrA(instr53),
         .rd_addrB(instr20),
         .wr_addr (instr20),      
         .datA_out(regOut1),
         .datB_out(regOut2)); 
  
  assign regIn = RegWriteSrc? regOut1: ALUMem_rslt;

  alu ALU(.alu_cmd(ALUOp),       // ALU
          .inA(ALUin1)   ,
		    .inB(ALUin2)   ,
		    .isZero(ALUis0),
		    .rslt(ALUout)  );  
  
  assign ALUin1 = ALUsrc1? instr43: regOut1;
  assign ALUin2 = ALUsrc2? instr40: regOut2;

  dat_mem datMem(.clk                 , // data Mem
					  .wr_en  (MemWrite)   , 
					  .addr(ALUout)        ,
					  .dat_in(regOut2)     , 
                 .dat_out(dataMem_out));
  
  assign ALUMem_rslt = MemOrALU? ALUout: dataMem_out;

  assign done = exit;
 
endmodule