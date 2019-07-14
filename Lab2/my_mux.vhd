library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity my_mux is
	port(
		input1				: in	std_logic_vector(3 downto 0); --pb
		input2			: in	std_logic_vector(7 downto 0); --logic
		input3			: in 	std_logic_vector(4 downto 0); --bit add
		input4			: in	std_logic_vector(3 downto 0);	--the value should be shown in the first(the one on the right) 7seg
		input5			:	in std_logic_vector(3 downto 0);--first 4 bit input
		input6			: in std_logic_vector(3 downto 0); --second 4 bit input
		output1			: out  std_logic_vector(3 downto 0); --hex_A
		output2			: out  std_logic_vector(3 downto 0); --hex_B
		output3			: out std_logic_vector(7 downto 0) --leds
		);
	end my_mux;

architecture A of my_mux is
begin
process(input1)
begin
case input1 is
when"0111" =>output3 <=  ("000"&input3);  --when PB4 is pressed, bit-add result should be shown
				 output1 <= input3(3 downto 0);
				 output2 <= input4(3 downto 0);
when"1110" =>output3 <=  input2;  --PB0 is pressed, logical AND is applied to the inputs, shown in leds
				 output1<= input5(3 downto 0);
				 output2<= input6(3 downto 0);
when"1101"=>output3<=  input2; --when PB1 is pressed, logical OR is applied 
				output1<= input5(3 downto 0);
				output2<= input6(3 downto 0);
when"1011"=>output3<=  input2;--when PB2 is pressed, logical XOR is applied
				output1<= input5(3 downto 0);
				output2<= input6(3 downto 0);
when"1111"=>output3<=  "00000000"; --PBs are not pressed, nothing is done, two 7segs show the result respectively, leds are off
				output1<= input5(3 downto 0);
				output2<= input6(3 downto 0);
when others => output3<=  "11111111"; --more than 2 PBs are pressed, show error messages!!!
					output1<="1000";
					output2<="1000";
end case;
end process;
end A;