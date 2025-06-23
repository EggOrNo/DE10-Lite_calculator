library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;
entity control is
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
		
		LED, dot: out std_logic_vector(5 downto 0);
		LED9: out std_logic;
		outCodeValue: out std_logic_vector(1 downto 0);
		outResValue: out std_logic_vector(19 downto 0));
end;
architecture synth of control is

signal delay: std_logic_vector(25 downto 0); -- Задержка, если результат больше 999 999
signal CLK_delay: std_logic; -- CLK с меньшей частотой, есмь задержка

signal isdot: std_logic_vector(5 downto 0);
signal state: std_logic_vector(3 downto 0);
signal div0, div1, div2, div3, div4, div5, div6: std_logic_vector(39 downto 0);
signal bigres: std_logic_vector(19 downto 0);

signal reset_v: std_logic;
signal pointer_v:std_logic_vector(2 downto 0);
signal nextSt: std_logic_vector(1 downto 0); -- Состояние автомата изменения этапа
signal nextVal: std_logic; -- Состояние автомата изменения счётчика этапов

begin
	reset <= reset_v;
	pointer <= pointer_v;
	
	process(CLK) -- Для задержки *****************
	begin
		if (isbig = '1' and rising_edge(CLK)) then
			if ( (delay(25) and delay(22) and delay(21) and delay(17) and delay(14) -- Эти две строки для платы
					and delay(12) and delay(11) and delay(9)) = '1') then
