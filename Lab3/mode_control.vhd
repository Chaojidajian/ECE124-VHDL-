library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity mode_control is port
(
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
end mode_control;

architecture dataflow of mode_control is
signal a,b:std_logic;

begin 


a <= CGTD and (not WindowOpen) and (not DoorOpen);
BLOWER_ON <= (a or b);
b <= CLED and (not WindowOpen) and (not DoorOpen);
AC_ON <=a;
FURNACE_ON<=b;
SYSTEM_AT_TEMP<= CEQD;

PROCESS(VacationMode) is
begin
case VacationMode is
when'1' =>Desired_temp <= "0100" ;  --when vacationmode is on, set temperature to "0100
when'0' =>Desired_Temp <= sw (3 downto 0);  --when vacation mode is off, use sw to set desired temperature.	
		
end case;
end process;

end dataflow;