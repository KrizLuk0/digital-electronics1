# Lab 5: Lukas Kriz

### D & T Flip-flops

1. Screenshot with simulated time waveforms. Try to simulate both D- and T-type flip-flops in a single testbench with a maximum duration of 200 ns, including reset. Always display all inputs and outputs (display the inputs at the top of the image, the outputs below them) at the appropriate time scale!

   ![your figure](images/sim1.png)

### JK Flip-flop

1. Listing of VHDL architecture for JK-type flip-flop. Always use syntax highlighting, meaningful comments, and follow VHDL guidelines:

```vhdl
architecture Behavioral of jfk_ff_rst is
    signal sig_q : std_logic;
begin
 p_jfk_ff_rst : process (clk)
    begin
        if rising_edge(clk) then  -- Synchronous process
            if(rst='1') then
                sig_q<='0';
            elsif(J='0' AND K='0') then
                sig_q <= sig_q;
             elsif(J='1' AND K='1') then
                sig_q<= not sig_q;
             elsif(J='1' AND K='0') then
                sig_q <='0';
             else
                sig_q <='1'; 
             end if;                 
        end if;
        q<=sig_q;
        q_bar<=not sig_q;
    end process p_jfk_ff_rst;

end Behavioral;
```

### Shift register

1. Image of `top` level schematic of the 4-bit shift register. Use four D-type flip-flops and connect them properly. The image can be drawn on a computer or by hand. Always name all inputs, outputs, components and internal signals!

   ![your figure](images/sim2.png)