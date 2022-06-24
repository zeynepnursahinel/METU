library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART is
port
(clk: in std_logic;
reset: in std_logic;
data1: in std_logic_vector(7 downto 0);
data2: in std_logic_vector(7 downto 0);
data3: in std_logic_vector(7 downto 0);
serialout: out std_logic
);
end UART;

architecture STRUCT of UART is

component UARTCONTROLLER 
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
end component;

component BITCONTROLLER
port
(clk: in std_logic;
reset: in std_logic;
startload: in std_logic;
parallelin: in std_logic_vector(7 downto 0);
serialout: out std_logic;
tbusy: out std_logic
);
end component;

signal paralleluart: std_logic_vector(7 downto 0);
signal startuart: std_logic;
signal tbusy2: std_logic;

begin

A1: UARTCONTROLLER port map(clk, reset, tbusy2, data1, data2, data3, paralleluart, startuart);
A2: BITCONTROLLER port map (clk, reset, startuart, paralleluart,serialout, tbusy2);

end STRUCT;
