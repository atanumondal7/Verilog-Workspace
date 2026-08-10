# 4-bit ALU — First CDV/CRV Project

This was the first time I used constrained-random verification, `rand`/`constraint`, `covergroup`, interfaces, classes, and tasks together in one testbench, using Aldec Riviera-Pro in EDA Playground. The [UVM-style ALU project](../alu-uvm-style) was a sequel to this, which I made after I went deeper into verification methodology with layered architecture (separate generator, driver, monitor, scoreboard classes connected by mailboxes). This project is much simpler: one `randomizer` class holds the `rand` fields, the constraint, and the covergroup, and the whole testbench runs in a single `initial` block with an inline reference model for checking the DUT.

## Architecture
 
![ALU CDV Testbench Architecture](alu-cdv/docs/architecture.png)

## Result

```
Final Function Coverage: 100.00%
All tests passed successfully!
```

5000 randomized transactions, 0 errors.

![Waveform](alu-cdv/docs/waveform.jpg)

## The Differentiating Factor

Here, the subtraction mechanism branches on `a < b` by swapping the operands, computing the positive difference, and triggering `neg_flag` manually. At the time, I did not know that `-` sign already handles underflow flawlessly, so I forced the result positive and manually tracked the sign.

By the UVM-style project, I understood that SystemVerilog's unsigned subtraction already wraps `a - b` correctly and gives the right bit pattern whether or not `a < b`. All that's actually needed is *detecting* the sign case (`a < b`), which is why it uses unconditional `a - b` and `neg_flag` set separately.

## File Structure

- [**`alu_cdv.sv`**](alu-cdv/alu_cdv.sv) - combinational ALU [add/subtract/AND/OR, with carry/zero/negative flags]
- [**`alu_cdv_tb.sv`**](alu-cdv/alu_cdv_tb.sv) - `randomizer` class (rand fields + weighted opcode `dist` + covergroup
  with cross coverage), interface, and the testbench module that drives, checks, and samples
  coverage in every cycle

## Compilation & Simulation

```bash
python run.py
```

Since Riviera Pro is no longer accessible, this script executes the simulation in Questa along with compilation and waveform logging.
