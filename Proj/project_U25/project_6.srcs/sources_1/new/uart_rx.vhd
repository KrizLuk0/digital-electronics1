library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity uart_rx is  
    generic(
        DBIT: integer:=8;  -- Nastaven� ���ky datov�ho slova
        SB_TICK : integer:=16  -- Nastaven� d�lky symbolu v po�tech hodinov�ch tik�
    );
    port(
        clk, reset : in std_logic;  -- Hlavn� hodinov� sign�l a sign�l resetu
        rx: in std_logic;  -- Sign�l pro p��jem dat
        s_tick: in std_logic;  -- Sign�l pro ur�en� d�lky symbolu
        rx_done_tick: out std_logic;  -- Sign�l pro indikaci dokon�en� p��jmu
        dout: out std_logic_vector (7 downto 0)  -- V�stupn� datov� sb�rnice
    );
end uart_rx ;

architecture arch of uart_rx is
-- Definice v��tu stav� automatu
type state_type is (idle, start, data, stop);

-- Registr stavu a jeho n�sledovn�k pro dal�� cyklus
signal state_reg, state_next: state_type;

-- Registr pro ukl�d�n� aktu�ln�ho stavu ��ta�e
signal s_reg, s_next: unsigned(3 downto 0);

-- Registr pro ukl�d�n� aktu�ln�ho stavu bitu v r�mci bajtu
signal n_reg, n_next: unsigned(2 downto 0);

-- Registr pro ukl�d�n� p�ijat�ho bajtu
signal b_reg, b_next: std_logic_vector(7 downto 0);

begin
-- Process pro synchronizaci stavu a registru
process(clk, reset)
begin
    -- Pokud je reset v aktivn�m stavu, nastav� se v�echny registry na hodnotu nula
    if reset='1' then
       state_reg <= idle;
       s_reg <= (others=>'0');
       n_reg <= (others=>'0');
       b_reg <= (others=>'0');
    -- Pokud nastane hrana hodinov�ho sign�lu, p�enese se hodnota stavu a registr� do n�sleduj�c�ho kroku
    elsif (clk'event and clk='1') then
       state_reg <= state_next;
       s_reg <= s_next;
       n_reg <= n_next;
       b_reg <= b_next;
    end if;
 end process;

     -- next-state logic & data path funcional units/routing
process (state_reg, s_reg, n_reg, b_reg, s_tick, rx)
begin
  state_next <= state_reg; -- p�ednastaven� nov�ho stavu na aktu�ln�
  s_next <= s_reg; -- p�ednastaven� nov� hodnoty ��d�c�ho sign�lu s na aktu�ln�
  n_next <= n_reg; -- p�ednastaven� nov� hodnoty ��d�c�ho sign�lu n na aktu�ln�
  b_next <= b_reg; -- p�ednastaven� nov�ho v�stupn�ho sign�lu b na aktu�ln�
  rx_done_tick <= '0'; -- p�ednastaven� indik�toru ukon�en� p��jmu na '0'
  
  case state_reg is -- zah�jen� procesu p��jmu v z�vislosti na aktu�ln�m stavu
    when idle => -- stav "bez p��jmu dat"
      if rx = '0' then -- pokud je detekov�n start bit
        state_next <= start; -- p�epnut� na stav "�ten� start bitu"
        s_next <= (others => '0'); -- vynulov�n� ��d�c�ho sign�lu s
      end if;
      
    when start => -- stav "�ten� start bitu"
      if s_tick = '1' then -- pokud uplynula �asov� prodleva pro dal�� bit
        if s_reg = 7 then -- pokud byl na�ten start bit
          state_next <= data; -- p�epnut� na stav "�ten� datov�ch bit�"
          s_next <= (others => '0'); -- vynulov�n� ��d�c�ho sign�lu s
          n_next <= (others => '0'); -- vynulov�n� ��d�c�ho sign�lu n
        else
          s_next <= s_reg + 1; -- p�echod na dal�� bit start bitu
        end if;
      end if;
      
    when data => -- stav "�ten� datov�ch bit�"
      if s_tick = '1' then -- pokud uplynula �asov� prodleva pro dal�� bit
        if s_reg = 15 then -- pokud byly na�teny v�echny datov� bity
          s_next <= (others => '0'); -- vynulov�n� ��d�c�ho sign�lu s
          b_next <= rx & b_reg(7 downto 1); -- ulo�en� nov�ho datov�ho bytu
          if n_reg = (DBIT-1) then -- pokud byly p�ijaty v�echny datov� byty
            state_next <= stop ; -- p�epnut� na stav "�ten� stop bitu"
          else 
            n_next <= n_reg + 1; -- p�echod na dal�� datov� byte
          end if;
        else
          s_next <= s_reg + 1; -- p�echod na dal�� datov� bit
        end if;
      end if;
      
when stop => -- stav "�ten� stop bitu"
      if s_tick = '1' then -- pokud up tady jsi skoncil, tak prokracuj
         if s_reg=(SB_TICK-1) then -- pokud jsou sb_tick d�vno hotovy
            state_next <= idle; -- jdi do stavu "idle"
            rx_done_tick <='1'; -- a nastav flag, �e p�ij�mac� operace je hotov�
         else -- jinak
            s_next <= s_reg + 1; -- posu� se na dal�� hodnotu
         end if;
      end if;

      end case;
   end process;
   dout <= b_reg;
end arch;