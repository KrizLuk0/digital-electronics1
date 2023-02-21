----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/21/2023 02:06:25 PM
-- Design Name: 
-- Module Name: tb_MUX_3bit - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_MUX_3bit is
 --signals

end tb_MUX_3bit;

architecture Behavioral of tb_MUX_3bit is
    signal s_a           : std_logic_vector(3 - 1 downto 0);
    signal s_b           : std_logic_vector(3- 1 downto 0);
    signal s_c :        std_logic_vector(3 - 1 downto 0);
    signal s_d :        std_logic_vector(3 - 1 downto 0);
    signal s_f_o:       std_logic_vector(3 - 1 downto 0);
    signal s_sel_i:     std_logic_vector(2 - 1 downto 0);
    
begin
uut_MUX_3bit: entity work.MUX_3bit
        port map(
            a_i           => s_a,
            b_i           => s_b,
            c_i           => s_c,
            d_i           => s_d,
            f_o         => s_f_o,
            sel_i       =>s_sel_i
        );
    


end Behavioral;
