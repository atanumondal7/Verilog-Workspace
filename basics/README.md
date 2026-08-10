# Basics

Early exercises from when I was just starting to learn what Verilog and HDLs even were, before moving into the verification projects. It contains gate-level and behavioral Verilog, each with a self-contained testbench in the same file. Started with simple RTL designs like adder, MUX, sequential counter and then moved to sub-module based ones like `16bit_rca` using half adders and `4bit_counter_cdv` with self-checking testbench and eventually `rand`/`constraint`/`covergroup`.

Most were written and simulated in EDA Playground using Icarus Verilog. Only the CDV based counter was simulated through Aldec Riviera-Pro.

| File | Briefing |
|---|---|
| [`4bit_adder.v`](4bit_adder.v) | 4-bit adder, directed stimulus |
| [`4bit_subtractor.v`](4bit_subtractor.v) | 4-bit subtractor, zero-on-underflow |
| [`4bit_alu.v`](4bit_alu.v) | Behavioral ALU (add/subtract/AND/OR), directed stimulus; the earliest version of the ALU idea, before the CDV and UVM-style projects |
| [`manual_4bit_mux.v`](manual_4bit_mux.v) | 4-to-1 mux built from `and`/`or`/`not` primitives instead of behavioral logic |
| [`4bit_counter.v`](4bit_counter.v) | Free-running 4-bit sequential counter, plain Verilog |
| [`accumulator_manual.v`](accumulator_manual.v) | Register + gate-level ripple-carry adder wired into a feedback accumulator |
| [`16bit_rca.v`](16bit_rca.v) | 16-bit ripple-carry adder built from cascaded 4-bit blocks down to half-adders; `$random` stimulus with a self-checking task and error count |
| [`4bit_counter_cdv.sv`](4bit_counter_cdv.sv) | Same counter idea as `4bit_counter.v`, rebuilt in SystemVerilog with `rand`/`constraint`/`covergroup` and a clocking-block interface; the first time these ideas started to show up before the main projects |
| [`traffic_light_simulator.v`](traffic_light_simulator.v) | Simple traffic-light FSM driven off a free-running counter |
