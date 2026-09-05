# SystemVerilog Workspace

SystemVerilog/Verilog projects I've built and verified, ranging from gate-level fundamentals to class-based, coverage-driven verification environments with constrained randomization. Started with Icarus Verilog for the RTL design fundamentals, then moved to industry-grade simulators: Aldec Riviera Pro (25.04) and, more recently, a local install of Siemens Questa (Altera FPGA Starter Edition 25.1) for the advanced verification projects.

## Projects

Presented in the order I built them. Each project steps up a notch from the one before it: a new simulator, a bug pattern worth revisiting or a more layered architecture layout.

| Project | Overview | Specifications | Simulator |
|---|---|---|---|
| [`alu-cdv`](projects/alu-cdv) | My first constrained-random / coverage-driven project | `rand`/`constraint`/`covergroup` in a single-file testbench | Aldec Riviera Pro |
| [`alu-uvm-style`](projects/alu-uvm-style) | Same ALU, rebuilt with a properly layered, mailbox-connected testbench | `rand`/`constraint`, covergroups with cross coverage, split into generator, driver, monitor and scoreboard | Aldec Riviera Pro |
| [`priority-encoder`](projects/priority-encoder) | An 8-bit priority encoder with a clocking-block skew bug I found and fixed | Mailboxes, golden reference model, manual coverage (12 bins) | Siemens Questa |
| [`decoder`](projects/decoder) | A 3-to-8 decoder with a proper clocking-skew fix, plus deliberate X-propagation testing | Manual coverage (10 bins), `===` 4 state case equality | Siemens Questa |
| [`universal-shift-register`](projects/universal-shift-register) | The most interesting of the five: a parameterized sequential USR with a self-checking testbench and a *sampling latency* bug that cost 2 buffer cycles for fixing | Mailboxes, golden reference model, manual coverage (85 bins) | Siemens Questa |
| [`fifo-buffer`](projects/fifo-buffer) | A parameterized synchronous FIFO where the real challenge was the RTL itself: pointer-based fullness tracking and getting overflow/underflow to behave as pulses, not latches | Subdivided `rtl/`/`testbench/`/`sim/` layout with a `files.f` filelist, mailboxes, golden reference model, manual coverage (9 bins) | Siemens Questa |

## Basics

[`basics/`](basics) has the fundamental, gate-level and behavioral exercises from the very beginning of learning HDLs. It consists of adders, a mux, counters and an accumulator which are mostly plain Verilog along with one SystemVerilog exercise showcasing CDV/CRV that I built before diving deeper into advanced verification methodology.
