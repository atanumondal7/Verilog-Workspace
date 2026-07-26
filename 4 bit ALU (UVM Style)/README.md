# 4 bit ALU Testbench

By utilising OOP architecture and class implementations, I have created a multi-layered testbench spanning across 10 files in order to precisely verify every working component of the ALU and target edge cases by stress testing the input variables through a transaction (item) class.

## RTL Framework

• [alu.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu.sv) (RTL Design): The core 4-bit Arithmetic Logic Unit module. It implements arithmetic (e.g., addition, subtraction) and bitwise logical operations across 4-bit input operands based on an operation selector (`ALU_Sel`), driving the resulting output along with status flags (such as zero, carry, or overflow).

## Class Architecture & Component Responsibilities

The testbench follows a UVM-inspired layered design pattern, separating stimulus generation, driving, monitoring, and checking. For detailed inspection, visit the files in the following order:

• [alu_if.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_if.sv) (Interface): Encapsulates all ALU signals, clocking blocks, and modports to cleanly bridge the OOP testbench environment with the hardware design.

• [alu_item.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_item.sv) (Transaction Class): Defines the transaction object containing the inputs (`A`, `B`, `ALU_Sel`) and expected/actual outputs. Enforces constraints for targeted and random stimulus generation to hit edge cases.

• [alu_generator.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_generator.sv) (Generator): Creates transactions, randomizes them based on targeted constraints, and passes them to the driver via mailboxes.

• [alu_driver.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_driver.sv) (Driver): Unpacks transactions received from the generator and drives the signal levels onto the virtual interface in sync with the design clock.

• [alu_monitor.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_monitor.sv) (Monitor): Passively samples signal activity on the virtual interface, captures response vectors, and forwards them to the scoreboard and coverage collector.

• [alu_scoreboard.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_scoreboard.sv) (Scoreboard): Implements a golden reference model for the 4-bit ALU. Compares the actual output captured by the monitor against expected results and reports pass/fail statistics.

• [alu_coverage.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_coverage.sv) (Functional Coverage): Defines covergroups and coverpoints for input combinations and ALU operations to ensure all edge cases and opcodes are thoroughly exercised.

• [alu_environment.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_environment.sv) (Environment): Container class that instantiates, connects, and coordinates all testbench components (`generator`, `driver`, `monitor`, `scoreboard`, `coverage`).

• [alu_pkg.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_pkg.sv) (Package): Encapsulates all classes, typedefs, and parameters into a single package scope for modular compilation.

• [alu_tb.sv](https://github.com/atanumondal7/SystemVerilog-Workspace/blob/main/4%20bit%20ALU%20(UVM%20Style)/alu_tb.sv) (Top Testbench Module): The top-level SystemVerilog module that generates the clock/reset, instantiates the Design Under Test (`alu.sv`) and interface (`alu_if.sv`), and runs the environment.

## Simulation / How to Run

To compile and execute the testbench in Synopsys VCS:

```bash
# 1. Compile & Elaborate
vcs -sverilog -full64 -debug_access+all \
  alu.sv \
  alu_if.sv \
  alu_pkg.sv \
  alu_tb.sv \
  -o simv

# 2. Run Simulation
./simv
