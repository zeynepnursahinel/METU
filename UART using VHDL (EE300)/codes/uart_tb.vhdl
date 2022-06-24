library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART_TB is
end;

architecture BENCH of UART_TB is

component UART
port
(clk: in std_logic;
reset: in std_logic;
data1: in std_logic_vector(7 downto 0);
data2: in std_logic_vector(7 downto 0);
data3: in std_logic_vector(7 downto 0);
serialout: out std_logic
);
end component;

signal clk, reset: std_logic;
signal data1, data2, data3: std_logic_vector(7 downto 0);
signal serialout: std_logic;

begin

dut: UART port map (clk, reset, data1, data2,data3, serialout);

clkprocess: process
begin
clk<='0';
wait for 30 NS;
clk<='1';
wait for 30 NS;
end process;

reset <= '0','1' after 20 NS;
data1<="00001111";
data2<="00001100";
data3<="00000011";

end BENCH;
