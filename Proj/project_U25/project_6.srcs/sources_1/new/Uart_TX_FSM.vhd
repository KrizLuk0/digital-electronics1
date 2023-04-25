library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Uart_TX_FSM is
		 Port ( 
		   clk           : in STD_LOGIC;        -- vstupn� hodiny
           reset         : in STD_LOGIC;        -- vstupn� reset
           s_tick        : in STD_LOGIC;        -- vstupn� hodiny pro sb�rnici
           din           : in STD_LOGIC_VECTOR (7 downto 0); -- vstupn� data
           tx_start      : in STD_LOGIC;        -- spu�t�n� vys�l�n�
           tx            : out STD_LOGIC;       -- v�stupn� vys�lac� sign�l
           tx_done_tick  : out STD_LOGIC      -- sign�l pro indikaci dokon�en� vys�l�n�
	);
end entity Uart_TX_FSM;

architecture rtl of Uart_TX_FSM is


	type state_type is (ready,read_FIFO, start, data, stop);  -- typ pro stavy kone�n�ho automatu
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
	-- Present and Next state signals
	signal pres_state	: state_type;
	signal next_state : state_type;
begin	
	-- Processes
		-- Next state transfer
		process (clk, reset)
		begin
			if (reset = '1') then
            pres_state <= tx_done_tick;
         elsif (clk'event and clk='1')) then
				pres_state <= next_state;
			end if;
		end process;
		
		-- Logic to advance to the next state
		process (pres_state, start_i, counter_done_i)
		begin
			case pres_state is
			-- State Ready to transmit
				when ready =>
					if start_i = '1' then
						next_state <= sck_en;
					else
						next_state <= ready;
					end if;
               
         -- State SCK enable
            when start =>
               next_state <= cs_down;
						
			-- State Chip Select down
				when cs_down =>
					next_state <= zero;
               
			-- State Zero bit
				when zero =>
					next_state <= range_set;
               
         -- State Range set
            when range_set =>
               next_state <= a0_channel;
               
         -- State A0 bit (ADC channel)
            when a0_channel =>
               next_state <= a_b_adc;
               
         -- State ADC 
            when a_b_adc =>
               next_state <= data_bit;
					
			-- State Data bits
				when data_bit =>
               if counter_done_i = '1' then
                  next_state <= cs_up;
               else
                  next_state <= data_bit;
               end if;
               
         -- State Chip Select up
            when cs_up =>
               next_state <= sck_dis;
               
         -- State SCK disable
            when sck_dis =>
               next_state <= rx_done;
               
         -- State Receive done
            when rx_done =>
               next_state <= ready;
			
			-- When undefined state occurs
				when others =>
					next_state <= ready;

			end case;
		end process;
		
		-- Output depends on the current state and input signals
		process (pres_state)
		begin
			case pres_state is
			-- State Ready
				when ready =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '0';
               spi_csn_en_s   <= '1';
               adc_range_s    <= '1';
               ready_s        <= '1';
               
          -- State SCK enable
            when sck_en =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '1';
               adc_range_s    <= '1';
               ready_s        <= '0';
						
			-- State Chip Select down
				when cs_down =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '1';
               adc_range_s    <= '1';
               ready_s        <= '0';
               
			-- State Zero bit
				when zero =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '0';
               adc_range_s    <= '1';
               ready_s        <= '0';
					
			-- State Range set
				when range_set =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '0';
               adc_range_s    <= '0';
               ready_s        <= '0';
               
         -- State A0 bit (ADC channel)
            when a0_channel =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '0';
               adc_range_s    <= '0';
               ready_s        <= '0';
               
         -- State ADC
            when a_b_adc =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '0';
               adc_range_s    <= '0';
               ready_s        <= '0';
               
         -- State Data bits
				when data_bit =>
               counter_run_s  <= '1';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '0';
               adc_range_s    <= '0';
               ready_s        <= '0';
               
         -- State Chip Select up
				when cs_up =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '1';
               spi_csn_en_s   <= '1';
               adc_range_s    <= '0';
               ready_s        <= '0';
               
         -- State SCK disable
            when sck_dis =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '0';
               spi_csn_en_s   <= '1';
               adc_range_s    <= '0';
               ready_s        <= '0';
               
         -- State Receive done
            when rx_done =>
               counter_run_s  <= '0';
               spi_done_s     <= '1';
               spi_clk_en_s   <= '0';
               spi_csn_en_s   <= '1';
               adc_range_s    <= '0';
               ready_s        <= '0';
			
			-- When undefined state occurs
				when others =>
               counter_run_s  <= '0';
               spi_done_s     <= '0';
               spi_clk_en_s   <= '0';
               spi_csn_en_s   <= '1';
               adc_range_s    <= '1';
               ready_s        <= '0';
               
			end case;
		end process;

end architecture;
