library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
entity bto7seg is
	port (res: in std_logic_vector(19 downto 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5: out std_logic_vector(0 to 6));
end;
architecture synth of bto7seg is

signal tmp0, tmp1, tmp2, tmp3, tmp4, tmp5: std_logic_vector(3 downto 0);

begin
	
	process(res)
	begin
		tmp0 <= std_logic_vector(unsigned(res) mod "1010"); -- единицы
		case tmp0 is 
			when "0000" => HEX0 <= "0000001";
			when "0001" => HEX0 <= "1001111";
			when "0010" => HEX0 <= "0010010";
			when "0011" => HEX0 <= "0000110";
			when "0100" => HEX0 <= "1001100";
			when "0101" => HEX0 <= "0100100";
			when "0110" => HEX0 <= "0100000";
			when "0111" => HEX0 <= "0001111";
			when "1000" => HEX0 <= "0000000";
			when "1001" => HEX0 <= "0000100";
			when others => HEX0 <= (others => '1');
		end case;
		
		tmp1 <= std_logic_vector((unsigned(res) / "1010") mod "1010"); -- десятки
		case tmp1 is
			when "0000" => HEX1 <= "0000001";
			when "0001" => HEX1 <= "1001111";
			when "0010" => HEX1 <= "0010010";
			when "0011" => HEX1 <= "0000110";
			when "0100" => HEX1 <= "1001100";
			when "0101" => HEX1 <= "0100100";
			when "0110" => HEX1 <= "0100000";
			when "0111" => HEX1 <= "0001111";
			when "1000" => HEX1 <= "0000000";
			when "1001" => HEX1 <= "0000100";
			when others => HEX1 <= (others => '1');
		end case;
		
		tmp2 <= std_logic_vector((unsigned(res) / "1100100") mod "1010"); -- сотни
		case tmp2 is
			when "0000" => HEX2 <= "0000001";
			when "0001" => HEX2 <= "1001111";
			when "0010" => HEX2 <= "0010010";
			when "0011" => HEX2 <= "0000110";
			when "0100" => HEX2 <= "1001100";
			when "0101" => HEX2 <= "0100100";
			when "0110" => HEX2 <= "0100000";
			when "0111" => HEX2 <= "0001111";
			when "1000" => HEX2 <= "0000000";
			when "1001" => HEX2 <= "0000100";
			when others => HEX2 <= (others => '1');
		end case;
		
		tmp3 <= std_logic_vector((unsigned(res) / "1111101000") mod "1010"); -- тысячи
		case tmp3 is
			when "0000" => HEX3 <= "0000001";
			when "0001" => HEX3 <= "1001111";
			when "0010" => HEX3 <= "0010010";
			when "0011" => HEX3 <= "0000110";
			when "0100" => HEX3 <= "1001100";
			when "0101" => HEX3 <= "0100100";
			when "0110" => HEX3 <= "0100000";
			when "0111" => HEX3 <= "0001111";
			when "1000" => HEX3 <= "0000000";
			when "1001" => HEX3 <= "0000100";
			when others => HEX3 <= (others => '1');
		end case;
		
		tmp4 <= std_logic_vector((unsigned(res) / "10011100010000") mod "1010"); -- десятки тысяч
		case tmp4 is
			when "0000" => HEX4 <= "0000001";
			when "0001" => HEX4 <= "1001111";
			when "0010" => HEX4 <= "0010010";
			when "0011" => HEX4 <= "0000110";
			when "0100" => HEX4 <= "1001100";
			when "0101" => HEX4 <= "0100100";
			when "0110" => HEX4 <= "0100000";
			when "0111" => HEX4 <= "0001111";
			when "1000" => HEX4 <= "0000000";
			when "1001" => HEX4 <= "0000100";
			when others => HEX4 <= (others => '1');
		end case;
		
		tmp5 <= std_logic_vector((unsigned(res) / "11000011010100000") mod "1010"); -- сотни тысяч
		case tmp5 is
			when "0000" => HEX5 <= "0000001";
			when "0001" => HEX5 <= "1001111";
			when "0010" => HEX5 <= "0010010";
			when "0011" => HEX5 <= "0000110";
			when "0100" => HEX5 <= "1001100";
			when "0101" => HEX5 <= "0100100";
			when "0110" => HEX5 <= "0100000";
			when "0111" => HEX5 <= "0001111";
			when "1000" => HEX5 <= "0000000";
			when "1001" => HEX5 <= "0000100";
			when others => HEX5 <= (others => '1');
		end case;
		
	end process;
	
end;