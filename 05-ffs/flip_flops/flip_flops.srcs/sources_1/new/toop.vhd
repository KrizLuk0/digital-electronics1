----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.03.2023 16:22:53
-- Design Name: 
-- Module Name: toop - Behavioral
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

entity toop is
    Port ( CLK100MHZ : in STD_LOGIC;
           BTNC : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (0 downto 0);
           LED : out STD_LOGIC_VECTOR (3 downto 0));
end toop;

architecture Behavioral of toop is
 -- Internal signals between flip-flops
    signal sig_ff0 : std_logic;
    signal sig_ff1 : std_logic;
    signal sig_ff2 : std_logic;
    signal sig_ff3 : std_logic;
    signal sig_LED : std_logic_vector(3 downto 0);
    

  -- WRITE YOUR CODE HERE

begin
    LED(0) <=sig_ff0;
    LED(1) <=sig_ff1;
    LED(2) <=sig_ff2;
    LED(3) <=sig_ff3;
  --------------------------------------------------------------------
  -- Four instances (copies) of D-type FF entity
  d_ff_0 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d => SW(0),
          q  => sig_ff0
           
      );

  d_ff_1 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d=> sig_ff0,
          q=>sig_ff1
          -- WRITE YOUR CODE HERE
           
      );
 d_ff_2 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d => sig_ff1,
          q=>sig_ff2
                  -- WRITE YOUR CODE HERE
          
      );

  d_ff_3 : entity work.d_ff_rst
      port map (
          clk => CLK100MHZ,
          rst => BTNC,
          d=> sig_ff2,
          q=>LED(3)
        
          -- WRITE YOUR CODE HERE
      );      

    
         


  -- PUT OTHER TWO FLIP-FLOP INSTANCES HERE



end Behavioral;
