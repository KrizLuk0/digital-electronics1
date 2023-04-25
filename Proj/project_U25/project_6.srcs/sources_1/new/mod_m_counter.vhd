-- Knihovny standardu IEEE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Deklarace entity
entity mod_m_counter is
    generic (
        N:  integer     :=4; -- parametr urèující šíøku èítaèe
        M:  integer     :=10 -- parametr urèující maximální hodnotu èítaèe
    );
    port(
        clk         :   in std_logic; -- vstupní hodiny
        reset       :   in std_logic; -- asynchronní resetovací vstup
        max_tick    :   out std_logic; -- výstup indikující dosažení maximální hodnoty èítaèe
        q           :   out std_logic_vector(N-1 downto 0) -- výstupní hodnota èítaèe
    );
end mod_m_counter;

-- Implementace
architecture arch of mod_m_counter is
    signal  r_reg   :   unsigned(N-1 downto 0); -- registr uchovávající aktuální hodnotu èítaèe
    signal  r_next  :   unsigned(N-1 downto 0); -- hodnota èítaèe pro další cyklus
begin
    process(clk,reset)
        begin
            if (reset='1') then -- pokud je aktivní resetovací signál
                r_reg <= (others => '0'); -- vynuluj hodnotu èítaèe
            elsif (clk'event and clk ='1') then -- jinak, pokud došlo ke sestupné hranì hodin
                r_reg <= r_next; -- hodnotu èítaèe nastav na hodnotu pro další cyklus
            end if;
end process; 

r_next <= (others => '0') when r_reg= (M-1) else r_reg +1; -- pokud je dosažena maximální hodnota, nastav hodnotu pro další cyklus na nulu, jinak pøièti 1
q <= std_logic_vector(r_reg); -- pøeveï hodnotu èítaèe z unsigned na std_logic_vector
max_tick <='1' when r_reg=(M-1) else '0'; -- pokud je dosažena maximální hodnota, aktivuj výstupní signál, jinak ho deaktivuj

end arch;
