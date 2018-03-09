import lc3b_types::*;

module sign_extend #(parameter width = 16)
(
	input [width-1:0] in,
	output lc3b_word out
);

assign out = $signed(in);

endmodule : sign_extend

