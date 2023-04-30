library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity mod_m_counter_tb is
end mod_m_counter_tb;

architecture Behavioral of mod_m_counter_tb is

    signal clk         :   std_logic := '0';
    signal reset       :   std_logic := '0';
    signal max_tick    :   std_logic;
    signal q           :   std_logic_vector(3 downto 0);
    
    constant clk_period : time := 10 ns;

begin

    DUT : entity work.mod_m_counter
        generic map (
            N => 4,
            M => 10
        )
        port map (
            clk         => clk,
            reset       => reset,
            max_tick    => max_tick,
            q           => q
        );
        
    clk_process : process
    begin
        while now < 1000 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    reset_process : process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait;
    end process;

    stim_proc: process
    begin
        wait for 20 ns; -- Wait for initial reset to complete
        
        -- Check output for first 10 ticks
        for i in 0 to 9 loop
            wait until rising_edge(clk);
            assert q = std_logic_vector(to_unsigned(i, 4)) report "Error on tick " & integer'image(i) severity error;
            assert max_tick = '0' report "Error on tick " & integer'image(i) severity error;
        end loop;

        -- Check output for 10th tick (max_tick should be high)
        wait until rising_edge(clk);
        assert q = "1001" report "Error on tick 10" severity error;
        assert max_tick = '1' report "Error on tick 10" severity error;

        -- Check output for additional ticks (max_tick should stay high)
        for i in 11 to 20 loop
            wait until rising_edge(clk);
            assert q = "1001" report "Error on tick " & integer'image(i) severity error;
            assert max_tick = '1' report "Error on tick " & integer'image(i) severity error;
        end loop;

        wait;
    end process;

end Behavioral;
