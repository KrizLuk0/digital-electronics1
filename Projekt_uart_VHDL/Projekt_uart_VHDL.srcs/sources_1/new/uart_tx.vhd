library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Generic (BAUD_RATE : INTEGER := 9600; -- default baud rate of 115200
             CLK_FREQ : INTEGER := 10_000_000); -- default clock frequency of 50 MHz
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           tx : out STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR(7 downto 0);
           tx_start : in STD_LOGIC;
           tx_done : out STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is

    constant BIT_PERIOD : time := 1 sec / BAUD_RATE; -- period of a single bit at the specified baud rate
    constant HALF_BIT_PERIOD : time := BIT_PERIOD / 2; -- half the period of a single bit

    signal baud_clk : std_logic := '0'; -- baud clock signal used for bit timing
    signal bit_count : integer range 0 to 10 := 0; -- current bit being transmitted
    signal tx_reg : std_logic_vector(9 downto 0) := (others => '1'); -- shift register used for transmitting data
    signal tx_busy : std_logic := '0'; -- busy flag indicating that a transmission is in progress

begin

    -- baud clock generator
    baud_clk_process: process (clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                baud_clk <= '0';
            else
                baud_clk <= not baud_clk;
            end if;
        end if;
    end process;

    -- shift register
    tx_reg_process: process (baud_clk)
    begin
        if rising_edge(baud_clk) then
            if tx_busy = '1' then
                if bit_count < 10 then
                    tx_reg <= std_logic_vector(unsigned(tx_reg) srl 1) & data_in(bit_count);
                    bit_count <= bit_count + 1;
                else
                    tx_reg <= (others => '1');
                    tx_busy <= '0';
                    bit_count <= 0;
                    tx_done <= '1';
                end if;
            end if;
        end if;
    end process;

    -- transmitter
    tx_process: process (tx_start, tx_busy)
    begin
        if tx_start = '1' and tx_busy = '0' then
            tx_reg <= (others => '0');
            tx_busy <= '1';
            tx_done <= '0';
        end if;

        if tx_busy = '1' then
            if bit_count = 0 then
                tx <= '0'; -- start bit
            else
                tx <= tx_reg(0);
            end if;
        else
            tx <= '1';
        end if;
    end process;

end Behavioral;
