----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2023 01:12:55 PM
-- Design Name: 
-- Module Name: uart_rx - Behavioral
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
use IEEE.math_real.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_rx is
     generic (
    DBIT : natural := 8;
    STOP_BIT : natural := 16    
  );
  port(
  --Inputs
    clk : in  std_logic;
    reset : in std_logic;
    rx : in std_logic;
    s_stick : in std_logic;
    --Outputs
    rx_done : out std_logic;
    rx_dout : out std_logic_vector(DBIT-1 downto 0)
    

  );
end uart_rx;

architecture Behavioral of uart_rx is
    signal state_reg : std_logic_vector(2-1 downto 0 );
    signal state_next : std_logic_vector(2-1 downto 0 );
    signal s_reg : std_logic_vector(4-1 downto 0 );
    signal s_next : std_logic_vector(4-1 downto 0 );
    signal n_reg : std_logic_vector(integer(ceil(log2(real(DBIT))))-1 downto 0);
    signal n_next : std_logic_vector(integer(ceil(log2(real(DBIT))))-1 downto 0);
    signal b_reg : std_logic_vector(DBIT-1 downto 0 );
    signal b_next : std_logic_vector(DBIT-1 downto 0 );
        
begin
    process(clk,reset)
    begin
        if (reset='1')
            state_reg <=           
        
    end process;
end Behavioral;
