library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity stagesCnt is
	port (CLK, key: in std_logic;
		outCnt: out std_logic_vector(1 downto 0));
end;
architecture synth of stagesCnt is

signal cnt: std_logic_vector(1 downto 0);
signal nextSt: std_logic;
begin
	outCnt <= cnt;
	process(CLK)
	begin
		if rising_edge(CLK) then
			case nextSt is
			when '0' =>
				if (key = '0') then
					nextSt <= '1';
				end if;
				
			when '1' =>
				if (key = '1') then
					cnt <= cnt + '1';
					nextSt <= '0';
				end if;
				
			when others =>
				nextSt <= '0';
			end case;
			
		end if;
	end process;
end;