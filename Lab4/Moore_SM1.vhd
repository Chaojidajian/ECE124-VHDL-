library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY MOORE_SM1 IS PORT (
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
			 
END ENTITY;

ARCHITECTURE SM OF MOORE_SM1 IS

-- list all the STATES  
   TYPE STATES IS (INIT, in_process1, go_process1,go_process2,go_process3,extended,back_process1,back_process2,back_process3);   

   SIGNAL current_state, next_state			:  STATES;       -- current_state, next_state signals are of type STATES

BEGIN


-- STATE MACHINE: MOORE Type

REGISTER_SECTION: PROCESS(CLK, RESET_n) -- creates sequential logic to store the state. The rst_n is used to asynchronously clear the register
   BEGIN
		IF (RESET_n = '0') THEN
	         current_state <= INIT;
		ELSIF (rising_edge(CLK)) then
				current_state <= next_state; -- on the rising edge of clock the current state is updated with next state
		END IF;
   END PROCESS;
	

 TRANSITION_LOGIC: PROCESS(extender_BUTTON,extender_ENBL,extender_position(3 downto 0)) -- logic to determine next state. 
   BEGIN
     CASE current_state IS
          WHEN INIT =>		
            IF ((extender_BUTTON='0') AND (extender_ENBL='1')) THEN 
               next_state <= go_process1;
				ELSE
               next_state <= INIT;
            END IF;
        WHEN go_process1 =>		
            IF (extender_position="1100") THEN 
               next_state <=go_process2 ;
				ELSE
               next_state <= go_process1;
            END IF;

         WHEN go_process2 =>		
            IF (extender_position="1110") THEN 
               next_state <= go_process3;
				ELSE
               next_state <= go_process2;
            END IF;
				
			 WHEN go_process3 =>		
            IF (extender_position="1111") THEN 
               next_state <=extended ;
				ELSE
               next_state <= go_process3;
            END IF;
			WHEN extended =>		
            IF ((extender_BUTTON='0') AND (extender_ENBL='1')) THEN 
               next_state <=back_process1 ;
				ELSE
               next_state <= extended;
            END IF;
			WHEN back_process1 =>		
            IF (extender_position="1100") THEN 
               next_state <=back_process2 ;
				ELSE
               next_state <= back_process1;
            END IF;
			WHEN back_process2 =>		
            IF (extender_position="1000") THEN 
               next_state <=back_process3 ;
				ELSE
               next_state <= back_process2;
            END IF;
			WHEN back_process3 =>		
            IF (extender_position="0000") THEN 
               next_state <=INIT ;
				ELSE
               next_state <= back_process3;
            END IF;

			WHEN OTHERS =>
               next_state <= INIT;
					
 		END CASE;
 END PROCESS;

 MOORE_DECODER: PROCESS(current_state) 			-- logic to determine outputs from state machine states
   BEGIN
     CASE current_state IS
	  
        WHEN INIT =>		
			 extender_out<='0';
			 clk_en<='0';
			 grap_en<='0';

		  WHEN go_process1 =>
			 direction<='1';  
			 extender_out<='1';
			 clk_en<='1';
			 
		  WHEN go_process2 =>
		    direction<='1'; 
			 extender_out<='1';  
			 clk_en<='1';
		  
		  WHEN go_process3 =>
		    direction<='1';   
			 extender_out<='1';
			 clk_en<='1';
			
			 			 
        WHEN extended =>
			 grap_en<='1';
			 extender_out<='1';
			 clk_en<='0';
				  
		  WHEN back_process1 =>
			 direction<='0';  
			 extender_out<='1';
			 clk_en<='1';
			 
		  WHEN back_process2 =>
			 direction<='0';  
			 extender_out<='1';
			 clk_en<='1';
			 
		  WHEN back_process3 =>
			 direction<='0';  
			 extender_out<='1';
			 clk_en<='1';
		  WHEN OTHERS =>
		   extender_out<='0';
			 clk_en<='0';
			 grap_en<='0';

		END CASE;

 END PROCESS;

END SM;
