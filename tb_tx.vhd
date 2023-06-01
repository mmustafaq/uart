library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_uart_tx is
generic (
clk_freq		: integer := 100_000_000;
baudrate		: integer := 10_000_000;
stopbit		: integer := 2
);
end tb_uart_tx;

architecture Behavioral of tb_uart_tx is

component uart_tx is
generic (
clk_freq		: integer := 100_000_000;
baudrate		: integer := 115_200;
stopbit		: integer := 2
);
port (
clk				: in std_logic;
data_in			: in std_logic_vector (7 downto 0);
strt		: in std_logic;
op			: out std_logic;
done	: out std_logic
);
end component;

signal clk				: std_logic := '0';
signal data_in			: std_logic_vector (7 downto 0) := (others => '0');
signal strt		: std_logic := '0';
signal op				: std_logic;
signal done	: std_logic;

constant c_clkperiod	: time := 10 ns;

begin

DUT : uart_tx
generic map(
clk_freq		=> clk_freq	  ,
baudrate		=> baudrate	  ,
stopbit		=> stopbit	
)
port map(
clk				=> clk				   ,
data_in			=> data_in			   ,
strt		=> strt		   ,
op			=> op			       ,
done	=> done	
);

P_CLKGEN : process begin

clk	<= '0';
wait for c_clkperiod/2;
clk	<= '1';
wait for c_clkperiod/2;

end process P_CLKGEN;

P_STIMULI : process begin

data_in			<= x"00";
strt		<= '0';

wait for c_clkperiod*10;

data_in		<= x"51";
strt	<= '1';
wait for c_clkperiod;
strt	<= '0';

wait for 1.2 us;

data_in		<= x"A3";
strt	<= '1';
wait for c_clkperiod;
strt	<= '0';

wait until (rising_edge(done));

wait for 1 us;

assert false
report "SIM DONE"
severity failure;


end process P_STIMULI;


end Behavioral;