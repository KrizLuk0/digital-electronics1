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
 clk     :   in std_logic; -- hodinov� sign�l
        reset   :   in std_logic; -- asynchronn� reset  
        Rd      :   in std_logic; -- pro �ten� dat 
        Wr      :   in std_logic; -- pro z�pis dat  
        W_data  :   in std_logic_vector(B-1 downto 0);  -- pro z�pis do fronty
        R_data  :   out std_logic_vector(B-1 downto 0); -- pro �ten� dat
        empty   :   out std_logic; -- sign�l, kter� indikuje, zda je fronta pr�zdn�
        full    :   out std_logic  -- sign�l, kter� indikuje, zda je fronta pln�
    );
end fifo;

architecture Behavioral of fifo is
    -- Deklarace typu pole registr�, ka�d� registr m� d�lku B bit�
type reg_file_type is array (2**W-1 downto 0) of std_logic_vector(B-1 downto 0);

-- Deklarace sign�l� pro ��zen� fronty
signal array_reg      : reg_file_type;   -- Pole registr�
signal w_ptr_next     : std_logic_vector(W-1 downto 0);   -- Index z�pisov�ho ukazatele v n�sleduj�c�m cyklu
signal w_ptr_reg      : std_logic_vector(W-1 downto 0);   -- Aktu�ln� index z�pisov�ho ukazatele
signal w_ptr_succ     : std_logic_vector(W-1 downto 0);   -- Index z�pisov�ho ukazatele v n�sleduj�c�m cyklu (v p��pad�, �e se fronta pln�)
signal r_ptr_next     : std_logic_vector(W-1 downto 0);   -- Index �tec�ho ukazatele v n�sleduj�c�m cyklu
signal r_ptr_reg      : std_logic_vector(W-1 downto 0);   -- Aktu�ln� index �tec�ho ukazatele
signal r_ptr_succ     : std_logic_vector(W-1 downto 0);   -- Index �tec�ho ukazatele v n�sleduj�c�m cyklu (v p��pad�, �e se fronta pr�zdn�)
signal full_reg       : std_logic;    -- Indik�tor plnosti fronty (hodnota 1 zna��, �e fronta je pln�)
signal empty_reg      : std_logic;    -- Indik�tor pr�zdnosti fronty (hodnota 1 zna��, �e fronta je pr�zdn�)
signal full_next      : std_logic;    -- Indik�tor plnosti fronty v n�sleduj�c�m cyklu
signal empty_next     : std_logic;    -- Indik�tor pr�zdnosti fronty v n�sleduj�c�m cyklu
signal wr_op          : std_logic_vector(2-1 downto 0);    -- Operace z�pisu do fronty (00 = z�pis na za��tek, 01 = z�pis na konec, 10 = vymaz�n� fronty)
signal wr_en          : std_logic;    -- Povolen� z�pisu do fronty

begin
   -- Process pro z�pis do registr� v poli array_reg
