----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.04.2023 12:19:56
-- Design Name: 
-- Module Name: fifo - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo is
    generic(
        B: natural :=8; -- cislo bitu
        W: natural :=4  -- cislo adressy bitu
    );
    port(
 clk     :   in std_logic; -- hodinový signál
        reset   :   in std_logic; -- asynchronní reset  
        Rd      :   in std_logic; -- pro ètení dat 
        Wr      :   in std_logic; -- pro zápis dat  
        W_data  :   in std_logic_vector(B-1 downto 0);  -- pro zápis do fronty
        R_data  :   out std_logic_vector(B-1 downto 0); -- pro ètení dat
        empty   :   out std_logic; -- signál, který indikuje, zda je fronta prázdná
        full    :   out std_logic  -- signál, který indikuje, zda je fronta plná
    );
end fifo;

architecture Behavioral of fifo is
    -- Deklarace typu pole registrù, každý registr má délku B bitù
type reg_file_type is array (2**W-1 downto 0) of std_logic_vector(B-1 downto 0);

-- Deklarace signálù pro øízení fronty
signal array_reg      : reg_file_type;   -- Pole registrù
signal w_ptr_next     : std_logic_vector(W-1 downto 0);   -- Index zápisového ukazatele v následujícím cyklu
signal w_ptr_reg      : std_logic_vector(W-1 downto 0);   -- Aktuální index zápisového ukazatele
signal w_ptr_succ     : std_logic_vector(W-1 downto 0);   -- Index zápisového ukazatele v následujícím cyklu (v pøípadì, že se fronta plní)
signal r_ptr_next     : std_logic_vector(W-1 downto 0);   -- Index ètecího ukazatele v následujícím cyklu
signal r_ptr_reg      : std_logic_vector(W-1 downto 0);   -- Aktuální index ètecího ukazatele
signal r_ptr_succ     : std_logic_vector(W-1 downto 0);   -- Index ètecího ukazatele v následujícím cyklu (v pøípadì, že se fronta prázdní)
signal full_reg       : std_logic;    -- Indikátor plnosti fronty (hodnota 1 znaèí, že fronta je plná)
signal empty_reg      : std_logic;    -- Indikátor prázdnosti fronty (hodnota 1 znaèí, že fronta je prázdná)
signal full_next      : std_logic;    -- Indikátor plnosti fronty v následujícím cyklu
signal empty_next     : std_logic;    -- Indikátor prázdnosti fronty v následujícím cyklu
signal wr_op          : std_logic_vector(2-1 downto 0);    -- Operace zápisu do fronty (00 = zápis na zaèátek, 01 = zápis na konec, 10 = vymazání fronty)
signal wr_en          : std_logic;    -- Povolení zápisu do fronty

begin
   -- Process pro zápis do registrù v poli array_reg
process(clk, reset)
begin
    -- Pokud reset signál má hodnotu '1', nastaví se všechny registry v poli na hodnotu '0'
    if (reset = '1') then
        array_reg <= (others => (others => '0'));
    -- Jinak, pokud signál hodin clk má event a souèasnì má hodnotu '1', provede se zápis dat
    elsif (clk'event and clk = '1') then
        -- Pokud signál wr_en má hodnotu '1', provede se zápis dat do registru na indexu w_ptr_reg
        if wr_en = '1' then
            array_reg(to_integer(unsigned(w_ptr_reg))) <= w_data;
        end if;
    end if;
end process;

         
    process(clk,reset)
begin
    if (reset = '1') then -- Pokud je reset aktivní ('1'), provede se inicializace registrù
        w_ptr_reg <= (others => '0');  -- Nastavení ukazatele zápisové fronty na poèáteèní hodnotu (všechny bity na '0')
        r_ptr_reg <= (others => '0');  -- Nastavení ukazatele ètecí fronty na poèáteèní hodnotu (všechny bity na '0')
        full_reg <= '0';              -- Nastavení signálu indikujícího zaplnìní fronty na hodnotu '0' (fronta není zaplnìna)
        empty_reg <= '1';             -- Nastavení signálu indikujícího prázdnost fronty na hodnotu '1' (fronta je prázdná)
    elsif (clk'event and clk = '1') then -- Pokud se zmìní hodnota hodinového signálu (clk) z '0' na '1' (hodinový signál klesající hrana), provede se další krok procesoru
        w_ptr_reg <= w_ptr_next;       -- Pøesunutí ukazatele zápisové fronty na další pozici (podle signálu w_ptr_next)
        r_ptr_reg <= r_ptr_next;       -- Pøesunutí ukazatele ètecí fronty na další pozici (podle signálu r_ptr_next)
        full_reg <= full_next;         -- Nastavení signálu indikujícího zaplnìní fronty podle hodnoty signálu full_next
        empty_reg <= empty_next;       -- Nastavení signálu indikujícího prázdnost fronty podle hodnoty signálu empty_next
    end if;           
end process;

        
      
-- Nastavení ukazatelù pro pøístup ke frontì
w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg)+1); -- Nastavení ukazatele pro zápis do fronty (pøidání 1)
r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg)+1); -- Nastavení ukazatele pro ètení z fronty (pøidání 1)

-- Nastavení operace pro zápis/ètení do/z fronty
wr_op <= Wr & Rd; -- Slouèení vstupních signálù zápisu a ètení do jednoho signálu pro urèení operace

      
-- Proces pro aktualizaci ukazatelù
process(w_ptr_reg,w_ptr_succ,r_ptr_reg,r_ptr_succ,wr_op,empty_reg,full_reg)
begin
    w_ptr_next  <=w_ptr_reg;   -- pøednastavení hodnot pro pøípad, že se ukazatele neaktualizují
    r_ptr_next  <=r_ptr_reg;
    full_next   <=full_reg;
    empty_next  <= empty_reg;
    case wr_op is
        when "00"    =>        -- operace bez zápisu ani ètení, žádné aktualizace
        when "01"    =>        -- operace pro ètení dat z fronty
            if (empty_reg /= '1') then     -- pokud není fronta prázdná
                r_ptr_next  <= r_ptr_succ;     -- aktualizace ukazatele pro ètení
                full_next   <= '0';       -- fronta není plná
                if (r_ptr_succ=w_ptr_reg) then   -- pokud se ukazatele pro ètení a zápis shodují
                    empty_next <='1';   -- fronta bude prázdná
                end if;    
            end if;
        when "10" =>        -- operace pro zápis dat do fronty
            if (full_reg /= '1') then        -- pokud není fronta plná
                w_ptr_next <= w_ptr_succ;    -- aktualizace ukazatele pro zápis
                empty_next <= '0';       -- fronta není prázdná
                if(w_ptr_succ=r_ptr_reg) then    -- pokud se ukazatele pro zápis a ètení shodují
                    full_next <='1';        -- fronta je plná
                end if;
            end if;  
        when others =>       -- ostatní operace (mìly by být zakázané)
            w_ptr_next <= w_ptr_succ;    -- pøiøazení hodnoty pro ukazatel zápisu
            r_ptr_next <= r_ptr_succ;    -- pøiøazení hodnoty pro ukazatel ètení
    end case;
end process;   

full <= full_reg;   -- pøiøazení hodnoty pro výstup signálu full
empty <= empty_reg; -- pøiøazení hodnoty pro výstup signálu empty

end Behavioral;

