-------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity tb_topa is
--  Port ( );
end tb_topa;

architecture testbench of tb_topa is
    signal s_SW :  std_logic_vector(3 downto 0);
    signal s_LED :  std_logic_vector(7 downto 0);
    signal s_CA : std_logic;
    signal s_CB : std_logic;
    signal s_CC : std_logic;
    signal s_CD : std_logic;
    signal s_CE : std_logic;
    signal s_CF : std_logic;
    signal s_CG : std_logic;
    signal s_AN : std_logic_vector(7 downto 0);
    signal s_BTNC : std_logic;
    
begin
    uut_top : entity work.top
        port map(
            SW => s_SW,
            LED => s_LED,
            CA => s_CA,
            CB => s_CB,
            CC => s_CC,
            CD => s_CD,
            CE => s_CE,
            CF => s_CF,
            CG => s_CG,
            AN => s_AN,
            BTNC => s_BTNC
            );
        p_stimulus : process is
             begin

    report "Stimulus process started";   
      for ii in 0 to 15 loop
      -- Convert ii decimal value to 4-bit wide binary
      -- s_hex <= std_logic_vector(to_unsigned(ii, s_hex'length));
        s_SW <= std_logic_vector(to_unsigned(ii, 4));
      wait for 50 ns;

    end loop;
    
    report "Stimulus process finished";
    wait;

  end process p_stimulus;             
            

end testbench;
