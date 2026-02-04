# Traffic Light Controller (Verilog HDL)

## Overview
A time-based traffic light controller implemented using Verilog HDL.
The design uses a clock divider to generate a 1-second tick and a Moore
FSM to control traffic signals.

## Design Highlights
- Clock divider for time generation
- Moore FSM (glitch-free outputs)
- Parameterized timing values
- Clean reset handling
- Simulation with testbench

## FSM Timing
- Green  : 10 seconds
- Yellow : 3 seconds
- Red    : 5 seconds

## Folder Structure
- rtl/  : RTL design files
- tb/   : Testbenches
- docs/ : FSM diagram and design notes
- waveforms/ : Simulation results

## Tools
- Verilog HDL
- EDA Playground / ModelSim
