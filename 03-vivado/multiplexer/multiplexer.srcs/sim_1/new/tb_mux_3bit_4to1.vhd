----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.02.2023 20:28:10
-- Design Name: 
-- Module Name: tb_mux_3bit_4to1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_mux_3bit_4to1 is
    
end tb_mux_3bit_4to1;

architecture Behavioral of tb_mux_3bit_4to1 is
    signal s_a           : std_logic_vector(3 - 1 downto 0);
    signal s_b           : std_logic_vector(3 - 1 downto 0);
    signal s_c           : std_logic_vector(3 - 1 downto 0);
    signal s_d           : std_logic_vector(3 - 1 downto 0);
    signal s_sel         : std_logic_vector(2 - 1 downto 0);
    
    signal s_f           : std_logic_vector(3 - 1 downto 0);
begin
    UUT : entity work.mux_3bit_4to1
          port map(
              a_i           => s_a,
              b_i           => s_b,
              c_i           => s_c,
              d_i           => s_d,
              sel_i         => s_sel,
              f_o           => s_f
          );	
  stim_proc: process
  	begin
  	    s_a<="001";
  	    s_b<="000";
  	    s_c<="000";
  	    s_d<="001";
  	    
    	s_sel <="00";
    	wait for 100 ns;
    	s_sel <="01";
    	wait for 100 ns;
    	s_sel <="10";
    	wait for 100 ns;
    	s_sel <="11";
        wait for 100 ns;
  	end process;

end Behavioral;
