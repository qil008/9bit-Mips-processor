// cache memory/register file
// default address pointer width = 3, for 8 registers
module reg_file #(parameter pw=3)(
  input      clk       ,
  input      reset     ,
  input[7:0] dat_in    ,
  input      wr_en     ,           
  input 		 wr_default,		  
  input      rd_default,
  input[pw-1:0] wr_addr  ,		  
                rd_addrA ,		  
			       rd_addrB ,
  
  output logic[7:0] datA_out, 
                    datB_out);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep


  logic[pw-1:0] wr_muxed_addr;
  
  assign wr_muxed_addr = wr_default ? 7 : wr_addr; // Select core[7] if wr_default = 1, else wr_addr

  // Reads are combinational
  assign datA_out = rd_default ? core[6] : core[rd_addrA];
  assign datB_out = rd_default ? core[7] : core[rd_addrB];

  // Writes are sequential (clocked)
  always_ff @(posedge clk)
    if(reset) begin
		core[0] <= 128;
		core[1] <= 0;
		core[2] <= 0;
		core[3] <= 0;
		core[4] <= 0;
		core[5] <= 0;
		core[6] <= 0;
		core[7] <= 0;
	 end
	 else begin
		if(wr_en)
		  core[wr_muxed_addr] <= dat_in;
	 end
endmodule
