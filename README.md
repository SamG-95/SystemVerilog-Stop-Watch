# Stop Watch

## Specifications

* Module name: `stop_watch`

* Module Inputs:
  - `logic clk` 
  - `logic nRst_i`
  - `logic button_i`

* Module Ouputs:
  - `logic [2:0] mode_o`
  - `logic [4:0] time_o`


The clock provided to your module will be a `100 Hz` clock. 

The nRst_i signal is an active low asynchronous reset to all the FFs in your design. 

The mode_o output needs to be 3'b100 when the state of the stop watch is IDLE, 3'b010 when the state is CLEAR, and 3'b001 when the state is RUNNING. 

The time_o output needs to count from 0 (5'b00000) to 31 (5'b11111) and wrap up around back to 0. 

Button inputs need to be passed through a synchronizer of depth 2, and an edge detector.

## Behavior

Each button press should change the state of the stop watch from IDLE to CLEAR to RUNNING, and back to IDLE again. 


- When the state of the stop watch is IDLE the time_o value should not change.

- When the state of the stop watch is CLEAR the time_o value should be cleared to 0. 

- When the state of the stop watch is RUNNING, the time_o value should increment by every second and wrap around to the value 0.


The final output should be something like this when the stop watch is running:

<img src="./imgs/fpga_implementation.jpg" alt="fpga implementation" height=300>
