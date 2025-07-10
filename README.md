# A_clk_divider_project# Basys3 Clock Divider & LED Blinker

A complete FPGA project for the Digilent Basys3 board that:

- Generates two derived clocks (25 MHz & 100 kHz) from the on-board 100 MHz oscillator  
- Debounces and synchronizes a push-button reset  
- Drives an LED at selectable blink rates (2 Hz, 1 Hz, 0.5 Hz) via an external PMOD loop-back  
- Counts LED pulses and displays the running total on a four-digit, multiplexed seven-segment display  
- Includes full VHDL source, constraint file, testbench, and detailed design report  

---

## Features

- **Clock Generation**  
  – 25 MHz divider (÷4)  
  – 100 kHz divider (÷1 000)  

- **Robust Reset**  
  – Push-button (`BTN0`) debounced & two-stage synchronized  

- **LED Controller**  
  – 3 selectable blink rates (2 Hz, 1 Hz, 0.5 Hz)  
  – Select via `SW1`, `SW2`, `SW3` (priority encoded)  

- **Pulse Counter**  
  – Free-running 16-bit counter on every rising edge of LED output  
  – Verified counts:  
    - 200 pulses in 100 s at 2 Hz  
    - 5 pulses in 10 s at 0.5 Hz  

- **Seven-Segment Display**  
  – Multiplexed 4 digits, refreshed at 1 kHz  
  – BCD-to-7-segment decoder  

- **Testbench**  
  – Functional simulation covering all modules  
  – Timing/accuracy checks for clocks, blink rates, counters  

- **Constraints**  
  – `Basys-3-Master.xdc` maps clocks, PMOD loop-back, buttons, switches, LED, `seg[6:0]`, `an[3:0]`  

- **Report**  
  – 8-page LaTeX document covering architecture, timing results, resource utilization, and oscilloscope captures  

---

## Pin Mappings

# System clock input
set_property PACKAGE_PIN W5  IOSTANDARD LVCMOS33 [get_ports clk_100mhz]

# PMOD clock loop-back
set_property PACKAGE_PIN JA0 IOSTANDARD LVCMOS33 [get_ports pmod_clk_out]
set_property PACKAGE_PIN JA1 IOSTANDARD LVCMOS33 [get_ports pmod_clk_in]

# Reset button
set_property PACKAGE_PIN V9  IOSTANDARD LVCMOS33 [get_ports BTN0]

# Switches
set_property PACKAGE_PIN U16 IOSTANDARD LVCMOS33 [get_ports SW1]
set_property PACKAGE_PIN E19 IOSTANDARD LVCMOS33 [get_ports SW2]
set_property PACKAGE_PIN D17 IOSTANDARD LVCMOS33 [get_ports SW3]

# LED
set_property PACKAGE_PIN U16 IOSTANDARD LVCMOS33 [get_ports LED0]

# Seven-segment segments (A–G)
set_property -dict { PACKAGE_PIN W7 IOSTANDARD LVCMOS33 } [get_ports {seg[0]}]
set_property -dict { PACKAGE_PIN W6 IOSTANDARD LVCMOS33 } [get_ports {seg[1]}]
set_property -dict { PACKAGE_PIN U8 IOSTANDARD LVCMOS33 } [get_ports {seg[2]}]
set_property -dict { PACKAGE_PIN V8 IOSTANDARD LVCMOS33 } [get_ports {seg[3]}]
set_property -dict { PACKAGE_PIN U5 IOSTANDARD LVCMOS33 } [get_ports {seg[4]}]
set_property -dict { PACKAGE_PIN V5 IOSTANDARD LVCMOS33 } [get_ports {seg[5]}]
set_property -dict { PACKAGE_PIN U7 IOSTANDARD LVCMOS33 } [get_ports {seg[6]}]

# Seven-segment digit enables (AN0–AN3)
set_property -dict { PACKAGE_PIN U2 IOSTANDARD LVCMOS33 } [get_ports {an[0]}]
set_property -dict { PACKAGE_PIN U4 IOSTANDARD LVCMOS33 } [get_ports {an[1]}]
set_property -dict { PACKAGE_PIN V4 IOSTANDARD LVCMOS33 } [get_ports {an[2]}]
set_property -dict { PACKAGE_PIN W4 IOSTANDARD LVCMOS33 } [get_ports {an[3]}]
