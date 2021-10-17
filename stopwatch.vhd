-- stopwatch.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity stopwatch is
	port(
		iCLK, inRST: in std_logic;
		oSEC: out std_logic_vector(7 downto 0)
	);
end stopwatch;

architecture arch of stopwatch is
	signal counter_reg, counter_next: unsigned(7 downto 0) := (others => '0');
	signal done: std_logic;
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
	counter_next <= counter_reg + 1 when done = '1'	else counter_reg;
	
	-- output
	oSEC <= std_logic_vector(counter_reg);
	
	fd: entity work.freq_divider port map(iCLK => iCLK, inRST => inRST, oTC => done);
end arch;