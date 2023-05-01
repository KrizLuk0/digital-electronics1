# VHDL project

### UART (Universal Asynchronous Receiver/Transmitter)

### Team members

* Lukas Kriz
* Michal Kovar
* Jakub Krivanek

## Theoretical description and explanation

UART stands for Universal Asynchronous Receiver/Transmitter, and it is a commonly used communication protocol for transmitting and receiving serial data between electronic devices. It is widely used in embedded systems, such as microcontrollers, and other electronic devices. UARTconsists of two lines: one for transmitting data, called TX, and the other for receiving data, called RX. The TX line is driven by the transmitter, while the RX line is monitored by the receiver. 

## Hardware description of demo application
Block diagram of UART designed in VHDL:

![uart_schema](https://user-images.githubusercontent.com/124684744/235447990-62608f3f-8d7b-46f5-b637-c452ca2f4952.png)


Insert descriptive text and schematic(s) of your implementation.

There is nothing here because after implementing it on the board, it doesn't work.

## Software description

#### Transmitter:
 The "clk" and "reset" inputs are used for clocking and resetting the module, respectively. "tx_start" input is used to initiate the transmission of data, and "data_in" is the 8-bit data input to be transmitted. "tx" output is the serial data output, and "tx_done" output signals when the data transmission is complete. The module has two processes: "baud_clk_process" and "tx_reg_process". The "baud_clk_process" process generates a baud clock signal, which is used to synchronize the transmission of each bit. The "tx_reg_process" process shifts the data bits to be transmitted into a shift register, which is then transmitted serially using the baud clock signal. When "tx_start" input is high, the process starts shifting the data bits into the shift register. The process continues shifting the bits until all 10 bits (start bit, 8 data bits, and stop bit) have been transmitted. Once transmission is complete, the "tx_done" output signal is set high. The "tx_process" process outputs the serial data based on the value of the shift register. When "tx_start" input is high and "tx_busy" is low, the process sets the shift register to all zeroes and sets "tx_busy" to high to signal that data transmission has started. The process then outputs the start bit followed by the 8 data bits and stop bit in sequence based on the value of the shift register.

#### Reciever:
The module has an input clock signal ("clk"), a synchronous reset signal ("reset"), and a single-ended input signal ("rx") that carries the serial data stream. The module has two output signals: "data_out" is an 8-bit wide output signal that carries the received byte when the whole byte is received, and "rx_done" is a flag signal that is set to 1 when the byte is received. The state machine of the receiver has four states: "idle", "start_bit", "data_bits", and "stop_bit". The state machine starts in the "idle" state, waits for the "start bit", receives 8 data bits, and then receives a stop bit. When the stop bit is received, the received byte is stored in the "data_out" register, and the "rx_done" flag is set. The "bit_counter" signal is used to count the received bits. When the state machine is in the "start_bit" state, the "bit_counter" is incremented until it reaches 7, which means that all 8 bits have been received. The received bits are stored in the "data_reg". If the stop bit is received, the received byte is stored in the "data_out" register, and the "rx_done" flag is set to 1register.

### Component(s) simulation

Screenshot of our UART :

![uart_tb1](https://user-images.githubusercontent.com/124684744/235448080-d529142f-33d2-4819-acda-e9c990656aa9.png)

## Instructions

### Transmitter:
1. It is necessary to connect the transmitter's GND to the GND pin and connect tx to JA 2.
2. Use the first eight switches from the right-hand side to set the desired binary combination. 
The combination should be displayed on the first two seven-segment displays from the right-hand side.
3. Wait for the process to complete
4. When reset is needed, press the middle button.

### Reciever:
1. It is necessary to connect the reciver's GND to the GND pin and connect rx to JA 1.
2. Wait for the process to complete
3. After receiving data, the received eight-bit combination should be displayed on the 3rd and 4th seven-segment displays from the right-hand side.
4. Reset is on the central button.

## References
1. MANO, M. Morris a Michael D. CILETTI. Digital design: with an introduction to the Verilog HDL, VHDL, and SystemVerilog. Sixth edition
2. ![https://github.com/tomas-fryza/digital-electronics-1] (https://github.com/tomas-fryza/digital-electronics-1)