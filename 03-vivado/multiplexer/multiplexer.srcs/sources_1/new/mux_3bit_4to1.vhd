----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.02.2023 20:27:08
-- Design Name: 
-- Module Name: mux_3bit_4to1 - Behavioral
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


entity mux_3bit_4to1 is
    port(
    	a_i  	: 	in std_logic_vector(3-1 downto 0);
        b_i  	: 	in std_logic_vector(3-1 downto 0);
        c_i  	: 	in std_logic_vector(3-1 downto 0);
        d_i  	: 	in std_logic_vector(3-1 downto 0);
        sel_i   :   in std_logic_vector(2-1 downto 0);
        f_o  	: 	out std_logic_vector(3-1 downto 0)
        );
end mux_3bit_4to1;

architecture Behavioral of mux_3bit_4to1 is
    
begin
	f_o <= a_i when (sel_i="00") else
          b_i  when (sel_i="01") else
          c_i  when (sel_i="10") else
          d_i; 
end Behavioral;
