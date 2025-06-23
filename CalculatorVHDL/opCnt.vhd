library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity opCnt is
	port (key, iscode, reset: in std_logic;
		pointer: in std_logic_vector(2 downto 0);
		outCnt: out std_logic_vector(19 downto 0));
end;
architecture synth of opCnt is

signal cnt: std_logic_vector(19 downto 0);
begin
	outCnt <= cnt;
		
	process(key, reset)
	begin
		if (reset = '1') then -- Переход на следующий этап, нужен сброс
			cnt <= (others => '0');
		
		elsif falling_edge(key) then 
			
			if (iscode = '1') then -- Вводится номер операции
				
				if cnt(1 downto 0) = "11" then
					cnt(1 downto 0) <= "00";
				else
					cnt <= cnt + '1';
				end if;
				
			else -- Вводится операнд
			
				case pointer is
				when "001" => 
					if (cnt >= "11110100001000110101") then --  >= 999 990
						cnt <= cnt - "11110100001000110110"; -- -999 990
					else
						cnt <= cnt + "1010"; -- +10
					end if;
				
				when "010" => 
					if (cnt >= "11110100000111011100") then --  >= 999 900
						cnt <= cnt - "11110100000111011100"; -- -999 900
					else
						cnt <= cnt + "1100100"; -- +100
					end if;
				
				when "011" => 
					if (cnt >= "11110011111001011000") then --  >= 999 000
						cnt <= cnt - "11110011111001011000"; -- -999 000
					else
						cnt <= cnt + "1111101000"; -- +1000
					end if;
				
				when "100" => 
					if (cnt >= "11110001101100110000") then --  >= 990 000
						cnt <= cnt - "11110001101100110000"; -- -990 000
					else
						cnt <= cnt + "10011100010000"; -- +10 000
					end if;
				
				when "101" => 
					if (cnt >= "11011011101110100000") then --  >= 900 000
						cnt <= cnt - "11011011101110100000"; -- -900 000
					else
						cnt <= cnt + "11000011010100000"; -- +100 000
					end if;
				
				when others =>
					if ((cnt(19) and cnt(18) and cnt(17) and cnt(16) and cnt(14) and cnt(9) and cnt(5)
						and cnt(4) and cnt(3) and cnt(2) and cnt(1) and cnt(0)) = '1') then --  = 999 999
						cnt <= (others => '0'); -- -999 999
					else
						cnt <= cnt + '1'; -- +1
					end if;
				end case;
				
			end if;
		end if;
	end process;
end;