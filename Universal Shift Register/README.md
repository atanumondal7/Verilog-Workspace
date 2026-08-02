# Universal Shift Register Testbench

By utilizing OOP architecture and class implementations, I have created a multi-layered testbench spanning across 11 files in order to precisely verify every working component of the Universal Shift Register (USR) and target edge cases by stress testing the input variables through a transaction (item) class.

## RTL Framework

• [usr.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr.sv) (RTL Design): The core Universal Shift Register module. It supports operational modes such as hold/no-change, shift-left, shift-right, and parallel load based on control select signals (`mode`), operating synchronously with clock and asynchronous/synchronous reset inputs.

## Class Architecture & Component Responsibilities
The testbench follows a UVM-inspired layered design pattern, separating stimulus generation, driving, monitoring, and checking. For detailed inspection, visit the files in the following order:

• [usr_if.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_if.sv) (Interface): Encapsulates all Universal Shift Register signals, clocking blocks, and modports to cleanly bridge the OOP testbench environment with the hardware design.

• [usr_item.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_item.sv) (Transaction Class): Defines the transaction object containing inputs (serial inputs, parallel data input, mode select) and expected/actual outputs.

• [usr_generator.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_generator.sv) (Generator): Creates randomized transactions and passes them to the driver via mailbox (`gen2drv`).

• [usr_driver.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_driver.sv) (Driver): Unpacks transactions received from the generator and drives the signal levels onto the virtual interface (`vif`) in sync with the design clock.

• [usr_monitor.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_monitor.sv) (Monitor): Passively samples signal activity on the virtual interface, captures response vectors, and forwards them to the scoreboard and coverage collector.

• [usr_scoreboard.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_scoreboard.sv) (Scoreboard): Implements a golden reference model for the Universal Shift Register. Compares the actual output captured by the monitor against expected results and reports pass/fail statistics.

• [usr_coverage.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_coverage.sv) (Functional Coverage): Defines coverpoints and edge cases manually through conditional statements for mode transitions, serial/parallel inputs, and operational states to ensure all shift and load modes are thoroughly exercised.

• [usr_environment.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_environment.sv) (Environment): Container class that instantiates, connects, and coordinates all testbench components (generator, driver, monitor, scoreboard, coverage).

• [usr_pkg.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_pkg.sv) (Package): Encapsulates all classes and parameters into a single package scope for modular compilation.

• [usr_tb.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/Universal%20Shift%20Register/usr_tb.sv) (Top Testbench Module): The top-level SystemVerilog module that generates the clock/reset, instantiates the Design Under Test (`usr.sv`) and interface (`usr_if.sv`), and runs the environment.

## Simulation / How to Run

To compile and execute the testbench using Siemens Questa / ModelSim via the provided TCL script (`run.do`):

```bash
# Execute the automated build & run DO script in command-line mode
vsim -c -do run.do
