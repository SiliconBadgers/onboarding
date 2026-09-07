# ISA refresher

[Start here](../README.md) · Document 4 of 10

*Everyone reads this section.*

An **instruction set architecture (ISA)** is the agreement about which instructions hardware understands and what each instruction does. The bits don't do anything by themselves: a decoder recognizes them, and control logic tells registers, arithmetic, and memory what to do.

Our calculator understands four operations and has one working register, the **accumulator**. Its data memory has 16 locations, each holding one signed byte.

| Instruction | Opcode bits | Action |
| --- | --- | --- |
| `LOAD address` | `0000` | `memory[address] → accumulator` |
| `ADD address` | `0001` | `accumulator + memory[address] → accumulator` |
| `SUB address` | `0010` | `accumulator − memory[address] → accumulator` |
| `STORE address` | `0011` | `accumulator → memory[address]` |

Each instruction is **one byte**:

```text
       bits 7 6 5 4       bits 3 2 1 0
      ┌────────────┬──────────────────┐
      │   opcode   │  memory address  │
      └────────────┴──────────────────┘
```

Four address bits select locations 0–15. The high four bits allow 16 possible opcodes, but we define only four. For this calculator, other opcodes finish without changing the accumulator or memory.

Given `memory[0] = 8` and `memory[1] = 3`:

| Assembly | Bits | SystemVerilog literal | Result |
| --- | --- | --- | --- |
| `LOAD 0` | `0000_0000` | `8'h00` | Accumulator becomes 8 |
| `ADD 1` | `0001_0001` | `8'h11` | Accumulator becomes 11 |
| `STORE 2` | `0011_0010` | `8'h32` | Memory location 2 becomes 11 |

Notice that `8'h11` is an encoded instruction, not the arithmetic result 11.

## How the RTL implements it

The provided decoder splits `instruction[7:4]` from `instruction[3:0]`. When a command is accepted, registers save those fields so later input changes can't change the command being executed.

The controller selects an action based on the saved opcode. For example, `0001` selects addition and enables an accumulator update; `0011` enables a memory write instead. You can think of the path as:

```text
instruction byte → decode opcode/address → controller
                 → select arithmetic or memory action → register/memory update
```

The **datapath** is the arithmetic and storage that operates on the numbers. The **controller** decides when each part acts. An ISA describes what an instruction means; this state machine is one implementation of it. Another implementation could take a different number of cycles and still produce the same results.

This calculator gets commands from the testbench. It doesn't fetch a program from instruction memory, and you don't need a program counter or branching.

## Try it

Before looking at any code, write down:

1. The hexadecimal byte for `SUB 1`.
2. The command represented by `8'h34`.
3. Three instruction bytes that compute `memory[1] − memory[0]` and store it at address 4.

Keep your answers nearby. You'll see the same ideas in the accelerator section.

**Completed ECE 551? Continue to [chip design jobs and the ASIC flow](07-chip-design.md#chip-design-jobs-and-the-asic-flow).** You can skip the calculator implementation and both testbenches.

---

[← Previous: Learning Systemverilog](03-learning-systemverilog.md) · [Start here](../README.md) · [Next: Calculator project →](05-calculator-project.md)

**ECE 551 path:** skip the two coding documents and go to [Chip design →](07-chip-design.md).
