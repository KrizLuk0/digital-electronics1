library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_top_tb is
end uart_top_tb;

architecture Behavioral of uart_top_tb is

    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal data_in : std_logic_vector(7 downto 0) := "00000000";
    signal tx_start : std_logic := '0';
    signal tx : std_logic;
    signal rx : std_logic := '0';
    signal data_out : std_logic_vector(7 downto 0);
    signal rx_done : std_logic;

begin

    uart : entity work.uart_top
        generic map (
            BAUD_RATE => 9600
        )
        port map (
            clk => clk,
            reset => reset,
            data_in => data_in,
            tx_start => tx_start,
            tx => tx,
            rx => rx,
            data_out => data_out,
            rx_done => rx_done
        );

    -- Clock generation
  clk_process : process
    begin
        while now < 2000000 ns loop  -- Run for 2 ms
            clk <= not clk;
            wait for 500 ns;
        end loop;
        wait;
    end process;

    -- Stimulus process
  stimulus : process
begin
    -- Wait for reset to be released
    reset <= '1';
    wait for 10 ns;
    reset <= '0';

    -- Transmit "Hello world" over UART
    tx_start <= '1';
    data_in <= "01001000";  -- H
    wait for 104 us;         -- Wait for 1 start bit + 8 data bits + 1 stop bit @ 9600 baud
    data_in <= "01100101";  -- e
    wait for 104 us;
    data_in <= "01101100";  -- l
    wait for 104 us;
    data_in <= "01101100";  -- l
    wait for 104 us;
    data_in <= "01101111";  -- o
    wait for 104 us;
    data_in <= "00100000";  -- space
    wait for 104 us;
    data_in <= "01110111";  -- w
    wait for 104 us;
    data_in <= "01101111";  -- o
    wait for 104 us;
    data_in <= "01110010";  -- r
    wait for 104 us;
    data_in <= "01101100";  -- l
    wait for 104 us;
    data_in <= "01100100";  -- d
    wait for 104 us;
    tx_start <= '0';

    -- Wait for transmission to complete
    wait until rx_done = '1';

    -- Check received data
    assert data_out = "01001000" and
           data_out = "01100101" and
           data_out = "01101100" and
           data_out = "01101100" and
           data_out = "01101111" and
           data_out = "00100000" and
           data_out = "01110111" and
           data_out = "01101111" and
           data_out = "01110010" and
           data_out = "01101100" and
           data_out = "01100100"
           report "Received data is incorrect" severity error;

    wait;

end process;
receive : process
    begin
        wait until tx_start = '0';
        wait for 1 us;
        rx <= '1';
        wait until rx_done = '1';
        rx <= '0';
        wait;
    end process;

end Behavioral;
