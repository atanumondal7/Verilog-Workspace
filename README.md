# SystemVerilog-Workspace

Simulated in Questa (Altera FPGA Starter Edition 25.1)

This repository contains SystemVerilog/Verilog projects I've built and verified, ranging from basic gate-level designs to class-based, coverage-driven verification environments bundled with constrained randomization. Each project includes both the design (DUT) and a corresponding testbench validating its functional correctness.

## Projects

1. **Traffic Light Simulator** — A fully functional traffic light simulator with custom delays and timing logic driven off clock edges.

2. **Accumulator (Manual)** — Built from primitive gates, this accumulator houses a Ripple Carry Adder (RCA) that performs sequential addition logic at each clock edge.

3. **4-bit ALU (CDV Framework)** — A generic ALU supporting ADD, SUBTRACT, AND, and OR operations. The testbench applies a coverage-driven verification (CDV) methodology, combining constrained-random stimulus generation with a class-based, self-checking scoreboard.

4. **4-bit ALU (UVM-Style)** — A class-based, transaction-oriented rework of the ALU testbench consisting 4 operations (Add, Subtract, AND, OR) structured around a layered UVM-style architecture — generator, driver, monitor, scoreboard, and coverage — connected through virtual interfaces and mailboxes.

5. **Universal Shift Register (USR)** — A class-based testbench covering all four USR operations (Hold, Shift-Right, Shift-Left, Parallel Load). Verified a 2-cycle sampling offset caused by clocking-block output skew, fixed via monitor edge-priming and a 2-stage input history buffer, achieving 100% functional coverage.
