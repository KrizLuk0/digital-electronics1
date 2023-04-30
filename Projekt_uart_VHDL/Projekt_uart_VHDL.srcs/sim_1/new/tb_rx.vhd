library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

entity top_tb is
end entity;

architecture sim of top_tb is
    signal CLK100MHZ   :   std_logic := '0';
    signal reset       :   std_logic := '1';
    signal rx          :   std_logic := '0';
    signal tx_active_o :   std_logic := '0';
    signal tx          :   std_logic;
    signal CA          :   std_logic;
    signal CB          :   std_logic;
    signal CC          :   std_logic;
    signal CD          :   std_logic;
    signal CE          :   std_logic;
    signal CF          :   std_logic;
    signal CG          :   std_logic;
    signal DP          :   std_logic;
    signal AN          :   std_logic_vector (7 downto 0);
    signal SW          :   std_logic_vector(8-1 downto 0);
    signal Segment     :   std_logic_vector(8-1 downto 0);
constant clk_i_period : time := 10 ns;   -- 10ns period = 100MHz
begin
    uut : entity work.top
    generic map (
        DBIT => 8,
        SB_TICK => 16,
        DVSR => 652,
        DVSR_BIT => 8
    )
    port map (
        CLK100MHZ => CLK100MHZ,
        reset => reset,
        rx => rx,
        SW => SW,
        tx => tx,
        tx_active_o => tx_active_o,
        CA => CA,
        CB => CB,
        CC => CC,
        CD => CD,
        CE => CE,
        CF => CF,
        CG => CG,
        DP => DP,
        AN => AN
    );

     process
    begin
        CLK100MHZ <= '0';
        wait for clk_i_period/2;
        CLK100MHZ <= '1';
        wait for clk_i_period/2;
    end process;

    process
    begin
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 100 ns;
    end process;
    process
    begin
        SW <= "00000001"; -- set switch value to 1
        wait for 50 ns;
        SW <= "00000010"; -- set switch value to 2
        wait for 50 ns;
        SW <= "00000100"; -- set switch value to 4
        wait for 50 ns;
        SW <= "00001000"; -- set switch value to 8
        wait for 50 ns;
        SW <= "00010000"; -- set switch value to 16
        wait for 50 ns;

        wait for 100 ns;
        wait;
    end process;

end sim;
