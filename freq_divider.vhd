-- freq_divider.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity freq_divider is
	generic(
		N : integer := 9); -- divide freq by 10 (for simulation purposes only), counter starts at 0
	port(
		iCLK, inRST: in std_logic;
		oTC: out std_logic
	);
end freq_divider;

architecture arch of freq_divider is
	signal counter_reg, counter_next: unsigned(28 downto 0) := (others => '0');
begin
	-- register
	process(iCLK, inRST)
	begin
		if (inRST = '1') then
			counter_reg <= (others => '0');
		elsif (iCLK'event and iCLK = '1') then
			counter_reg <= counter_next;
		end if;
	end process;
	
	-- next-state logic
	counter_next <= (others => '0') when counter_reg = N else counter_reg + 1;
	
	-- output
	oTC <= '1' when counter_reg = N else '0';
end arch;