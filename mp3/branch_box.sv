module branch_box (

	input branch_enable,
	input logic [1:0] pcmux_sel,

	output logic [1:0] pcmux_sel_branch
	
);


always_comb
begin
	if (branch_enable)
	begin
		pcmux_sel_branch = 2'b01;
	end
	else
	begin
		pcmux_sel_branch = pcmux_sel; // no branch, keep pcmux_sel as original value
	end

end

endmodule