module forStages (
	input CLK, key0,
	output write, reset,
	output [1:0] stage,
	output LEDR8, LEDR9);

logic state;

assign LEDR8 = ~stage[1] & stage[0];
assign LEDR9 = stage[1] & stage[0];

always_ff@(posedge CLK) begin
	
	case (state)
	0: begin
		reset <= 1'b0;
		if (~key0) begin
			write <= 1'b1;
			state <= 1'b1;
		end
	end
	1: begin
		write <= 1'b0;
		if (key0) begin
			stage += 1'b1;
			reset <= 1'b1;
			state <= 1'b0;
		end
	end
	default: state <= 1'b0;
	endcase
end

endmodule 