
// sign extension instructions
// ADD imm5
// AND imm5
// LDB offset6
// STB offset6

// ADJ 
// BR ADJ9
// JSR ADJ11
// LDI ADJ6
// LDR ADJ6
// lea ADJ9
// STI ADJ6
// STR ADJ6

// UNADJ 
// TRAP trapvect8

// LDB DR = ZEXT(mem[BaseR + SEXT(offset6)]);
import lc3b_types::*;


module control_rom
(
    input lc3b_opcode opcode,
    output lc3b_control_word ctrl
);

// cp1 ADD, AND, NOT, LDR, STR, and BR
// SR1 [8:6]
// SR2 [2:0]
// DR [11:9]

always_comb
begin
    /* Default assignments */
    ctrl.opcode = opcode;
    ctrl.aluop = alu_pass;
    ctrl.load_cc = 1’b0;
    ctrl.load_regfile = 0;

    ctrl.pc_sel = 2'b00;
    /* ... other defaults ... */
    /* Assign control signals based on opcode */
    case(opcode)
        op_add: begin
            ctrl.aluop = alu_add;
            ctrl.load_regfile = 1;
            ctrl.load_cc = 1;
		end
        op_and: begin
            ctrl.aluop = alu_and;
            ctrl.load_regfile = 1;
            ctrl.load_cc = 1;
		end
		op_not: begin
			ctrl.aluop = alu_not;
			ctrl.load_regfile = 1;
            ctrl.load_cc = 1;
		end
		op_ldr: begin
			ctrl.load_regfile = 1;
            ctrl.load_cc = 1;
		end

		op_str: begin
			ctrl.load_regfile = 1;
			ctrl.load_cc = 1;
		end

		op_br: begin
			// ctrl.pc_sel = 2'b01;
		end

        /* ... other opcodes ... */
        default: begin
            ctrl = 0;

		end 
	endcase
end

endmodule : control_rom
/* Unknown opcode, set control word to zero */



