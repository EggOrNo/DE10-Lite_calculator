library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
entity codeto7seg is
	port (res: in std_logic_vector(1 downto 0);
		HEX0, HEX1, HEX2, HEX3: out std_logic_vector(0 to 6));
end;
architecture synth of codeto7seg is

begin
	
	process(res)
	begin
		case res is 
		when "00" =>
			HEX3 <= "1111111";
			HEX2 <= "0001000"; -- ADD
			HEX1 <= "0000001";
			HEX0 <= "0000001";
			
		when "01" =>
			HEX3 <= "1111111";
			HEX2 <= "0100100"; -- SUB
			HEX1 <= "1000001";
			HEX0 <= "0000000";				
			
		when "10" =>
			HEX3 <= "0011001"; -- MUL
			HEX2 <= "0001101";
			HEX1 <= "1000001";
			HEX0 <= "1110001";
			
		when "11" =>
			HEX3 <= "1111111"; -- DEL
			HEX2 <= "0000001";
			HEX1 <= "0110000";
			HEX0 <= "1110001";
				
		end case;
		
	end process;
end;