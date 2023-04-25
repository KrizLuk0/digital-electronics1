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
   Port ( clk           : in STD_LOGIC;        -- vstupn� hodiny
           reset         : in STD_LOGIC;        -- vstupn� reset
           s_tick        : in STD_LOGIC;        -- vstupn� hodiny pro sb�rnici
           din           : in STD_LOGIC_VECTOR (7 downto 0); -- vstupn� data
           tx_start      : in STD_LOGIC;        -- spu�t�n� vys�l�n�
           tx            : out STD_LOGIC;       -- v�stupn� vys�lac� sign�l
           tx_done_tick  : out STD_LOGIC);      -- sign�l pro indikaci dokon�en� vys�l�n�
end uart_transmitter;

architecture arch of uart_transmitter is
   type state_type is (idle, start, data, stop);  -- typ pro stavy kone�n�ho automatu
    signal state_reg  : state_type;   -- registr pro ukl�d�n� aktu�ln�ho stavu
    signal state_next : state_type;   -- registr pro ukl�d�n� n�sleduj�c�ho stavu
    signal s_reg      : unsigned (3 downto 0);   -- registr pro ukl�d�n� aktu�ln�ho stavu sb�rnice
    signal s_next     : unsigned (3 downto 0);   -- registr pro ukl�d�n� n�sleduj�c�ho stavu sb�rnice
    signal n_reg      : unsigned (2 downto 0);   -- registr pro ukl�d�n� aktu�ln�ho ��ta�e bit�
    signal n_next     : unsigned (2 downto 0);   -- registr pro ukl�d�n� n�sleduj�c�ho ��ta�e bit�
    signal b_reg      : std_logic_vector (7 downto 0);   -- registr pro ukl�d�n� aktu�ln�ho p�en�en�ho bytu
    signal b_next     : std_logic_vector (7 downto 0);   -- registr pro ukl�d�n� n�sleduj�c�ho p�en�en�ho bytu
    signal tx_reg     : std_logic;    -- registr pro ukl�d�n� aktu�ln�ho vys�lac�ho sign�lu
    signal tx_next    : std_logic;    -- registr pro ukl�d�n� n�sleduj�c�ho vys�lac�ho sign�lu
    
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
   state_next <= state_reg; -- nastav� dal�� stav
   s_next <= s_reg; -- nastav� dal�� S registr
   n_next <= n_reg; -- nastav� dal�� N registr
   b_next <= b_reg; -- nastav� dal�� B registr
   tx_next <= tx_reg; -- nastav� dal�� TX registr
   tx_done_tick <= '0'; -- nastav� TX dokon�eno na nulu
   case state_reg is -- vybere stav dle stavu registrace
      when idle =>
         tx_next <= '1'; -- nastav� TX registr na jedni�ku
         if tx_start = '1' then -- pokud je TX_start na jedni�ce
            state_next <= start; -- nastav� dal�� stav na start
            s_next <= (others=>'0'); -- nastav� S registr na nulu
            b_next <= din; -- nastav� B registr na zadan� vstup
         end if;
      when start =>
         tx_next <= '0'; -- nastav� TX registr na nulu
         if (s_tick = '1') then -- pokud je S_tick na jedni�ce
            if s_reg=15 then -- pokud je S registr rovno 15
               state_next <= data; -- nastav� dal�� stav na data
               s_next <= (others=>'0'); -- nastav� S registr na nulu
               n_next <= (others=>'0'); -- nastav� N registr na nulu
            else
               s_next <= s_reg + 1; -- nastav� S registr na dal�� hodnotu
            end if;
          end if;
      when data =>
         tx_next <= b_reg(0); -- nastav� TX registr na hodnotu B registru (nejni��� bit)
         if (s_tick = '1') then -- pokud je S_tick na jedni�ce
            if s_reg=15 then -- pokud je S registr rovno 15
               s_next <= (others=>'0'); -- nastav� S registr na nulu
               b_next <= '0'& b_reg(7 downto 1); -- nastav� B registr na hodnotu posunutou o jeden bit vlevo
               if n_reg=(DBIT-1) then -- pokud je N registr rovno DBIT - 1 (nastaven� datov� d�lky)
                  state_next <= stop; -- nastav� dal�� stav na stop
               else
                  n_next <= n_reg + 1; -- nastav� N registr na dal�� hodnotu
               end if;
            else
               s_next <= s_reg + 1; -- nastav� S registr na dal�� hodnotu
            end if;
         end if;
      when stop =>
         tx_next <= '1'; -- nastav� TX registr na jedni�ku
         if (s_tick = '1') then -- pokud je S_tick na jedni�ce
            if s_reg=(SB_TICK-1) then -- pokud je S registr rovno SB_TICK - 1 (po�et tick� pro stop bit)
               state_next <= idle; -- nastav� dal�� stav na idle
               tx_done_tick <= '1'; -- nastav� TX dokon�eno na jedni�ku
             else  
                   s_next <= s_reg + 1;
                end if;
             end if;
       end case;
    end process;
    tx <= tx_reg;
end arch;