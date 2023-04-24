library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity uart_transmitter_tb is
end uart_transmitter_tb;

architecture Behavioral of uart_transmitter_tb is
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';
  signal s_tick: std_logic := '0';
  signal din: std_logic_vector(7 downto 0) := (others => '0');
  signal tx_start: std_logic := '0';
  signal tx: std_logic;
  signal tx_done_tick: std_logic;

  constant clk_period: time := 10 ns;

begin
  -- Instantiate the Unit Under Test (UUT)
  uut: entity work.uart_transmitter
    generic map (
      DBIT => 8,
      SB_TICK => 16
    )
    port map (
      clk => clk,
      reset => reset,
      s_tick => s_tick,
      din => din,
      tx_start => tx_start,
      tx => tx,
      tx_done_tick => tx_done_tick
    );

  -- Clock
  process
  begin
    while now < 1000 ns loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  process
  begin
    reset <= '1';
    tx_start <= '0';
    din <= (others => '0');

    wait for 100 ns;
    reset <= '0';

    wait for 10 ns;
    tx_start <= '1';
    din <= x"41"; -- ASCII 'A'

    wait for 800 ns;

    assert tx = '0' report "TX should be low during start bit" severity error;

    wait for 80 ns;

    assert tx = '1' report "TX should be high during stop bits" severity error;

    wait for 10 ns;

    assert tx = '1' report "TX should be high in idle state" severity error;

    wait;

  end process;

end Behavioral;
