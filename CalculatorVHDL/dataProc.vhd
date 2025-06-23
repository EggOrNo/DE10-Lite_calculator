library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
entity dataProc is
	port (wr, isSt1, isSt2: in std_logic;
		opValue: in std_logic_vector(19 downto 0);
		result: out std_logic_vector(39 downto 0));
end;
architecture synth of dataProc is

signal code: std_logic_vector(1 downto 0);
signal op1, op2: std_logic_vector(19 downto 0);

begin
	process(wr)
	begin
		if rising_edge(wr) then
			if (isSt1 = '1') then
				code <= opValue(1 downto 0);
			elsif (isSt2 = '1') then
				op1 <= opValue;
			else
				op2 <= opValue;
			end if;
		end if;
	end process;
	
	process(code, op1, op2)
	begin
		case code is
		when "00" => 
			result <= std_logic_vector(unsigned("00000000000000000000" & op1) + unsigned("00000000000000000000" & op2));
		when "01" => 
			result <= std_logic_vector(unsigned("00000000000000000000" & op1) - unsigned("00000000000000000000" & op2));
		when "10" => 
			result <= op1 * op2;
		when others => 
			result <= "00000000000000000000" & std_logic_vector(unsigned(op1) / unsigned(op2));
		end case;
	end process;
	
end;