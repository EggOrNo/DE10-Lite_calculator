module Calc (
	input CLK, key0, key1,
	input [5:0] SW,
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output [5:0] LEDR,
	output LEDR6, LEDR7, LEDR8, LEDR9);

logic write, reset; 
logic [1:0] stage;
forStages module1(CLK, key0, write, reset, stage, LEDR8, LEDR9);

logic [19:0] data;
forCnt module2(CLK, key1, reset, SW, stage, LEDR, data);

logic [39:0] result;
operation module3(key1, write, stage, data, result, LEDR6, LEDR7);

logic [3:0] bcd5, bcd4, bcd3, bcd2, bcd1, bcd0;
btoBCD module4(CLK, key1, stage, data, result, bcd5, bcd4, bcd3, bcd2, bcd1, bcd0);

bcdto7seg mod5(bcd5, HEX5);
bcdto7seg mod4(bcd4, HEX4);
bcdto7seg mod3(bcd3, HEX3);
bcdto7seg mod2(bcd2, HEX2);
bcdto7seg mod1(bcd1, HEX1);
bcdto7seg mod0(bcd0, HEX0);

endmodule 