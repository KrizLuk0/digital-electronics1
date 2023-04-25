-- Knihovny standardu IEEE
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Deklarace entity
entity mod_m_counter is
    generic (
        N:  integer     :=4; -- parametr ur�uj�c� ���ku ��ta�e
        M:  integer     :=10 -- parametr ur�uj�c� maxim�ln� hodnotu ��ta�e
    );
    port(
        clk         :   in std_logic; -- vstupn� hodiny
        reset       :   in std_logic; -- asynchronn� resetovac� vstup
        max_tick    :   out std_logic; -- v�stup indikuj�c� dosa�en� maxim�ln� hodnoty ��ta�e
        q           :   out std_logic_vector(N-1 downto 0) -- v�stupn� hodnota ��ta�e
    );
end mod_m_counter;

-- Implementace
architecture arch of mod_m_counter is
    signal  r_reg   :   unsigned(N-1 downto 0); -- registr uchov�vaj�c� aktu�ln� hodnotu ��ta�e
    signal  r_next  :   unsigned(N-1 downto 0); -- hodnota ��ta�e pro dal�� cyklus
begin
    process(clk,reset)
        begin
            if (reset='1') then -- pokud je aktivn� resetovac� sign�l
                r_reg <= (others => '0'); -- vynuluj hodnotu ��ta�e
            elsif (clk'event and clk ='1') then -- jinak, pokud do�lo ke sestupn� hran� hodin
                r_reg <= r_next; -- hodnotu ��ta�e nastav na hodnotu pro dal�� cyklus
            end if;
end process; 

r_next <= (others => '0') when r_reg= (M-1) else r_reg +1; -- pokud je dosa�ena maxim�ln� hodnota, nastav hodnotu pro dal�� cyklus na nulu, jinak p�i�ti 1
q <= std_logic_vector(r_reg); -- p�eve� hodnotu ��ta�e z unsigned na std_logic_vector
max_tick <='1' when r_reg=(M-1) else '0'; -- pokud je dosa�ena maxim�ln� hodnota, aktivuj v�stupn� sign�l, jinak ho deaktivuj

end arch;
