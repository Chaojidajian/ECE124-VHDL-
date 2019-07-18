library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Compx4 is port
(
a					: in	std_logic_vector(3 downto 0);
b					: in	std_logic_vector(3 downto 0);
gt				: out std_logic;
eq				: out std_logic;
lt				: out std_logic
);
end Compx4;

architecture Structural of Compx4 is
component Compx1 port(
a					: in	std_logic;
b					: in	std_logic;
gt				: out std_logic; --a greater than b
eq				: out std_logic; -- a equals b
lt				: out std_logic	-- a less than b
);
end component;

signal greater: std_logic_vector (3 downto 0);
signal equal: std_logic_vector (3 downto 0);
signal less: std_logic_vector (3 downto 0);


begin
Comp0:Compx1 port map (a(0),b(0), greater(0),equal(0),less(0));
Comp1:Compx1 port map (a(1),b(1), greater(1),equal(1),less(1));
Comp2:Compx1 port map (a(2),b(2), greater(2),equal(2),less(2));
Comp3:Compx1 port map (a(3),b(3), greater(3),equal(3),less(3));
gt<= greater(3) or (equal(3) and greater(2)) or(equal(3) and equal(2) and greater(1))or(equal(3) and equal(2) and equal(1) and greater(0));
lt<=less(3) or (equal(3) and less(2)) or(equal(3) and equal(2) and less(1))or(equal(3) and equal(2) and equal(1) and less(0));
eq<=equal(0) and equal(1) and equal(2) and equal(3);

end Structural;

