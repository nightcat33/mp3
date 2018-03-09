import lc3b_types::*;

module cpu_datapath (
	wishbone.master ifetch
);

assign ifetch.ADR = pc_out[11:0];
assign mem_rdata = ifetch.DAT_S;
assign ifetch.DAT_M = mem_wdata;
assign clk = ifetch.CLK;
// need combination logic to deal with SEL signal

logic [15:0] pc_out;
logic [15:0] pcmux_out;
logic [15:0] regfilemux_out;
logic [15:0] sr1_out;
logic [15:0] sr2_out;

logic [15:0] pc_plus2_out;
logic [2:0]	cc_out;
logic [2:0] gencc_out;
logic [2:0] dest; // IR[11:9]
logic [2:0] storemux_out;
logic [2:0] sr2;

logic branch_enable;


logic [127:0] mem_rdata;
logic [127:0] mem_wdata;

logic [1:0] pcmux_sel; // original signal from ctrl rom
logic [1:0] pcmux_sel_branch;

logic [8:0] offset9; // IR[8:0]
logic [15:0] adj9_out;
logic [15:0] br_add_9_out;

lc3b_control_word ctrl;

plus2 plus_2
(
    .in(pc_out),
    .out(pc_plus2_out)
);


mux4 PCMUX 
(
	.sel(pcmux_sel_branch),
	.a(pc_plus2_out),
	.b(br_add_9_out), // br instruction, PC = PC + (SEXT(PCoffset9) << 1);
	.c(),
	.d(),
	.f(pcmux_out)
);

branch_box branch
(
	.branch_enable(branch_enable),
	.pcmux_sel(pcmux_sel),
	.pcmux_sel_branch(pcmux_sel_branch)
);


// branch logic
nzp cccomp
(
	.a(dest),
	.b(cc_out),
	.f(branch_enable)
);

register #(.width(3)) cc
(
    .clk(clk),
    .load(ctrl.load_cc),
    .in(gencc_out),
    .out(cc_out)
);

gencc GENCC
(
    .in(regfilemux_out), // from regfile mux, this value also goes into regfile
    .out(gencc_out)
);

regfile REGFILE
(
    .clk(clk),
    .load(ctrl.load_regfile),
    .in(regfilemux_out),
    .src_a(storemux_out),
    .src_b(sr2),
    .dest(dest),
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);

adj #(.width(9)) adj9
(
    .in(offset9),
    .out(adj9_out)
);

adder br_add_9
(
	.a(adj9_out),
	.b(pc_out),
	.f(br_add_9_out)
);

control_rom control_word
(
	.opcode(),
	.ctrl(ctrl)
);

// default width 16
register pc 
(
	.clk(clk),
	// always loading
	.load(1'b1),
	.in(pcmux_out),
    .out(pc_out)
);


endmodule


