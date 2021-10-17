-- controlled_stopwatch.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controlled_stopwatch is
	port(
		iCLK, inRST, inSTART, inSTOP, inCONTINUE: in std_logic;
		oSEC: out std_logic_vector(7 downto 0)
	);
end controlled_stopwatch;

architecture arch of controlled_stopwatch is
	type state_type is (idle, state_on, state_off);
	signal state_reg, state_next: state_type;
	signal counter_reg, counter_next: unsigned(7 downto 0) := (others => '0');
	signal done: std_logic;
	signal fdRST: std_logic;
begin
	-- register
	process(iCLK, inRST)
	begin
		if (inRST = '1') then
			counter_reg <= (others => '0');
			state_reg <= idle;
		elsif (iCLK'event and iCLK = '1') then
			counter_reg <= counter_next;
			state_reg <= state_next;
		end if;
	end process;
	
	
	-- fsmd next-state logic
	process(state_reg, inSTART, inCONTINUE, inSTOP, done)
	begin
		counter_next <= counter_reg;
		state_next <= state_reg;
		
		case state_reg is
			when idle =>
				if inSTART = '1' then
					counter_next <= (others => '0');
					state_next <= state_on;
				end if;
			when state_on =>
				if inSTART = '1' then
					counter_next <= (others => '0');
				else
					if done = '1' then
						counter_next <= counter_reg + 1;
					end if;
				end if;
				
				if inSTOP = '1' then
					state_next <= state_off;
				end if;
			when state_off =>
				if inCONTINUE = '1' then
					state_next <= state_on;
				elsif inSTART = '1' then
					counter_next <= (others => '0');
					state_next <= state_on;
				end if;
		end case;
	end process;
	

	-- output
	oSEC <= std_logic_vector(counter_reg);
	
	fdRST <= inRST or inSTART;
	fd: entity work.freq_divider port map(iCLK => iCLK, inRST => fdRST, oTC => done);
end arch;