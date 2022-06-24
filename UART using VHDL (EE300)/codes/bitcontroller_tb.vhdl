library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BITCONTROLLER_TB is
end;

architecture BENCH of BITCONTROLLER_TB is

component BITCONTROLLER
port
(clk: in std_logic;
reset: in std_logic;
startload: in std_logic;
parallelin: in std_logic_vector(0 to 7);
serialout: out std_logic;
tbusy: out std_logic
);
end component;

signal clk:  std_logic;
signal reset:  std_logic;
signal startload:  std_logic;
signal parallelin:  std_logic_vector(0 to 7);
signal serialout:  std_logic;
signal tbusy: std_logic;

begin

dut: BITCONTROLLER port map (clk, reset, startload, parallelin, serialout, tbusy);

clkprocess: process
begin
clk<='0';
wait for 30 NS;
clk<='1';
wait for 30 NS;
end process;

reset <= '0','1' after 20 NS;
startload<= '0', '1' after 20 us, '0' after 40 us, '1' after 450 us, '0' after 480 us;
parallelin<="00001111","11110001" after 400 us;

end BENCH;
