library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uart_tx is
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
end uart_tx;

architecture Behavioral of uart_tx is

constant bit_timer_limit 	: integer := clk_freq/baudrate;
constant stop_bit_lim 	: integer := (clk_freq/baudrate)*stopbit;

type states is (idle, start, data, stop);
signal state : states := idle;

signal bittimer : integer range 0 to stop_bit_lim := 0;
signal bitcntr	: integer range 0 to 7 := 0;
signal shreg	: std_logic_vector (7 downto 0) := (others => '0');


begin

P_MAIN : process (clk) begin
if (rising_edge(clk)) then

	case state is
	
		when idle =>
		
			op			<= '1';
			done	<= '0';
			bitcntr			<= 0;
			
			if (strt = '1') then
				state	<= start;
				op	<= '0';
				shreg	<= data_in;
			end if;
		
		when start =>
		
			
			if (bittimer = bit_timer_limit-1) then
				state				<= data;
				op				<= shreg(0);
				shreg(7)			<= shreg(0);
				shreg(6 downto 0)	<= shreg(7 downto 1);
				bittimer			<= 0;
			else
				bittimer			<= bittimer + 1;
			end if;
			
		when data =>
		
			
		
			if (bitcntr = 7) then
				if (bittimer = bit_timer_limit-1) then
					
					bitcntr				<= 0;
					state				<= stop;
					op				<= '1';
					bittimer			<= 0;
				else
					bittimer			<= bittimer + 1;					
				end if;			
			else
				if (bittimer = bit_timer_limit-1) then
					
					shreg(7)			<= shreg(0);
					shreg(6 downto 0)	<= shreg(7 downto 1);					
					op				<= shreg(0);
					bitcntr				<= bitcntr + 1;
					bittimer			<= 0;
				else
					bittimer			<= bittimer + 1;					
				end if;
			end if;
		
		when stop =>
		
			if (bittimer = stop_bit_lim-1) then
				state				<= idle;
				done		<= '1';
				bittimer			<= 0;
			else
				bittimer			<= bittimer + 1;				
			end if;		
	
	end case;

end if;
end process;


end Behavioral;