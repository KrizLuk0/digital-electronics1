----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2023 21:12:53
-- Design Name: 
-- Module Name: Synchronizer - Behavioral
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

entity Synchronizer is
   -- generic (
       -- NUM_STAGES : integer := 2 
   -- );
    port (
        clk_i     : in std_logic;
        reset_i   : in std_logic;
        sig_i     : in std_logic;
        sig_o     : out std_logic
        
    );
    
end Synchronizer;

architecture Behavioral of Synchronizer is
    signal sig_temp : std_logic;
   -- type syns_regs is array (NUM_STAGES-1 downto 0) of std_logic; 
begin
    process(clk_i, reset_i)
        begin
           if(reset_i ='1') then
                sig_temp    <= '0';
                sig_o       <= '0'; 
           elsif (clk_i'event and clk_i='1') then
                sig_temp    <=sig_i;
                sig_o       <=sig_temp;
           end if; 
    end process;

end Behavioral;
