library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity resultProc is
	port (input: in std_logic_vector(39 downto 0);
		isbig, isneg: out std_logic;
		result: out std_logic_vector(39 downto 0));
end;
architecture synth of resultProc is

begin
	process(input)
	begin
		if ( (input(39) and input(38) and input(37) and input(36) 
				and input(35) and input(34) and input(33) and input(32)) = '1') then
			isneg <= '1';
			result <= not(input) + '1';
			isbig <= '0';
			
		else
			
			isneg <= '0';
			result <= input;
			if (input > "0000000000000000000011110100001000111111") then
				isbig <= '1';
			else
				isbig <= '0';
			end if;
		end if;
	end process;
end;