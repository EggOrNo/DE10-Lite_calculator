module operation (
	input key1, write,
	input [1:0] stage,
	input [19:0] data,
	output [39:0] result,
	output LEDR6, LEDR7);

logic [1:0] code;
logic [19:0] oper1, oper2;
logic isneg;

assign LEDR6 = isneg;
assign LEDR7 = isneg;
	
always_ff@(posedge write, negedge key1)
	case(stage)
	0: if (write)
			oper1 <= data;
	
	1: if (~key1)
			code <= data[1:0];
	
	2: if (write)
			oper2 <= data;
	
	default:
		code <= code;
	endcase

always_ff@(stage)
	if (&stage)
		case (code)
		0: result <= oper1 + oper2;
		
		1: if (oper1 > oper2)
			result <= oper1 - oper2;
		else
		begin
			result <= oper2 - oper1;
			isneg <= 1'b1;
		end
		
		2: result <= oper1 * oper2;
		
		3: result <= oper1 / oper2;
		
		default: result <= 40'd0;
		endcase
	else
		isneg <= 1'b0;
endmodule 