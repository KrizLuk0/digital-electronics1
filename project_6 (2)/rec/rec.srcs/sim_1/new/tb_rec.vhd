library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity uart_rx_tb is
end uart_rx_tb;

architecture testbench of uart_rx_tb is
    signal clk, reset, rx, s_tick, rx_done_tick : std_logic;
    signal dout : std_logic_vector (7 downto 0);
begin
    DUT: entity work.uart_rx
    generic map (
        DBIT => 8,
        SB_TICK => 16
    )
    port map (
        clk => clk,
        reset => reset,
        rx => rx,
        s_tick => s_tick,
        rx_done_tick => rx_done_tick,
        dout => dout
    );
    CLKGEN: process
    begin
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
    end process CLKGEN;

    STIMULUS: process
    begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';

        -- test 1
        rx <= '0';
        s_tick <= '0';
        wait for 100 ns;
        assert rx_done_tick = '0' report "Error: rx_done_tick not '0'" severity error;
        wait for 100 ns;
        assert rx_done_tick = '0' report "Error: rx_done_tick not '0'" severity error;
        s_tick <= '1';
        wait for 100 ns;
        assert rx_done_tick = '0' report "Error: rx_done_tick not '0'" severity error;
        wait for 100 ns;
        assert rx_done_tick = '0' report "Error: rx_done_tick not '0'" severity error;

        -- test 2
        rx <= '1';
        s_tick <= '0';
        wait for 100 ns;
        assert rx_done_tick = '0' report "Error: rx_done_tick not '0'" severity error;
        wait for 100 ns;
        assert rx_done_tick = '0' report "Error: rx_done_tick not '0'" severity error;
        s_tick <= '1';
        wait for 100 ns;
        assert rx_done_tick = '0' report "Error: rx_done_tick not '0'" severity error;
        wait for 100 ns;
        assert rx_done_tick = '1' report "Error: rx_done_tick not '1'" severity error;
        wait;
    end process STIMULUS;

end testbench;