--			if (delay(2) = '1') then 																-- Эта строка для теста
				delay <= "00000000000000000000000001";
				CLK_delay <= '1';
			else
				delay <= delay + '1';
				CLK_delay <= '0';
			end if;
		end if;
	end process;
	
	
	process(SW) -- Движковые переключатели
	begin
		if (SW(5) = '1') then
			pointer_v <= "101";
		elsif (SW(4) = '1') then
			pointer_v <= "100";
		elsif (SW(3) = '1') then
			pointer_v <= "011";
		elsif (SW(2) = '1') then
			pointer_v <= "010";
		elsif (SW(1) = '1') then
			pointer_v <= "001";
		else
			pointer_v <= "000";
		end if;
	end process;
	
	
	process(pointer_v, stValue) -- Светодиоды по изменению операнда
	begin
		LED <= (others => '0');
		if ( (stValue(1) xor stValue(0)) = '1') then
			LED(to_integer(unsigned(pointer_v))) <= '1';
		end if;
	end process;
	
	
	process(CLK) -- Сейчас первый или второй этап? 
	begin
		if falling_edge(CLK) then
			if ( (stValue(0) or stValue(1)) = '0') then
				isSt1 <= '1';
			else
				isSt1 <= '0';
			end if;
			if ( (stValue(0) and not(stValue(1))) = '1') then
				isSt2 <= '1';
			else
				isSt2 <= '0';
			end if;
		end if;
	end process;
	
	
	process(CLK) -- Переход на следующий этап
	begin
		if rising_edge(CLK) then
			if ((nextSt(1) or nextSt(0)) = '0') then
				if (key0 = '0') then
					wr <= '1';
					nextSt <= "11";
				end if;
					
			elsif ((nextSt(1) and nextSt(0)) = '1') then
				wr <= '0';
				reset_v <= '1';
				if (key0 = '1') then
					nextSt <= "10";
				end if;
				
			else
				wr <= '0';
				reset_v <= '0';
				nextSt <= "00";
				
			end if;
		end if;
	end process;
	
	
	process(CLK) -- Изменение значения счётчика
	begin
		if rising_edge(CLK) then
			sKey1 <= key1;
		end if;
	end process;
	
		
	process(stValue, opValue, resValue, bigres, reset_v)
	begin
		if (reset_v = '1') then
			LED9 <= '0';
			dot <= (others => '1');
			outCodeValue <= (others => '0');
			outResValue <= (others => '0');
		else
			LED9 <= '0';
			dot <= (others => '1');	
			case stValue is
			when "00" =>
				outCodeValue <= opValue(1 downto 0);
				outResValue <= (others => '0');
				
			when "11" =>
			
				outCodeValue <= (others => '0');
				
				if (isneg = '1') then
					outResValue <= resValue(19 downto 0);
					LED9 <= '1';
					dot <= "111110";
					
				elsif (isbig = '0') then
					outResValue <= resValue(19 downto 0);
					dot <= "111110";
					
				else 
					dot <= isdot;
					outResValue <= bigres;
				end if;
				
			when others =>
				outCodeValue <= (others => '0');
				outResValue <= opValue;			
			end case;
		end if;
	end process;
	
	
	process(CLK_delay, reset_v)
	begin
		if (reset_v = '1') then
			state <= (others => '0');
			isdot <= (others => '1');
			
			div0 <= resValue;
			div1 <= std_logic_vector(unsigned(resValue) / "1010");
			div2 <= std_logic_vector(unsigned(resValue) / "1100100");
			div3 <= std_logic_vector(unsigned(resValue) / "1111101000");
			div4 <= std_logic_vector(unsigned(resValue) / "10011100010000");
			div5 <= std_logic_vector(unsigned(resValue) / "11000011010100000");
			div6 <= std_logic_vector(unsigned(resValue) / "11110100001001000000");
			
			if (isbig = '1') then
				if (div6 >= "11000011010100000") then --  >= 100 000
					isdot <= "111110";
					bigres <= std_logic_vector(unsigned(div6) mod "11110100001001000000");
					state <= "0001";
					
				elsif (div5 >= "11000011010100000") then
					isdot <= "111101";
					bigres <= std_logic_vector(unsigned(div5) mod "11110100001001000000");
					state <= "0010";
					
				elsif (div4 >= "11000011010100000") then
					isdot <= "111011";
					bigres <= std_logic_vector(unsigned(div4) mod "11110100001001000000");
					state <= "0011";
					
				elsif (div3 >= "11000011010100000") then
					isdot <= "110111";
					bigres <= std_logic_vector(unsigned(div3) mod "11110100001001000000");
					state <= "0100";
					
				elsif (div2 >= "11000011010100000") then
					isdot <= "101111";
					bigres <= std_logic_vector(unsigned(div2) mod "11110100001001000000");
					state <= "0101";
					
				elsif (div1 >= "11000011010100000") then
					isdot <= "011111";
					bigres <= std_logic_vector(unsigned(div1) mod "11110100001001000000");
					state <= "0110";
					
				else
					isdot <= "111110";
					bigres <= std_logic_vector(unsigned(div0) mod "11110100001001000000");
					state <= "0111";
				end if;
			end if;
			
		elsif (rising_edge(CLK_delay) and isbig = '1') then	
				
			case state is
			when "0000" =>
				isdot <= (others => '1');
				
				if (div6 >= "11000011010100000") then --  >= 100 000
					isdot <= "111110";
					bigres <= std_logic_vector(unsigned(div6) mod "11110100001001000000");
					state <= "0001";
					
				elsif (div5 >= "11000011010100000") then
					isdot <= "111101";
					bigres <= std_logic_vector(unsigned(div5) mod "11110100001001000000");
					state <= "0010";
					
				elsif (div4 >= "11000011010100000") then
					isdot <= "111011";
					bigres <= std_logic_vector(unsigned(div4) mod "11110100001001000000");
					state <= "0011";
					
				elsif (div3 >= "11000011010100000") then
					isdot <= "110111";
					bigres <= std_logic_vector(unsigned(div3) mod "11110100001001000000");
					state <= "0100";
					
				elsif (div2 >= "11000011010100000") then
					isdot <= "101111";
					bigres <= std_logic_vector(unsigned(div2) mod "11110100001001000000");
					state <= "0101";
					
				elsif (div1 >= "11000011010100000") then
					isdot <= "011111";
					bigres <= std_logic_vector(unsigned(div1) mod "11110100001001000000");
					state <= "0110";
					
				else
					isdot <= "111110";
					bigres <= std_logic_vector(unsigned(div0) mod "11110100001001000000");
					state <= "0111";
				end if;
				
				
			when "0001" =>
				isdot <= "111110";
				bigres <= std_logic_vector(unsigned(div6) mod "11110100001001000000"); -- res / 1 000 000
				state <= "0010";
				
			when "0010" =>
				isdot <= "111101";
				bigres <= std_logic_vector(unsigned(div5) mod "11110100001001000000"); -- res / 100 000 mod 1 000 000
				state <= "0011";
				
			when "0011" =>
				isdot <= "111011";
				bigres <= std_logic_vector(unsigned(div4) mod "11110100001001000000");-- res / 10 000 mod 1 000 000
				state <= "0100";
				
			when "0100" =>
				isdot <= "110111";
				bigres <= std_logic_vector(unsigned(div3) mod "11110100001001000000"); -- res / 1 000 mod 1 000 000
				state <= "0101";
				
			when "0101" =>
				isdot <= "101111";
				bigres <= std_logic_vector(unsigned(div2) mod "11110100001001000000"); -- res / 100 mod 1 000 000
				state <= "0110";
				
			when "0110" =>
				isdot <= "011111";
				bigres <= std_logic_vector(unsigned(div1) mod "11110100001001000000"); -- res / 10 mod 1 000 000
				state <= "0111";
				
			when "0111" =>
				isdot <= "111110";
				bigres <= std_logic_vector(unsigned(div0) mod "11110100001001000000"); -- res mod 1 000 000
				state <= "1000";
				
			when "1000" =>
				state <= "1001"; -- Для задержки
				
			when "1001" =>
				state <= "1010"; -- Для задержки
				
			when others =>  -- Для задержки
				state <= "0000";
			end case;					
		end if;	
	end process;
	
end;