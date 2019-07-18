library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity my_mux is
	port(
		clk        : in  std_logic := '0';
		pb				: in	std_logic_vector(3 downto 0); --pb
		Tx_coordinate			: in	std_logic_vector(3 downto 0); 
		Ty_coordinate			: in 	std_logic_vector(3 downto 0); 
		x_coordinate			: in	std_logic_vector(3 downto 0);	
		y_coordinate			:	in std_logic_vector(3 downto 0);
			
		x_display			: out  std_logic_vector(3 downto 0); --hex_A
		y_display			: out  std_logic_vector(3 downto 0)--hex_B
		
		);
	end my_mux;

architecture A of my_mux is
begin
process(pb(2),pb(3))
begin
case pb(2) is


when '0'=>y_display <= y_coordinate ;
when '1'=>y_display <= Ty_coordinate ;
end case;
case pb(3) is
when '0'=>x_display <= x_coordinate ;
when '1'=>x_display <= Tx_coordinate ;
end case;
end process;
--with Error select
--SIM <= TRUE when '1',
--		 FALSE when'0';
		 
end A;