library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BITCONTROLLER is
port
(clk: in std_logic;
reset: in std_logic;
startload: in std_logic;
parallelin: in std_logic_vector(7 downto 0);
serialout: out std_logic;
tbusy: out std_logic
);
end BITCONTROLLER;


architecture STRUCT of BITCONTROLLER is

constant period: integer:= 278; ----to obtain 57600 Hz-----

signal timecounter: integer:=1;
signal cntx: integer:=0;

type vhdlarray is array (0 to 11) of  std_logic;
signal bitarray: vhdlarray;

type StateType is (Idle, DataSent, WaitPeriod);
signal State: StateType;

begin

FSM: process (clk, State, startload) is------startloadu eklemesem ne olur??___
begin

if reset='0' then------Reset is active low
	State<=Idle;
	serialout<='1';
	bitarray<="000000000000";
	tbusy<='0';
else
	if rising_edge(clk) then
	
		case State is
		
		when Idle=>
			tbusy<='0';

			cntx<=0;
	
			if(startload='1')then

				State<= DataSent;-----next state----

				bitarray(0)<='0'; -----start bit-----
				bitarray(10)<='1';-----stop bit----
				bitarray(1)<=parallelin(0);
				bitarray(2)<=parallelin(1);
				bitarray(3)<=parallelin(2);
				bitarray(4)<=parallelin(3);
				bitarray(5)<=parallelin(4);
				bitarray(6)<=parallelin(5);
				bitarray(7)<=parallelin(6);
				bitarray(8)<=parallelin(7);
				bitarray(9)<=parallelin(7) xor parallelin(6) xor 
parallelin(5) xor parallelin(4) xor parallelin(3) xor parallelin(2) xor parallelin(1) 
xor parallelin(0);---------even parity bit-------- 
				bitarray(11)<='0';---dummy---
			end if;

		when DataSent=>
			
			tbusy<='1';---------set tbusy--------

			if(cntx<11) then
				serialout<=bitarray(cntx);
				cntx<=cntx+1;
				State<=WaitPeriod;
			else 
				cntx<=0;
				State<=Idle;
			end if;
		
		when WaitPeriod=>

			if(timecounter<period) then
				State<=WaitPeriod;
				timecounter<=timecounter+1;
			else
				timecounter<=1;
				State<=DataSent;
			end if;
		end case;
	end if;
end if;
end process;
end STRUCT;
