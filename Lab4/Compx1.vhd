library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity Compx1 is port
(
a					: in	std_logic;
b					: in	std_logic;
gt				: out std_logic; --a greater than b
eq				: out std_logic; -- a equals b
lt				: out std_logic	-- a less than b
);
end Compx1;
	
architecture dataflow of Compx1 is
begin
	gt<=a and (not b);
	eq<=a xnor b;
	lt<=b and (not a);
end dataflow;

