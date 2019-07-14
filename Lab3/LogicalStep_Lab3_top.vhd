library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab3_top is port (
   clkin_50		: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	
); 
end LogicalStep_Lab3_top;

architecture Energy_Monitor of LogicalStep_Lab3_top is
component Compx4 port(
a					: in	std_logic_vector(3 downto 0);
b					: in	std_logic_vector(3 downto 0);
gt				: out std_logic;
eq				: out std_logic;
lt				: out std_logic
);
end component;
--
component segment7_mux port (
		clk :in std_logic :='0';
		DIN2 : in std_logic_vector(6 downto 0);
		DIN1 : in std_logic_vector(6 downto 0);
		DOUT : out std_logic_vector(6 downto 0);
		DIG2 :out std_logic;
		DIG1 :out std_logic
	);
	end component;
	
component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
	
	
	
   end component;
component mode_control port (
sw: in std_logic_vector (3 downto 0);
WindowOpen: in std_logic;
DoorOpen: in std_logic;
CGTD: in std_logic;
CLED: in std_logic;
CEQD: in std_logic;
VacationMode: in std_logic;
AC_ON: out std_logic;
BLOWER_ON: out std_logic;
FURNACE_ON: out std_logic;
SYSTEM_AT_TEMP: out std_logic;
Desired_temp: out std_logic_vector (3 downto 0)
	);
	end component;
-- Components Used
------------------------------------------------------------------- 

------------------------------------------------------------------


signal Current_Temp: std_logic_vector (3 downto 0);
signal Desired_Temp: std_logic_vector (3 downto 0);
signal VacationMode: std_logic;
signal MC_TESTMODE: std_logic;
signal WindowOpen: std_logic;
signal DoorOpen: std_logic;
signal FURNACE_ON: std_logic;
signal SYSTEM_AT_TEMP: std_logic;
signal AC_ON : std_logic;
signal BLOWER_ON: std_logic;
signal TEST_PASS: std_logic;
signal VACATION_MODE: std_logic;

signal seg7_A	: std_logic_vector(6 downto 0);
signal seg7_B		: std_logic_vector(6 downto 0);
signal CEQD, CGTD, CLED : std_logic;


begin

Current_Temp <= sw (3 downto 0);
VacationMode <= not pb(3);
MC_TESTMODE <= not pb(2);
WindowOpen <= pb(1);
DoorOpen <= pb(0);
leds(0)<= FURNACE_ON ;
leds(1)<=SYSTEM_AT_TEMP;
leds(2)<= AC_ON ;
leds(3)<=BLOWER_ON;
leds(4)<= DoorOpen;
leds(5)<= WindowOpen;
leds(7)<= VacationMode;
INST1: SevenSegment port map(Current_Temp, seg7_A);
INST2: SevenSegment port map(Desired_temp, seg7_B);
INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B,seg7_data, seg7_char2, seg7_char1);
INST4: Compx4 port map (Current_Temp, Desired_Temp, CGTD, CEQD, CLED);
INST5: mode_control port map (sw(7 downto 4),WindowOpen, DoorOpen, CGTD, CLED, CEQD, VacationMode, AC_ON, BLOWER_ON, FURNACE_ON, SYSTEM_AT_TEMP, Desired_temp);
PROCESS (sw, CEQD, CGTD, CLED, pb(2)) is
variable EQ_PASS, GE_PASS, LE_PASS :std_logic := '0';
begin
	IF ((sw(3 downto 0) =sw (7 downto 4)) AND (CEQD='1')) THEN	
	EQ_PASS :='1';
	GE_PASS :='0';
	LE_PASS :='0';
	ELSIF ((sw(3 downto 0) >=sw (7 downto 4)) AND (CGTD='1')) THEN	
	EQ_PASS :='0';
	GE_PASS :='1';
	LE_PASS :='0';
	ELSIF ((sw(3 downto 0) <=sw (7 downto 4)) AND (CLED='1')) THEN	
	EQ_PASS :='0';
	GE_PASS :='0';
	LE_PASS :='1';
	ELSE
	EQ_PASS :='0';
	GE_PASS :='0';
	LE_PASS :='0';
	END IF;
	
	TEST_PASS<= MC_TESTMODE AND ( EQ_PASS OR GE_PASS or LE_PASS);
	leds(6) <= TEST_PASS;
end process;
end Energy_Monitor;

