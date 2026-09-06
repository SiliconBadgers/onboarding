# Verilog and SystemVerilog basics

[Start here](../README.md) · Document 3 of 10

## What is a chip?

*Beginner path.*

An **integrated circuit (IC)**, or chip, is a tiny piece of semiconductor material, usually silicon, with transistors and electrical connections built into it. In a digital chip, those transistors form logic gates and registers that work together to process and store information.

An **ASIC**, or application-specific integrated circuit, is a chip designed for a particular application. For example, a video encoder chip has specialized hardware to encode video quickly and efficiently. Its physical circuitry is fixed when it's manufactured.

Not every chip is an ASIC. A **general-purpose CPU**, like the processor in your laptop, runs software for many different tasks rather than specializing in one application. Its physical circuitry is also fixed, but different programs tell that circuitry what to do.

An **FPGA**, or field-programmable gate array, is a manufactured chip containing configurable logic, registers, routing, and often memory and arithmetic blocks. You load a configuration that connects those resources into your circuit, and you can reconfigure it later to implement a different design.

**SystemVerilog describes hardware.** Two `always_ff` blocks describe registers that operate at the same time. Writing the second block below the first does not mean the hardware waits for the first block to finish.

## Learn enough Verilog

*Beginner path. About two hours; it's fine if the FSMs take longer.*

HDLBits runs in your browser and checks your design against a reference. Complete **only the exercises listed here**, in this order. You don't need to work through the entire website.

| # | Exercise | What you're practicing |
| --- | --- | --- |
| 1 | [Getting Started](https://hdlbits.01xz.net/wiki/Step_one) | Submit a circuit and read the result |
| 2 | [Vectors](https://hdlbits.01xz.net/wiki/Vector0) | Represent several bits together |
| 3 | [Vectors in more detail](https://hdlbits.01xz.net/wiki/Vector1) | Select portions of a bus |
| 4 | [Modules](https://hdlbits.01xz.net/wiki/Module) | Connect a provided circuit by named ports |
| 5 | [2-to-1 multiplexer](https://hdlbits.01xz.net/wiki/Mux2to1) | Choose between two inputs |
| 6 | [Always blocks: combinational](https://hdlbits.01xz.net/wiki/Alwaysblock1) | Describe logic that responds to inputs |
| 7 | [Always blocks: clocked](https://hdlbits.01xz.net/wiki/Alwaysblock2) | Store a result on the clock edge |
| 8 | [Case statement](https://hdlbits.01xz.net/wiki/Always_case) | Select an action from several possibilities |
| 9 | [Avoiding latches](https://hdlbits.01xz.net/wiki/Always_nolatches) | Assign outputs on every combinational path |
| 10 | [DFF with synchronous reset](https://hdlbits.01xz.net/wiki/Dff8r) | Store eight bits and reset them |
| 11 | [Four-bit binary counter](https://hdlbits.01xz.net/wiki/Count15) | Update a register using its previous value |
| 12 | [Simple state transitions 3](https://hdlbits.01xz.net/wiki/Fsm3comb) | Turn a state table into combinational logic |
| 13 | [Simple FSM 2: synchronous reset](https://hdlbits.01xz.net/wiki/Fsm2s) | Connect next-state logic to a state register |
| 14 | [Simple FSM 3: synchronous reset](https://hdlbits.01xz.net/wiki/Fsm3s) | Implement a complete four-state controller |

For each exercise, read the explanation, fill in the module, click **Simulate**, and look for **Success!**.

## Verilog to SystemVerilog

SystemVerilog extends Verilog with features for designing and testing hardware, but most of the syntax is the same; we'll use SystemVerilog for this project.

| In Verilog | In this SystemVerilog project | Meaning |
| --- | --- | --- |
| `wire` / `reg` in these simple, single-driver examples | `logic` | Declare a signal; how you assign it determines the hardware |
| `always @(*)` | `always_comb` | Combinational logic |
| `always @(posedge clk)` | `always_ff @(posedge clk)` | Registers updated on a rising clock edge |
| `.v` file | `.sv` file | Tell the tools to use SystemVerilog |

`logic` doesn't automatically mean a register, and Verilog's `reg` doesn't automatically mean a physical register either. The assignment describes whether the signal is stored. Wires still have uses in SystemVerilog; this project just doesn't need the more complicated cases.

### A live answer versus a saved answer

```systemverilog
logic [7:0] a, b;
logic [7:0] live_sum, saved_sum;

always_comb begin
    live_sum = a + b;
end

always_ff @(posedge clk) begin
    if (reset) begin
        saved_sum <= 8'd0;
    end
    else begin
        saved_sum <= live_sum;
    end
end
```

If `a = 8` and `b = 3`, `live_sum` becomes 11 as the combinational logic settles. `saved_sum` keeps its old value until the next rising clock edge, then captures 11. If `b` changes to 4 between edges, `live_sum` becomes 12 but `saved_sum` still holds 11.

Think of `always_comb` as a live calculator display and `always_ff` as taking a photo of that display on each clock tick. Real gates have propagation delay; “live” means no clocked storage was added.

### Two habits that prevent lots of bugs

In `always_comb`, assign every output on every possible path. For example:

```systemverilog
always_comb begin
    result = 8'd0;
    if (enable) begin
        result = a + b;
    end
end
```

When `enable` is zero, the result is explicitly zero. Without that default, you'd be asking it to remember an old result, which implies a latch.

In `always_ff`, leaving a register unassigned in a branch means **keep its value**. That's useful for the accumulator while the calculator is idle. Use `<=` here: in `a <= b; b <= a;`, both assignments read the old values, so the registers swap on the edge.

A literal like `8'd11` means “eight bits, decimal 11.” `8'h11` means “eight bits, hexadecimal 11,” which is decimal 17. `8'sd11` is signed decimal 11; write negative five as `-8'sd5`. The calculator uses signed 8-bit data, so its range is −128 through 127. Overflow wraps: 127 + 1 becomes −128.

---

[← Previous: Setup](02-setup.md) · [Start here](../README.md) · [Next: ISA refresher →](04-isa-refresher.md)
