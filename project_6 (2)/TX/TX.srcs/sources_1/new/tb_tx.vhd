library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_transmitter is
    generic(
           DBIT : integer :=8;
           SB_TICK : integer :=16
    );
    Port ( clk           : in STD_LOGIC;
           reset         : in STD_LOGIC;
           s_tick        : in STD_LOGIC;
           din           : in STD_LOGIC_VECTOR (7 downto 0);
           tx_start      : in STD_LOGIC;
           tx            : out STD_LOGIC;
           tx_done_tick  : out STD_LOGIC);
end uart_transmitter;

architecture arch of uart_transmitter is
    type state_type is (idle, start, data, stop);
    signal state_reg  : state_type;
    signal state_next : state_type;
    signal s_reg      : unsigned (3 downto 0);
    signal s_next     : unsigned (3 downto 0);
    signal n_reg      : unsigned (2 downto 0);
    signal n_next     : unsigned (2 downto 0);
    signal b_reg      : std_logic_vector (7 downto 0);
    signal b_next     : std_logic_vector (7 downto 0);
    signal tx_reg     : std_logic;
    signal tx_next    : std_logic;
    
    
begin
   process(clk,reset)
   begin
      if reset = '1' then
         state_reg <= idle;
         s_reg <= (others=>'0');
         n_reg <= (others=>'0');
         b_reg <= (others=>'0');
         tx_reg <= '1';
      elsif (clk 'event and clk='1') then
         state_reg <= state_next;
         s_reg <= s_next;
         n_reg <= n_next;
         b_reg <= b_next;
         tx_reg <= tx_next;
      end if;
   end process;
   
   process (state_reg, s_reg, n_reg, b_reg, s_tick, tx_reg, tx_start, din)
   
   begin
      state_next <= state_reg;
      s_next <= s_reg;
      n_next <= n_reg;
      b_next <= b_reg;
      tx_next <= tx_reg;
      tx_done_tick <= '0';
      case state_reg is
         when idle =>
            tx_next <= '1';
            if tx_start = '1' then
               state_next <= start;
               s_next <= (others=>'0');
               b_next <= din;
            end if;
         when start =>
            tx_next <= '0';
            if (s_tick = '1') then
               if s_reg=15 then
                  state_next <= data;
                  s_next <= (others=>'0');
                  n_next <= (others=>'0');
               else
                  s_next <= s_reg + 1;
               end if;
             end if;
          when data =>
             tx_next <= b_reg(0);
             if (s_tick = '1') then
                if s_reg=15 then
                   s_next <= (others=>'0');
                   b_next <= '0'& b_reg(7 downto 1);
                   if n_reg=(DBIT-1) then
                      state_next <= stop;
                   else
                      n_next <= n_reg + 1;
                   end if;
                else
                   s_next <= s_reg + 1;
                end if;
             end if;
          when stop =>
             tx_next <= '1';
             if (s_tick = '1') then
                if s_reg=(SB_TICK-1) then
                   state_next <= idle;
                   tx_done_tick <= '1';
                else
                   s_next <= s_reg + 1;
                end if;
             end if;
       end case;
    end process;
    tx <= tx_reg;
end arch;