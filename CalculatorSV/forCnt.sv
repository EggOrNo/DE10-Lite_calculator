module forCnt (
	input CLK, key1, reset,
	input [5:0] SW,
	input [1:0] stage,
	output [5:0] LEDR,
	output [19:0] cnt);

logic [2:0] change;
logic skey1;
logic [19:0] temp;

always_ff@(SW)
	if (SW[5]) change <= 3'd5;
	else if (SW[4]) change <= 3'd4;
	else if (SW[3]) change <= 3'd3;
	else if (SW[2]) change <= 3'd2;
	else if (SW[1]) change <= 3'd1; 
	else change <= 3'd0;

always_ff@(stage, change, key1) begin
	LEDR <= 6'b0;
	case (stage)
	2'd1: begin
		LEDR[1:0] <= SW[1:0];
		LEDR[5] <= ~key1;
	end
	
	2'd3: begin
		LEDR[5] <= ~key1;
	end
	
	default: begin
		LEDR[change] <= 1'b1;
	end
	
	endcase
end


always_ff@(posedge CLK)
	skey1 <= key1;

always_ff@(posedge reset, negedge skey1)
	if (reset) begin
		temp <= 20'b0;
	end
	
	else if (~stage[0])
		case (change)
		3'd0: begin
			if (temp >= 20'd999999)
				temp <= 20'b0;
			else
				temp += 1'b1;
		end
		
		3'd1: begin
			if (temp >= 20'd999990) 
				temp -= 20'd999990;
			else
				temp += 20'd10;
		end
		
		3'd2: begin
			if (temp >= 20'd999900) 
				temp -= 20'd999900;
			else
				temp += 20'd100;
		end
		
		3'd3: begin
			if (temp >= 20'd999000) 
				temp -= 20'd999000;
			else
				temp += 20'd1000;
		end
		
		3'd4: begin
			if (temp >= 20'd990000) 
				temp -= 20'd990000;
			else
				temp += 20'd10000;
		end
		
		3'd5: begin
			if (temp >= 20'd900000) 
				temp -= 20'd900000;
			else
				temp += 20'd100000;
		end
		
		default: begin
			if (temp >= 20'd999999)
				temp <= 20'b0;
			else
				temp += 1'b1;
		end
		
		endcase

always_ff@(reset, temp, SW) begin
	if (reset) begin
		cnt <= 20'b0;
	end
	
	else 
		case (stage)
		2'd0:
			cnt <= temp;
				
			
		2'd1: begin
			cnt[19:2] <= 18'b0;
			cnt[1:0] <= SW[1:0];
		end
		
		2'd2:
			cnt <= temp;
		
		default: 
			cnt <= 20'b0;
		
		endcase
end

endmodule 