library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           rx : in STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR(7 downto 0);
           rx_done : out STD_LOGIC);
end uart_rx;

architecture Behavioral of uart_rx is

    type state_type is (idle, start_bit, data_bits, stop_bit);
    signal current_state : state_type;
    signal bit_counter : integer range 0 to 7 := 0;
    signal data_reg : std_logic_vector(7 downto 0);
    signal next_state : state_type;
    
begin

    process(clk, reset, rx)
    begin
        if reset = '1' then
            current_state <= idle;
            bit_counter <= 0;
            data_reg <= (others => '0');
            rx_done <= '0';
        elsif rising_edge(clk) then
            current_state <= next_state;
            
            case current_state is
                when idle =>
                    if rx = '0' then
                        next_state <= start_bit;
                        bit_counter <= 0;
                    else
                        next_state <= idle;
                    end if;
                when start_bit =>
                    if bit_counter < 7 then
                        bit_counter <= bit_counter + 1;
                        data_reg(bit_counter) <= rx;
                        next_state <= data_bits;
                    else
                        bit_counter <= 0;
                        next_state <= stop_bit;
                    end if;
                when data_bits =>
                    if bit_counter < 7 then
                        bit_counter <= bit_counter + 1;
                        data_reg(bit_counter) <= rx;
                    else
                        bit_counter <= 0;
                        next_state <= stop_bit;
                    end if;
                when stop_bit =>
                    if rx = '1' then
                        data_out <= data_reg;
                        rx_done <= '1';
                        next_state <= idle;
                    else
                        next_state <= start_bit;
                    end if;
            end case;
        end if;
    end process;

end Behavioral;
