
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   clkin_50		: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
component Bidir_shift_reg port
(
		CLK:          in std_logic :='0';
		RESET_n:      in std_logic := '0';
		CLK_EN:       in std_logic := '0';
		LEFT0_RIGHT1: in std_logic :='0';
		REG_BITS :    out std_logic_vector(3 downto 0)
);
end component;
component U_D_Bin_Counter4bit is port
(
		CLK:          in std_logic :='0';
		RESET_n:      in std_logic := '0';
		CLK_EN:       in std_logic := '1';
		UP1_DOWN0:    in std_logic ;
		COUNTER_BITS: out std_logic_vector(3 downto 0)
);
end component;
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
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   Error		:  in std_logic;
	clk        : in  std_logic := '0';
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
	
);	
	
   end component;
component my_mux port(
		pb				: in	std_logic_vector(3 downto 0); --pb
		Tx_coordinate			: in	std_logic_vector(3 downto 0); 
		Ty_coordinate			: in 	std_logic_vector(3 downto 0); 
		x_coordinate			: in	std_logic_vector(3 downto 0);	
		y_coordinate			:	in std_logic_vector(3 downto 0);
		
		x_display			: out  std_logic_vector(3 downto 0); --hex_A
		y_display			: out  std_logic_vector(3 downto 0) --hex_B
	
		);
end component;

component ME_MS Port(
 clk_input						: IN std_logic;						
 rst_n							: IN std_logic;
 pb								: IN  std_logic_vector(1 downto 0); --pb 3 2
 Extender_out					: IN std_logic;
 xgt				      :  IN std_logic;
 xeq				      :  IN std_logic;
 ygt				      :  IN std_logic;
 yeq				      :  IN std_logic;

 Extender_enable				: OUT std_logic:= '0';
 x_clk							: OUT std_logic:= '0';
 y_clk							: OUT std_logic:= '0';
 error							: OUT std_logic;
 x_change						: OUT std_logic;
 y_change						: OUT std_logic

 );
END component;
component MOORE_SM2 PORT (
          CLK		     		: in  std_logic := '0';
          RESET_n      		: in  std_logic := '0';
			 GRAP_BUTTON		: in  std_logic := '0';
			 GRAP_ENBL			: in  std_logic := '0';
          GRAP_ON			   : out std_logic
			 );
END component;
component MOORE_SM1 PORT (
			 CLK		     		: in  std_logic := '0';
          RESET_n      		: in  std_logic := '0';
			 extender_BUTTON		: in  std_logic := '1';
			 extender_ENBL			: in  std_logic := '0';
			 extender_position: in std_logic_vector(3 downto 0);
          extender_out			   : out std_logic;
			 clk_en				: out std_logic;
			 direction			: out std_logic;
			 grap_en				: out std_logic
			 );
END component;
----------------------------------------------------------------------------------------------------
	CONSTANT	SIM							:  boolean := FALSE; 	-- set to TRUE for simulation runs otherwise keep at 0.
   CONSTANT CLK_DIV_SIZE				: 	INTEGER := 26;    -- size of vectors for the counters

   SIGNAL 	Main_CLK						:  STD_LOGIC; 			-- main clock to drive sequencing of State Machine

	SIGNAL 	bin_counter					:  UNSIGNED(CLK_DIV_SIZE-1 downto 0); -- := to_unsigned(0,CLK_DIV_SIZE); -- reset binary counter to zero
	SIGNAL	Tx_coordinate				:	std_logic_vector(3 downto 0);
	SIGNAL	Ty_coordinate				:	std_logic_vector(3 downto 0);
	SIGNAL   Seg1							: 	std_logic_vector(6 downto 0);
	SIGNAL 	Seg2							:  std_logic_vector(6 downto 0);
	SIGNAL   CLK_EN       				: std_logic := '0';
	SIGNAL	x_coordinate				:	std_logic_vector(3 downto 0);
	SIGNAL	y_coordinate				:	std_logic_vector(3 downto 0);
	SIGNAL	x_display				:	std_logic_vector(3 downto 0);
	SIGNAL	y_display				:	std_logic_vector(3 downto 0);
	SIGNAL   xlt				      :  std_logic;
	SIGNAL   xgt				      :  std_logic;
	SIGNAL   xeq				      :  std_logic;
	SIGNAL   ylt				      :  std_logic;
	SIGNAL   ygt				      :  std_logic;
	SIGNAL   yeq				      :  std_logic;
	SIGNAL   xchange					:  std_logic;
	SIGNAL   ychange					:	std_logic;
	SIGNAL   CLK_x       			: std_logic := '0';
	SIGNAL   CLK_y      				: std_logic := '0';
	SIGNAL 	Extender_out, Extender_enable, Grap_out, Grap_enable: std_logic;
	Signal   clk_extender			: std_logic;
	signal   extender_move			: std_logic;
	SIGNAL	Error						: std_logic := '0';
	signal   extender_position		:std_logic_vector(3 downto 0);
	
----------------------------------------------------------------------------------------------------
BEGIN

-- CLOCKING GENERATOR WHICH DIVIDES THE INPUT CLOCK DOWN TO A LOWER FREQUENCY

BinCLK: PROCESS(clkin_50, rst_n) is
   BEGIN
		IF (rising_edge(clkin_50)) THEN -- binary counter increments on rising clock edge
         bin_counter <= bin_counter + 1;
      END IF;
   END PROCESS;

Clock_Source:
				Main_Clk <= 
				clkin_50 when sim = TRUE  else				-- for simulations only sim = TRUE 
				std_logic(bin_counter(23));								-- for real FPGA operation
					
---------------------------------------------------------------------------------------------------
Tx_coordinate<=sw(7 downto 4);
Ty_coordinate<=sw(3 downto 0);
leds(0)<=Error;
leds(3)<=Grap_out;
leds(7 downto 4)<=extender_position(3 downto 0);
INST1:Compx4 port map(Tx_coordinate,x_coordinate,xgt,xeq,xlt);  --compare x
INST2:Compx4 port map(Ty_coordinate,y_coordinate,ygt,yeq,ylt);  -- compare y
INST3:SevenSegment port map(x_display, Error, Main_clk, Seg1);
INST4:SevenSegment port map(y_display, Error, Main_clk, Seg2);
INST5:segment7_mux port map(clkin_50, seg1, seg2,seg7_data,seg7_char1 , seg7_char2);
INST6:Bidir_shift_reg port map(Main_clk,rst_n,clk_extender, extender_move, extender_position(3 downto 0)); --extender
INST7:U_D_Bin_Counter4bit port map(Main_Clk, rst_n, CLK_x, xchange ,x_coordinate); --x
INST8:U_D_Bin_Counter4bit port map(Main_Clk, rst_n, CLK_y, ychange, y_coordinate); --y
INST9:ME_MS port map(Main_Clk, rst_n, pb(3 downto 2),  Extender_out, xgt, xeq, ygt, yeq, Extender_enable, CLK_x, CLK_y, Error, xchange, ychange); --Controller
INST10: MOORE_SM2 port map (Main_clk,rst_n, pb(0), Grap_enable, Grap_out);--GRAPPLER
INST11: MOORE_SM1 port map (Main_clk, rst_n, pb(1), Extender_enable, extender_position(3 downto 0),Extender_out, clk_extender, extender_move, Grap_enable );--EXTENDER
INST12:my_mux port map(pb(3 downto 0), Tx_coordinate(3 downto 0), Ty_coordinate(3 downto 0), x_coordinate(3 downto 0), y_coordinate(3 downto 0), x_display(3 downto 0), y_display(3 downto 0));
END SimpleCircuit;
