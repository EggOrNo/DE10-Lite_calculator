module temp (
	input CLK, skey1,
	input [39:0] result,
	input [1:0] stage,
	output [2:0] st,
	output [19:0] t0, t1, t2, t3, t4, t5, t6, t);
	
logic state;
assign t0 = result % 20'd1000000;
assign t1 = result / 20'd10 % 20'd1000000;
assign t2 = result / 20'd100 % 20'd1000000;
assign t3 = result / 20'd1000 % 20'd1000000;
assign t4 = result / 20'd10000 % 20'd1000000;
assign t5 = result / 20'd100000 % 20'd1000000;
assign t6 = result / 20'd1000000 % 20'd1000000;

always_ff@(posedge CLK)
	if (&stage)
		case(st)
		3'd0: 
		begin
			if (t6 >= 20'd100000) begin
				st <= 3'd1;
				t <= t6;
			end
			else if (t5 >= 20'd100000) begin
				st <= 3'd2;
				t <= t5;
			end
			else if (t4 >= 20'd100000) begin
				st <= 3'd3;
				t <= t4;
			end
			else if (t3 >= 20'd100000) begin
				st <= 3'd4;
				t <= t3;
			end
			else if (t2 >= 20'd100000) begin
				st <= 3'd5;
				t <= t2;
			end
			else if (t1 >= 20'd100000) begin
				st <= 3'd6;
				t <= t1;
			end
			else begin
				st <= 3'd7;
				t <= t0;
			end
			state <= 1'b1;
		end
		
		3'd1: if (~skey1 & state) 
		begin
			t <= t5;
			st <= st + 1'b1;
			state <= 1'b0;
		end
		else if (skey1)
			state <= 1'b1;
		
		3'd2: if (~skey1 & state) 
		begin
			t <= t4;
			st <= st + 1'b1;
			state <= 1'b0;
		end
		else if (skey1)
			state <= 1'b1;
		
		3'd3: if (~skey1 & state) 
		begin
			t <= t3;
			st <= st + 1'b1;
			state <= 1'b0;
		end
		else if (skey1)
			state <= 1'b1;
		
		3'd4: if (~skey1 & state) 
		begin
			t <= t2;
			st <= st + 1'b1;
			state <= 1'b0;
		end
		else if (skey1)
			state <= 1'b1;
		
		3'd5: if (~skey1 & state) 
		begin
			t <= t1;
			st <= st + 1'b1;
			state <= 1'b0;
		end
		else if (skey1)
			state <= 1'b1;
		
		3'd6: if (~skey1 & state) 
		begin
			t <= t0;
			st <= st + 1'b1;
			state <= 1'b0;
		end
		else if (skey1)
			state <= 1'b1;
		
		3'd7: if (~skey1 & state) 
		begin
			if (t6 >= 20'd100000) begin
				st <= 3'd1;
				t <= t6;
			end
			else if (t5 >= 20'd100000) begin
				st <= 3'd2;
				t <= t5;
			end
			else if (t4 >= 20'd100000) begin
				st <= 3'd3;
				t <= t4;
			end
			else if (t3 >= 20'd100000) begin
				st <= 3'd4;
				t <= t3;
			end
			else if (t2 >= 20'd100000) begin
				st <= 3'd5;
				t <= t2;
			end
			else if (t1 >= 20'd100000) begin
				st <= 3'd6;
				t <= t1;
			end
			else begin
				st <= 3'd7;
				t <= t0;
			end
			state <= 1'b0;
		end
		else if (skey1)
			state <= 1'b1;
		
		default:
			st <= 3'b0;
			
		endcase
	else
		st <= 3'b0;
	
endmodule 