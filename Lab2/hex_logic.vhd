library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity hex_logic is
	port(
			input1			: in std_logic_vector(3 downto 0); --first 4-bit input
			input2			: in std_logic_vector(3 downto 0); --second 4--bit input
			input3			: in	std_logic_vector(3 downto 0); --pb
			output1			: out std_logic_vector(7 downto 0)--logic output
		);
	end hex_logic;
	
	architecture C of hex_logic is
	begin
	with input3 select
	output1 <= "0000"&(input1 and input2) when "1110", --if pb0 is pressed, do logical AND
				  "0000"&(input1 or input2) when "1101", --if pb1 is pressed, do logical or
				  "0000"&(input1 xor input2) when "1011", --if pb2 is pressed, do logical xor
				  "11111111" when others; --just to give a default value
	
	end C;
