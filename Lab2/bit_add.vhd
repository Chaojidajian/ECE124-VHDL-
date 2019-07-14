library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bit_add is
	port(
		input1			: in std_logic_vector(3 downto 0); --first 4-bit
		input2			: in std_logic_vector(3 downto 0); --second 4--bit
		output1			: out std_logic_vector(4 downto 0)
	);	--result
	end bit_add;
	
	
	architecture B of bit_add is
	begin
	output1<= ('0'&input1)+('0'&input2); --2 4-bit addition result in 5-bit
	end B;