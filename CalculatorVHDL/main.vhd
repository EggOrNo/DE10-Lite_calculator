library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity main is
	port (CLK, key0, key1: in std_logic;
		SW: in std_logic_vector(5 downto 1);
		LED: out std_logic_vector(5 downto 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(0 to 6);
		LED7, LED8, LED9: out std_logic;
		dot: out std_logic_vector(5 downto 0));
end;
architecture synth of main is

component stagesCnt
	port (CLK, key: in std_logic;
		outCnt: out std_logic_vector(1 downto 0));
end component;

component opCnt
	port (key, iscode, reset: in std_logic;
		pointer: in std_logic_vector(2 downto 0);
		outCnt: out std_logic_vector(19 downto 0));
end component;

component dataProc
	port (wr, isSt1, isSt2: in std_logic;
		opValue: in std_logic_vector(19 downto 0);
		result: out std_logic_vector(39 downto 0));
end component;

component resultProc
	port (input: in std_logic_vector(39 downto 0);
		isbig, isneg: out std_logic;
		result: out std_logic_vector(39 downto 0));
end component;

component bto7seg 
	port (res: in std_logic_vector(19 downto 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(0 to 6));
end component;

component codeto7seg
	port (res: in std_logic_vector(1 downto 0);
		HEX0, HEX1, HEX2, HEX3: out std_logic_vector(0 to 6));
end component;

component control
	port (CLK, key0, key1: in std_logic;
		SW: in std_logic_vector(5 downto 1);
		stValue: in std_logic_vector(1 downto 0);
		opValue: in std_logic_vector(19 downto 0);
		resValue: in std_logic_vector(39 downto 0);
		isneg: in std_logic;
		isbig: in std_logic;
		pointer: out std_logic_vector(2 downto 0);
		reset, wr, sKey1: out std_logic;
		isSt1, isSt2: out std_logic;
		LED: out std_logic_vector(5 downto 0);
		dot: out std_logic_vector(5 downto 0);
		LED9: out std_logic;
		outCodeValue: out std_logic_vector(1 downto 0);
		outResValue: out std_logic_vector(19 downto 0));
end component;

signal stValue, outCodeValue: std_logic_vector(1 downto 0);
signal opValue, outResValue: std_logic_vector(19 downto 0);
signal resValue, resProc: std_logic_vector(39 downto 0);
signal pointer: std_logic_vector(2 downto 0);
signal isneg, isbig, reset, wr, sKey1, isSt1, isSt2: std_logic;
signal hex10, hex11, hex12, hex13, hex14, hex15, hex20, hex21, hex22, hex23: std_logic_vector(0 to 6);

begin
	MODULE0: control
	port map (CLK, key0, key1, SW, stValue, opValue, resValue, isneg, isbig, pointer, 
		reset, wr, sKey1, isSt1, isSt2, LED, dot, LED9, outCodeValue, outResValue);
	LED8 <= stValue(1) and not(stValue(0));
	LED7 <= not(stValue(1)) and stValue(0);
	
	MODULE1: stagesCnt
	port map (CLK, key0, stValue);

	MODULE2: opCnt
	port map (sKey1, isSt1, reset, pointer, opValue);

	MODULE3: dataProc
	port map (wr, isSt1, isSt2, opValue, resProc);

	MODULE4: resultProc
	port map (resProc, isbig, isneg, resValue);
	
	MODULE5: bto7seg 
	port map (outResValue, hex10, hex11, hex12, hex13, hex14, hex15);
	
	MODULE6: codeto7seg
	port map (outCodeValue, hex20, hex21, hex22, hex23);
	
	process(stValue, outResValue, outCodeValue)
	begin
		if ((stValue(1) or stValue(0)) = '1') then
			HEX0 <= hex10;
			HEX1 <= hex11;
			HEX2 <= hex12;
			HEX3 <= hex13;
			HEX4 <= hex14;
			HEX5 <= hex15;
		else
			HEX0 <= hex20;
			HEX1 <= hex21;
			HEX2 <= hex22;
			HEX3 <= hex23;
			HEX4 <= "1111111";
			HEX5 <= "1111111";
		end if;
	end process;
	
end;