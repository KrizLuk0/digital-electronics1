library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity uart_rx is  
    generic(
        DBIT: integer:=8;  -- Nastavení šíøky datového slova
        SB_TICK : integer:=16  -- Nastavení délky symbolu v poètech hodinových tikù
    );
    port(
        clk, reset : in std_logic;  -- Hlavní hodinový signál a signál resetu
        rx: in std_logic;  -- Signál pro pøíjem dat
        s_tick: in std_logic;  -- Signál pro urèení délky symbolu
        rx_done_tick: out std_logic;  -- Signál pro indikaci dokonèení pøíjmu
        dout: out std_logic_vector (7 downto 0)  -- Výstupní datová sbìrnice
    );
end uart_rx ;

architecture arch of uart_rx is
-- Definice výètu stavù automatu
type state_type is (idle, start, data, stop);

-- Registr stavu a jeho následovník pro další cyklus
signal state_reg, state_next: state_type;

-- Registr pro ukládání aktuálního stavu èítaèe
signal s_reg, s_next: unsigned(3 downto 0);

-- Registr pro ukládání aktuálního stavu bitu v rámci bajtu
signal n_reg, n_next: unsigned(2 downto 0);

-- Registr pro ukládání pøijatého bajtu
signal b_reg, b_next: std_logic_vector(7 downto 0);

begin
-- Process pro synchronizaci stavu a registru
process(clk, reset)
begin
    -- Pokud je reset v aktivním stavu, nastaví se všechny registry na hodnotu nula
    if reset='1' then
       state_reg <= idle;
       s_reg <= (others=>'0');
       n_reg <= (others=>'0');
       b_reg <= (others=>'0');
    -- Pokud nastane hrana hodinového signálu, pøenese se hodnota stavu a registrù do následujícího kroku
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
  state_next <= state_reg; -- pøednastavení nového stavu na aktuální
  s_next <= s_reg; -- pøednastavení nové hodnoty øídícího signálu s na aktuální
  n_next <= n_reg; -- pøednastavení nové hodnoty øídícího signálu n na aktuální
  b_next <= b_reg; -- pøednastavení nového výstupního signálu b na aktuální
  rx_done_tick <= '0'; -- pøednastavení indikátoru ukonèení pøíjmu na '0'
  
  case state_reg is -- zahájení procesu pøíjmu v závislosti na aktuálním stavu
    when idle => -- stav "bez pøíjmu dat"
      if rx = '0' then -- pokud je detekován start bit
        state_next <= start; -- pøepnutí na stav "ètení start bitu"
        s_next <= (others => '0'); -- vynulování øídícího signálu s
      end if;
      
    when start => -- stav "ètení start bitu"
      if s_tick = '1' then -- pokud uplynula èasová prodleva pro další bit
        if s_reg = 7 then -- pokud byl naèten start bit
          state_next <= data; -- pøepnutí na stav "ètení datových bitù"
          s_next <= (others => '0'); -- vynulování øídícího signálu s
          n_next <= (others => '0'); -- vynulování øídícího signálu n
        else
          s_next <= s_reg + 1; -- pøechod na další bit start bitu
        end if;
      end if;
      
    when data => -- stav "ètení datových bitù"
      if s_tick = '1' then -- pokud uplynula èasová prodleva pro další bit
        if s_reg = 15 then -- pokud byly naèteny všechny datové bity
          s_next <= (others => '0'); -- vynulování øídícího signálu s
          b_next <= rx & b_reg(7 downto 1); -- uložení nového datového bytu
          if n_reg = (DBIT-1) then -- pokud byly pøijaty všechny datové byty
            state_next <= stop ; -- pøepnutí na stav "ètení stop bitu"
          else 
            n_next <= n_reg + 1; -- pøechod na další datový byte
          end if;
        else
          s_next <= s_reg + 1; -- pøechod na další datový bit
        end if;
      end if;
      
when stop => -- stav "ètení stop bitu"
      if s_tick = '1' then -- pokud up tady jsi skoncil, tak prokracuj
         if s_reg=(SB_TICK-1) then -- pokud jsou sb_tick dávno hotovy
            state_next <= idle; -- jdi do stavu "idle"
            rx_done_tick <='1'; -- a nastav flag, že pøijímací operace je hotová
         else -- jinak
            s_next <= s_reg + 1; -- posuò se na další hodnotu
         end if;
      end if;

      end case;
   end process;
   dout <= b_reg;
end arch;