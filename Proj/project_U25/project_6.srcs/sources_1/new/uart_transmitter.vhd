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
   Port ( clk           : in STD_LOGIC;        -- vstupní hodiny
           reset         : in STD_LOGIC;        -- vstupní reset
           s_tick        : in STD_LOGIC;        -- vstupní hodiny pro sbìrnici
           din           : in STD_LOGIC_VECTOR (7 downto 0); -- vstupní data
           tx_start      : in STD_LOGIC;        -- spuštìní vysílání
           tx            : out STD_LOGIC;       -- výstupní vysílací signál
           tx_done_tick  : out STD_LOGIC);      -- signál pro indikaci dokonèení vysílání
end uart_transmitter;

architecture arch of uart_transmitter is
   type state_type is (idle, start, data, stop);  -- typ pro stavy koneèného automatu
    signal state_reg  : state_type;   -- registr pro ukládání aktuálního stavu
    signal state_next : state_type;   -- registr pro ukládání následujícího stavu
    signal s_reg      : unsigned (3 downto 0);   -- registr pro ukládání aktuálního stavu sbìrnice
    signal s_next     : unsigned (3 downto 0);   -- registr pro ukládání následujícího stavu sbìrnice
    signal n_reg      : unsigned (2 downto 0);   -- registr pro ukládání aktuálního èítaèe bitù
    signal n_next     : unsigned (2 downto 0);   -- registr pro ukládání následujícího èítaèe bitù
    signal b_reg      : std_logic_vector (7 downto 0);   -- registr pro ukládání aktuálního pøenášeného bytu
    signal b_next     : std_logic_vector (7 downto 0);   -- registr pro ukládání následujícího pøenášeného bytu
    signal tx_reg     : std_logic;    -- registr pro ukládání aktuálního vysílacího signálu
    signal tx_next    : std_logic;    -- registr pro ukládání následujícího vysílacího signálu
    
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
   state_next <= state_reg; -- nastaví další stav
   s_next <= s_reg; -- nastaví další S registr
   n_next <= n_reg; -- nastaví další N registr
   b_next <= b_reg; -- nastaví další B registr
   tx_next <= tx_reg; -- nastaví další TX registr
   tx_done_tick <= '0'; -- nastaví TX dokonèeno na nulu
   case state_reg is -- vybere stav dle stavu registrace
      when idle =>
         tx_next <= '1'; -- nastaví TX registr na jednièku
         if tx_start = '1' then -- pokud je TX_start na jednièce
            state_next <= start; -- nastaví další stav na start
            s_next <= (others=>'0'); -- nastaví S registr na nulu
            b_next <= din; -- nastaví B registr na zadaný vstup
         end if;
      when start =>
         tx_next <= '0'; -- nastaví TX registr na nulu
         if (s_tick = '1') then -- pokud je S_tick na jednièce
            if s_reg=15 then -- pokud je S registr rovno 15
               state_next <= data; -- nastaví další stav na data
               s_next <= (others=>'0'); -- nastaví S registr na nulu
               n_next <= (others=>'0'); -- nastaví N registr na nulu
            else
               s_next <= s_reg + 1; -- nastaví S registr na další hodnotu
            end if;
          end if;
      when data =>
         tx_next <= b_reg(0); -- nastaví TX registr na hodnotu B registru (nejnižší bit)
         if (s_tick = '1') then -- pokud je S_tick na jednièce
            if s_reg=15 then -- pokud je S registr rovno 15
               s_next <= (others=>'0'); -- nastaví S registr na nulu
               b_next <= '0'& b_reg(7 downto 1); -- nastaví B registr na hodnotu posunutou o jeden bit vlevo
               if n_reg=(DBIT-1) then -- pokud je N registr rovno DBIT - 1 (nastavení datové délky)
                  state_next <= stop; -- nastaví další stav na stop
               else
                  n_next <= n_reg + 1; -- nastaví N registr na další hodnotu
               end if;
            else
               s_next <= s_reg + 1; -- nastaví S registr na další hodnotu
            end if;
         end if;
      when stop =>
         tx_next <= '1'; -- nastaví TX registr na jednièku
         if (s_tick = '1') then -- pokud je S_tick na jednièce
            if s_reg=(SB_TICK-1) then -- pokud je S registr rovno SB_TICK - 1 (poèet tickù pro stop bit)
               state_next <= idle; -- nastaví další stav na idle
               tx_done_tick <= '1'; -- nastaví TX dokonèeno na jednièku
             else  
                   s_next <= s_reg + 1;
                end if;
             end if;
       end case;
    end process;
    tx <= tx_reg;
end arch;