library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UARTCONTROLLER is
port
(clk: in std_logic;
reset: in std_logic;
tbusy: in std_logic;
data1: in std_logic_vector(7 downto 0);
data2: in std_logic_vector(7 downto 0);
data3: in std_logic_vector(7 downto 0);
parallelout: out std_logic_vector(7 downto 0);
startuart: out std_logic
);
end;

architecture STRUCT of UARTCONTROLLER is

constant period: integer:=160000;-------for trigger------
signal timecounter: integer:=1;
constant pwmval: integer:=2;-----for 3 clock pwm----------
signal trig: std_logic;

signal cntx: integer:=0;

type vhdlarray is array (0 to 16) of  std_logic_vector(7 downto 0);
signal data_array: vhdlarray;

type StateType is (Idle, DataArrange, DataSent, WaitBusy);
signal State: StateType;


begin
-----------------Creating Trigs at each 10 ms (PWM)------------------
trigprocess: process(clk) is
begin
if reset='0' then
	trig<='0';
else
if rising_edge(clk) then
	
	if(timecounter<period) then
		timecounter<=timecounter+1;
	else
		timecounter<=1;
 	end if;

	if(timecounter<pwmval) then
		trig<='1';
	else 
		trig<='0';
	end if;
end if;
end if;
end process;

FSM:process(clk, State, tbusy, cntx) is
begin

if reset='0' then
	State<=Idle;
	parallelout<="00000000";
	data_array(16)<="00000000";
else
	if rising_edge(clk) then

		case State is

		when Idle=>	
			
			startuart<='0';			

			if (trig='1') then

				State<= DataArrange;------Next State-------
			end if;


		when DataArrange=>

			data_array(0)<="01000001"; ---start character 1 0x41
			data_array(1)<="01010011"; ---start character 2 0x53
			data_array(2)<="00010110"; ---packet length reg 0x16  
			data_array(3)<="00000001";----packet ID reg     0x01
			data_array(4)<=data1;
			data_array(5)<=data2;
			data_array(6)<=data3;
			data_array(7)<="00000000";-----TGCU Disc_In1;
			data_array(8)<="00000000";-----TGCU Disc_In2;
			data_array(9)<="00000000";-----TGCU Disc_In3;
			data_array(10)<="00000000";-----TGCU Temp1;
			data_array(11)<="00000000";-----TGCU Temp2;
			data_array(12)<="00110011";-----CPLD Version   0x33
			data_array(13)<="00000000";-----TGCU_Stat_Reg1
			data_array(14)<="00000000";------TGCU_Stat_Reg2
			
				
			data_array(16)<="00000000";----dummy-----
		
			State<=DataSent;-------Next State-----

		when DataSent=> 
			
			data_array(15)<="00000000"-(data_array(0)+data_array(1)+data_array(2)+
			data_array(3)+data_array(4)+data_array(5)+data_array(6)+data_array(7)+
			data_array(8)+data_array(9)+ data_array(10)+data_array(11)+data_array(12)+
			data_array(13)+data_array(14)); ----CheckSum----


			startuart<='1';					
			
			parallelout<=data_array(cntx);

			if(cntx<16) then
				State<=WaitBusy;

			else 
				cntx<=0;
				State<=Idle;
				
			end if;
		
		when WaitBusy=>
			
		
			if(tbusy='1') then
				State<=WaitBusy;
			else
				State<=DataSent;
				cntx<=cntx+1;
			end if;
		end case;
	end if;
end if;
end process;
end struct;
