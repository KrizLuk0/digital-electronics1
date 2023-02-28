----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.02.2023 18:17:25
-- Design Name: 
-- Module Name: tb_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_top is
--  Port ( );
end tb_top;

architecture Behavioral of tb_top is

           sig_SW:  in STD_LOGIC_VECTOR (3 downto 0);
           sig_LED: out STD_LOGIC_VECTOR (7 downto 0);
           sig_CA : out STD_LOGIC;
           sig_CB : out STD_LOGIC;
           sig_CC : out STD_LOGIC;
           sig_CD : out STD_LOGIC;
           sig_CE : out STD_LOGIC;
           sig_CF : out STD_LOGIC;
           sig_CG : out STD_LOGIC;
           sig_AN : out STD_LOGIC_VECTOR (7 downto 0);
           sig_BTNC : in STD_LOGIC;
begin
uut_hex_7seg : entity work.top
    port map (
      SW => sig_SW,
      LED   => sig_LED,
      CA   => sig_seg
    );


end Behavioral;
