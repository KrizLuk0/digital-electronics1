library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity uart_tx_tb is
end uart_tx_tb;

architecture Behavioral of uart_tx_tb is

    -- Component Declaration
    component uart_tx
        generic(
            DBIT    : integer := 8;
            SB_TICK : integer := 16
        );
        Port (
            clk      : in  std_logic;
            reset    : in  std_logic;
            s_tick   : in  std_logic;
            din      : in  std_logic_vector(7 downto 0);
            tx_start : in  std_logic;
            tx       : out std_logic
        );
    end component;

    -- Clock Signal
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal s_tick   : std_logic := '0';
    signal din      : std_logic_vector(7 downto 0) := (others => '0');
    signal tx_start : std_logic := '0';
    signal tx       : std_logic;
    constant clk_i_period : time := 10 ns;   -- 10ns period = 100MHz

begin

    -- DUT Instantiation
    DUT: uart_tx
        generic map(
            DBIT    => 8,
            SB_TICK => 16
        )
        port map(
            clk      => clk,
            reset    => reset,
            s_tick   => s_tick,
            din      => din,
            tx_start => tx_start,
            tx       => tx
        );

    -- Clock Generation
    process
    begin
        while true loop
            clk <= '0';
            wait for clk_i_period/2;
            clk <= '1';
            wait for clk_i_period/2;
        end loop;
    end process;

    -- Stimulus Process
    process
    begin
              wait for 100 ns;	
      wait for 100 ns;
		
		tx_start <= '0';                    -- start sending bits in 8N1 UART standart at 9600 baud
		wait for 100 ns;
		
		tx_start <= '1';
		s_tick <= '1';					-- return to passsive state
		wait for 100 ns;
		
		tx_start <= '0';
		s_tick <= '0';
		wait for 100 ns;

		
			
      wait;
    end process;

end Behavioral;
