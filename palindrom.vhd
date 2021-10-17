entity palindrom is
  port(reset,clk : in std_logic;
      outputBrojaca: in std_logic;
      jelOk : out std_logic);
end palindrom;


architecture Behavioral of palindrom is
type statetype is(idle, pom, ok ,eror);
signal ts, ss: statetype;

component brojac
  port( clk, reset, enable : in std_logic;
        oBrojaaca: out std_logic_vector(3 downto 0);
        
end component;

component clockdivider
  port( clk, reset: in std_logic;
        clock_out : out std_logic);
end component;

signal stanjeBrojaca : std_logic_vector(3 downto 0);
signal enableZaBrojac : std_logic;
signal jelOk_sad, jekOk_next : std_logic;
signal moj_clock : std_logic;

begin 

  clkdiv: clockdivider port map(clk => clk, reset => reset, clock_out => moj_clock);
  moj_brojac : brojac port map (clk=> moj_clock, reset => reset, enable = > enableZaBrojac, oBrojaca => stanjeBrojaca);
  
  process(reset, moj_clock, ts, stanjeBrojaca, jelOk_sad, jelOk_next)
  
  begin
  
    if(reset = '1') then 
      ts <= idle;
      outputBrojaca <= stanjeBrojaca;
    elsif(rising_edge(moj_clock)) then 
      ts <= ss;
      jelOk_sad <= jelOk_next;
      outputBrojaca <= stanjeBrojaca;
    end if;
    
   end process;
   
  process(ts, ss, jelOK_next, jelOK_sad, enableZaBrojac, stanjeBrojaca)
  
  begin
  
  jelOk_next <= jelOk_sad;
  ss <= ts;
  
    case ts is 
    
      when idle => enableZaBrojac <= '1';
                   jelOk_next <= '0';
                   ss <= pom;
      when pom => enableZaBrojac <= '0';
                  if(stanjeBrojaca(3 downto 2) = stanjeBrojaca(1 downto 0)) then 
                    ss <= ok;
                  else
                    ss <= error;
                  end if;
      when ok => jelOk_next <= '1';
                 ss <= idle;
      when error => jelOk_next <= '0';
                 ss <= idle;
     
     end case;
     
  end process;
  
  jelOK <= jelOK_sad;
 
end process;
