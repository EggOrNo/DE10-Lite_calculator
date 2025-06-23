module btoBCD (
	input CLK, key1,
	input [1:0] stage,
	input [19:0] data,
	input [39:0] result,
	output [3:0] bcd5, bcd4, bcd3, bcd2, bcd1, bcd0);
logic [19:0] t, t0, t1, t2, t3, t4, t5, t6;
logic [3:0] st;
logic skey1, state;

always_ff@(stage, data, t) begin
	case (stage)
	2'd0: begin
		bcd0 <= data % 4'd10;
		bcd1 <= data / 20'd10 % 4'd10;
		bcd2 <= data / 20'd100 % 4'd10;
		bcd3 <= data / 20'd1000 % 4'd10;
		bcd4 <= data / 20'd10000 % 4'd10;
		bcd5 <= data / 20'd100000 % 4'd10;
	end
	
	2'd1: begin
		bcd0 <= {3'b0, data[0]};
		bcd1 <= {3'b0, data[1]};
		bcd2 <= 4'b0;
		bcd3 <= 4'b0;
		bcd4 <= 4'b0;
		bcd5 <= 4'b0;
	end
	
	2'd2: begin
		bcd0 <= data % 4'd10;
		bcd1 <= data / 20'd10 % 4'd10;
		bcd2 <= data / 20'd100 % 4'd10;
		bcd3 <= data / 20'd1000 % 4'd10;
		bcd4 <= data / 20'd10000 % 4'd10;
		bcd5 <= data / 20'd100000 % 4'd10;
	end
	
	default: begin
		bcd0 <= t % 4'd10;
		bcd1 <= t / 20'd10 % 4'd10;
		bcd2 <= t / 20'd100 % 4'd10;
		bcd3 <= t / 20'd1000 % 4'd10;
		bcd4 <= t / 20'd10000 % 4'd10;
		bcd5 <= t / 20'd100000 % 4'd10;
	end
	endcase
end

assign t0 = result % 20'd1000000;
assign t1 = result / 20'd10 % 20'd1000000;
assign t2 = result / 20'd100 % 20'd1000000;
assign t3 = result / 20'd1000 % 20'd1000000;
assign t4 = result / 20'd10000 % 20'd1000000;
assign t5 = result / 20'd100000 % 20'd1000000;
assign t6 = result / 20'd1000000 % 20'd1000000;

always_ff@(posedge CLK) begin
	if (~state) begin
		if (~key1) begin
			state <= 1'b1;
			skey1 <= 1'b0;
		end
	end
	else begin
		skey1 <= 1'b1;
		if (key1)
			state <= 1'b0;
	end
	if (&stage)
		case(st)
		4'd0: begin
			st <= 4'd1;
		end
		
		4'd1: begin
			if (t6 >= 20'd100000) begin
				st <= 4'd2;
				t <= t6;
			end
			else if (t5 >= 20'd100000) begin
				st <= 4'd3;
				t <= t5;
			end
			else if (t4 >= 20'd100000) begin
				st <= 4'd4;
				t <= t4;
			end
			else if (t3 >= 20'd100000) begin
				st <= 4'd5;
				t <= t3;
			end
			else if (t2 >= 20'd100000) begin
				st <= 4'd6;
				t <= t2;
			end
			else if (t1 >= 20'd100000) begin
				st <= 4'd7;
				t <= t1;
			end
			else begin
				st <= 4'd8;
				t <= t0;
			end
		end
		
		4'd2: if (~skey1) begin
			t <= t5;
			st <= st + 1'b1;
		end
		
		4'd3: if (~skey1) begin
			t <= t4;
			st <= st + 1'b1;
		end
		
		4'd4: if (~skey1) begin
			t <= t3;
			st <= st + 1'b1;
		end
		
		4'd5: if (~skey1) begin
			t <= t2;
			st <= st + 1'b1;
		end
		
		4'd6: if (~skey1) begin
			t <= t1;
			st <= st + 1'b1;
		end
		
		4'd7: if (~skey1) begin
			t <= t0;
			st <= st + 1'b1;
		end
		
		4'd8: if (~skey1) begin
			if (t6 >= 20'd100000) begin
				st <= 4'd2;
				t <= t6;
			end
			else if (t5 >= 20'd100000) begin
				st <= 4'd3;
				t <= t5;
			end
			else if (t4 >= 20'd100000) begin
				st <= 4'd4;
				t <= t4;
			end
			else if (t3 >= 20'd100000) begin
				st <= 4'd5;
				t <= t3;
			end
			else if (t2 >= 20'd100000) begin
				st <= 4'd6;
				t <= t2;
			end
			else if (t1 >= 20'd100000) begin
				st <= 4'd7;
				t <= t1;
			end
			else begin
				st <= 4'd8;
				t <= t0;
			end
		end
		
		default:
			st <= 4'b0;
			
		endcase
	else begin
		st <= 4'b0;
		t <= t0;
	end
end

endmodule 