process(clk, reset)
begin
    -- Pokud reset sign�l m� hodnotu '1', nastav� se v�echny registry v poli na hodnotu '0'
    if (reset = '1') then
        array_reg <= (others => (others => '0'));
    -- Jinak, pokud sign�l hodin clk m� event a sou�asn� m� hodnotu '1', provede se z�pis dat
    elsif (clk'event and clk = '1') then
        -- Pokud sign�l wr_en m� hodnotu '1', provede se z�pis dat do registru na indexu w_ptr_reg
        if wr_en = '1' then
            array_reg(to_integer(unsigned(w_ptr_reg))) <= w_data;
        end if;
    end if;
end process;

         
    process(clk,reset)
begin
    if (reset = '1') then -- Pokud je reset aktivn� ('1'), provede se inicializace registr�
        w_ptr_reg <= (others => '0');  -- Nastaven� ukazatele z�pisov� fronty na po��te�n� hodnotu (v�echny bity na '0')
        r_ptr_reg <= (others => '0');  -- Nastaven� ukazatele �tec� fronty na po��te�n� hodnotu (v�echny bity na '0')
        full_reg <= '0';              -- Nastaven� sign�lu indikuj�c�ho zapln�n� fronty na hodnotu '0' (fronta nen� zapln�na)
        empty_reg <= '1';             -- Nastaven� sign�lu indikuj�c�ho pr�zdnost fronty na hodnotu '1' (fronta je pr�zdn�)
    elsif (clk'event and clk = '1') then -- Pokud se zm�n� hodnota hodinov�ho sign�lu (clk) z '0' na '1' (hodinov� sign�l klesaj�c� hrana), provede se dal�� krok procesoru
        w_ptr_reg <= w_ptr_next;       -- P�esunut� ukazatele z�pisov� fronty na dal�� pozici (podle sign�lu w_ptr_next)
        r_ptr_reg <= r_ptr_next;       -- P�esunut� ukazatele �tec� fronty na dal�� pozici (podle sign�lu r_ptr_next)
        full_reg <= full_next;         -- Nastaven� sign�lu indikuj�c�ho zapln�n� fronty podle hodnoty sign�lu full_next
        empty_reg <= empty_next;       -- Nastaven� sign�lu indikuj�c�ho pr�zdnost fronty podle hodnoty sign�lu empty_next
    end if;           
end process;

        
      
-- Nastaven� ukazatel� pro p��stup ke front�
w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg)+1); -- Nastaven� ukazatele pro z�pis do fronty (p�id�n� 1)
r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg)+1); -- Nastaven� ukazatele pro �ten� z fronty (p�id�n� 1)

-- Nastaven� operace pro z�pis/�ten� do/z fronty
wr_op <= Wr & Rd; -- Slou�en� vstupn�ch sign�l� z�pisu a �ten� do jednoho sign�lu pro ur�en� operace

      
-- Proces pro aktualizaci ukazatel�
process(w_ptr_reg,w_ptr_succ,r_ptr_reg,r_ptr_succ,wr_op,empty_reg,full_reg)
begin
    w_ptr_next  <=w_ptr_reg;   -- p�ednastaven� hodnot pro p��pad, �e se ukazatele neaktualizuj�
    r_ptr_next  <=r_ptr_reg;
    full_next   <=full_reg;
    empty_next  <= empty_reg;
    case wr_op is
        when "00"    =>        -- operace bez z�pisu ani �ten�, ��dn� aktualizace
        when "01"    =>        -- operace pro �ten� dat z fronty
            if (empty_reg /= '1') then     -- pokud nen� fronta pr�zdn�
                r_ptr_next  <= r_ptr_succ;     -- aktualizace ukazatele pro �ten�
                full_next   <= '0';       -- fronta nen� pln�
                if (r_ptr_succ=w_ptr_reg) then   -- pokud se ukazatele pro �ten� a z�pis shoduj�
                    empty_next <='1';   -- fronta bude pr�zdn�
                end if;    
            end if;
        when "10" =>        -- operace pro z�pis dat do fronty
            if (full_reg /= '1') then        -- pokud nen� fronta pln�
                w_ptr_next <= w_ptr_succ;    -- aktualizace ukazatele pro z�pis
                empty_next <= '0';       -- fronta nen� pr�zdn�
                if(w_ptr_succ=r_ptr_reg) then    -- pokud se ukazatele pro z�pis a �ten� shoduj�
                    full_next <='1';        -- fronta je pln�
                end if;
            end if;  
        when others =>       -- ostatn� operace (m�ly by b�t zak�zan�)
            w_ptr_next <= w_ptr_succ;    -- p�i�azen� hodnoty pro ukazatel z�pisu
            r_ptr_next <= r_ptr_succ;    -- p�i�azen� hodnoty pro ukazatel �ten�
    end case;
end process;   

full <= full_reg;   -- p�i�azen� hodnoty pro v�stup sign�lu full
empty <= empty_reg; -- p�i�azen� hodnoty pro v�stup sign�lu empty

end Behavioral;

