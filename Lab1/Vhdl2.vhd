LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY work;
ENTITY Vhdl2 IS
	PORT(
	POLARITY_CNTRL, IN_1, IN_2, IN_3, IN_4:IN STD_LOGIC;
	out_1, OUT_2, OUT_3, OUT_4:OUT STD_LOGIC
	);
	END Vhdl2;
	
ARCHITECTURE DATAFLOW OF Vhdl2 IS
BEGIN

OUT_1<=POLARITY_CNTRL XOR IN_1;
OUT_2<=POLARITY_CNTRL XOR IN_2;
OUT_3<=POLARITY_CNTRL XOR IN_3;
OUT_4<=POLARITY_CNTRL XOR IN_4;

END DATAFLOW;