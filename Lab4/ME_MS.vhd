library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity ME_MS IS Port
(
 clk_input						: IN std_logic;						
 rst_n							: IN std_logic;
 pb								: IN  std_logic_vector(1 downto 0); --pb 3 2 
 Extender_out					: IN std_logic;

 xgt				      		:  IN std_logic;
 xeq				      		:  IN std_logic;

 ygt				      		:  IN std_logic;
 yeq				      		:  IN std_logic;

 Extender_enable				: OUT std_logic:= '0';
 x_clk							: OUT std_logic:= '0';
 y_clk							: OUT std_logic:= '0';
 error							: OUT std_logic;
 x_change						: OUT std_logic;
 y_change						: OUT std_logic
 
 );
END ENTITY;
 

 Architecture SM of ME_MS is
 
  
 TYPE STATE_NAMES IS (S0, S1, S2,S3,S4);   -- list all the STATE_NAMES values but use more meaningful names

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


 BEGIN
 
 --------------------------------------------------------------------------------
 --State Machine:
 --------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS:
 
Register_Section: PROCESS (clk_input, rst_n)  -- this process synchronizes the activity to a clock
BEGIN
	IF (rst_n = '0') THEN
		current_state <= S0;
	ELSIF(rising_edge(clk_input)) THEN
		current_state <= next_State;
	END IF;
END PROCESS;	



-- TRANSITION LOGIC PROCESS

Transition_Section: PROCESS (Extender_out, xeq,yeq, current_state) 

BEGIN
     CASE current_state IS  --
          WHEN S0 =>	
				IF(xeq='0' or yeq='0') THEN
					next_state<=S1;
				ElSIF(Extender_out='1')then
					next_state<=S2;
				Else
					next_state<=S0;
				END IF;
				
	
         WHEN S1 =>		
				IF(xeq='1' and yeq='1') THEN   --can i write logical operation
					next_state <= S0;
				Else
					next_state <= S1;
				END IF;

         WHEN S2 =>	
					IF((Extender_out='0')and (xeq='0' and yeq='0')) THEN
						next_state<=S0;
					ELSIF((Extender_out='1')and (xeq='0' or yeq='0')) THEN
						next_state <= S3;
					ELSIF((Extender_out='0') and(xeq='0' or yeq='0')) THEN
						next_state <= S1;
					ELSE
						next_state<=S2;
					END IF;
			
			WHEN S3 =>
				IF((pb(1)='0') or (pb(0)='0')) THEN
					next_state <= S4;
				ELSIF((Extender_out='1')and (xeq='0' and yeq='0')) THEN
					next_state<=S2;
				ELSIF((Extender_out='0') and(xeq='0' or yeq='0')) THEN
					next_state<=S1;
				Else
					next_state<=S3;
				END IF;
			
			WHEN S4 =>
				IF(Extender_out='0') THEN
					next_state<=S1;
				ELSE
					next_state<=S4;
				END IF;	
			
				

				
 		END CASE;

 END PROCESS;


Decoder_Section: PROCESS (pb(1 downto 0),current_state, xgt, Extender_out, xeq,yeq, ygt ) 

BEGIN
     IF (current_state=S0) THEN
				
				IF(xeq='0' or yeq='0') THEN
					Extender_enable<='0';
					x_clk<=pb(1);
					y_clk	<=pb(0);
					x_change	<= xgt;
					y_change	<= ygt;
					Error<='0';
				ELSE
					Extender_enable<='1';
					x_clk<='1';
					y_clk	<='1';
					Error<='0';
					
				END IF;
     ELSIF (current_state=S1) THEN
				IF(xeq='1' and yeq='1') THEN   --can i write logical operation
					Extender_enable<='1';
					x_clk<='1';
					y_clk	<='1';
					
				ELSIF(yeq='1') THEN
					Extender_enable<='0';
					x_clk<=pb(1);
					y_clk	<='1';
					x_change	<= xgt;
				
				ELSIF(xeq='1') THEN
					Extender_enable<='0';
					x_clk<='1';
					y_clk	<=pb(0);
					y_change	<= ygt;
				ELSE
					Extender_enable<='0';
					x_clk<=pb(1);
					y_clk	<=pb(0);
					x_change	<= xgt;
					y_change	<= ygt;
				END IF;
	  ELSIF (current_state=S2) THEN	
		
				IF((Extender_out='0') and(xeq='0' or yeq='0')) THEN
						Extender_enable<='0';
						x_clk<=pb(1);
						y_clk	<=pb(0);
						x_change	<= xgt;
						y_change	<= ygt;
				ELSE
						Extender_enable<='1';
						x_clk<='1';
						y_clk	<='1';
				END IF;
			
			
		ELSIF (current_state=S3) THEN
				IF((pb(1)='0') or (pb(0)='0')) THEN
					error<='1';
				
				ELSIF((Extender_out='0') and(xeq='0' or yeq='0')) THEN
						Extender_enable<='0';
						x_clk<=pb(1);
						y_clk	<=pb(0);
						x_change	<= xgt;
						y_change	<= ygt;
				ELSE
						Extender_enable<='1';
						x_clk<='1';
						y_clk	<='1';
				END IF;
		
			
		ELSIF (current_state=S4) THEN	
				IF(Extender_out='0')THEN
					error<='0';
				
			
				ELSE	
						error<='1';
						Extender_enable<='1';
						x_clk<='1';
						y_clk	<='1';
				END IF;
	  END IF;
 END PROCESS;

 END ARCHITECTURE SM;
