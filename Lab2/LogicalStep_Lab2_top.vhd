library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb					: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
	
	
	
   end component;
	
	component segment7_mux port (
		clk :in std_logic :='0';
		DIN2 : in std_logic_vector(6 downto 0);
		DIN1 : in std_logic_vector(6 downto 0);
		DOUT : out std_logic_vector(6 downto 0);
		DIG2 :out std_logic;
		DIG1 :out std_logic
	);
	end component;
	
	component my_mux port (
		input1				: in	std_logic_vector(3 downto 0); --pb
		input2			: in	std_logic_vector(7 downto 0); --logic result
		input3			: in 	std_logic_vector(4 downto 0); --bit add
		input4			: in	std_logic_vector(3 downto 0);	--first 7seg after bit add
		input5			:	in std_logic_vector(3 downto 0);--first 4 bit input 
		input6			: in std_logic_vector(3 downto 0); --second 4 bit input
		output1			: out  std_logic_vector(3 downto 0); --hex_A
		output2			: out  std_logic_vector(3 downto 0); --hex_B
		output3			: out std_logic_vector(7 downto 0) --leds
		);
	end component;
	
	component bit_add port (
		input1			: in std_logic_vector(3 downto 0); --first 4-bit input
		input2			: in std_logic_vector(3 downto 0); --second 4--bit input
		output1			: out std_logic_vector(4 downto 0) --result in a 5-bit number
		);
	end component;
	
	component hex_logic port (
			input1			: in std_logic_vector(3 downto 0); --first 4-bit input 
			input2			: in std_logic_vector(3 downto 0); --second 4--bit input
			input3			: in	std_logic_vector(3 downto 0); --pb
			output1			: out std_logic_vector(7 downto 0)--concate "0000" with logic output
		);
	end component;
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A		: std_logic_vector(6 downto 0);
	signal hex_A		: std_logic_vector(3 downto 0);
	signal hex_B		: std_logic_vector(3 downto 0);
	signal seg7_B		: std_logic_vector(6 downto 0);
	signal temp1			: std_logic_vector(3 downto 0); --first 4-bit input
	signal temp2			: std_logic_vector(3 downto 0); --second 4--bit input

	signal logic_result : std_logic_vector(7 downto 0); 
	signal add_result1: std_logic_vector(4 downto 0); -- 4 bits + 4 bit is a 5-bit number 
	signal add_result2: std_logic_vector(3 downto 0); --the value shouble be shown in the fitst 7seg(the right one) after addition
-- Here the circuit begins

begin
temp1<= sw(3 downto 0);  --store the inputs
temp2<= sw(7 downto 4);  
add_result2<= "0001" when add_result1(4) = '1'else  --determine the output on the first 7seg after addition
			     "0000" when add_result1(4) = '0';
INST1: SevenSegment port map(hex_A, seg7_A);
INST2: SevenSegment port map(hex_B, seg7_B);
INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B,seg7_data, seg7_char2, seg7_char1);
INST4: hex_logic port map(temp1, temp2, pb, logic_result );
INST5: bit_add port map(temp1, temp2, add_result1);
INST6: my_mux port map(pb, logic_result, add_result1, add_result2, temp1, temp2, hex_A, hex_B, leds); --use pins (3 downto 0) input to select the output of leds and the inputs to 7segment 

 
end SimpleCircuit;

