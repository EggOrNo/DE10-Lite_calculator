module bcdto7seg (
	input [3:0] bcd,
	output [0:6] symbol);

always_comb begin
	case (bcd)
		4'd0: symbol = 7'b0000001;
		4'd1: symbol = 7'b1001111;
		4'd2: symbol = 7'b0010010;
		4'd3: symbol = 7'b0000110;
		4'd4: symbol = 7'b1001100;
		4'd5: symbol = 7'b0100100;
		4'd6: symbol = 7'b0100000;
		4'd7: symbol = 7'b0001111;
		4'd8: symbol = 7'b0000000;
		4'd9: symbol = 7'b0000100;
		default: symbol = 7'b1111111;
	endcase
end

endmodule 