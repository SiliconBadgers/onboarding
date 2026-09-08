# Calculator project

[Start here](../README.md) · Document 5 of 10

*Beginner path. Edit only `rtl/calculator.sv` for this part.*

Your job is to write a complete next-state `always_comb` block and a complete register-update `always_ff` block. The module ports, state names, internal signals, and output logic are provided. The starting code is valid SystemVerilog, but it is intentionally incomplete and will not pass the testbench yet.

## The provided memory

`rtl/data_memory.sv` contains 16 signed 8-bit locations. It starts with 8 at address 0, 3 at address 1, and zero everywhere else.

Reading is combinational: set `memory_address`, and the selected value appears on `memory_read_data`. Writing happens on a rising clock edge when `memory_write_enable` is 1; the memory copies `memory_write_data` into the selected address.

The `initial` block preloads this teaching memory for simulation. ASIC memories need a real initialization/loading plan; don't assume this preload creates an automatically initialized fabricated memory. Reset clears the calculator, not the memory. Restarting the simulation reloads the initial memory contents.

## Understand the signals

| Signal | Meaning |
| --- | --- |
| `instruction[7:0]` | Encoded command and address |
| `command_valid` | Testbench is presenting a command |
| `command_ready` | Calculator can accept a command |
| `command_done` | Current command has finished |
| `accumulator` | Stored working number |
| `memory_address` | Selected location, 0–15 |
| `memory_read_data` | Data from that location |
| `memory_write_data` | Data to write to that location |
| `memory_write_enable` | Allow a write on the next rising edge |

A command is accepted **on a rising edge when both `command_valid` and `command_ready` are 1**. While the calculator is busy, ready is 0. Keep the instruction stable until acceptance, then lower valid so it isn't accepted again later.

The provided output block handles `command_ready`, `command_done`, and memory writes. Read it to see how the current state controls the interface. Your two blocks will decide the next state and update all stored values.

## The four states

```mermaid
flowchart LR
    I[IDLE] -->|LOAD / ADD / SUB| R[READ_MEMORY]
    R --> E[EXECUTE]
    I -->|STORE| E
    E --> F[FINISH]
    I -->|Unused opcode| F
    F --> I
```

| State | What happens before the next rising edge | What happens on that edge |
| --- | --- | --- |
| `IDLE` | Advertise ready and examine the incoming command | Save the accepted opcode/address and leave idle |
| `READ_MEMORY` | Memory is showing the saved address's data | Capture it into `saved_memory_data` |
| `EXECUTE` | Select the saved opcode's operation | Update the accumulator, or let memory perform STORE |
| `FINISH` | Advertise done for one cycle | Return to idle |

For `LOAD 0`, edge 1 accepts the instruction, edge 2 captures the number 8, and edge 3 copies 8 into the accumulator. Done is high after edge 3; edge 4 returns the calculator to idle. `STORE` skips the read, so its write happens at edge 2 instead.

## Write the two blocks

### TODO 1: `always_comb`

Write the whole next-state block yourself. Give `next_state` a default value first, then use `case (current_state)` to implement the diagram. Stay in `IDLE` without a valid command. LOAD, ADD, and SUB go to `READ_MEMORY`; STORE goes directly to `EXECUTE`; unused opcodes go to `FINISH`. The other states advance in order and the `default` state recovers to `IDLE`.

### TODO 2: `always_ff`

Write one complete `always_ff @(posedge clk)` block. It needs to:

1. On reset, set `current_state` to `IDLE` and set `saved_opcode`, `saved_address`, `saved_memory_data`, and `accumulator` to 0.
2. When not resetting, copy `next_state` into `current_state` every rising edge.
3. When a command is accepted, save `instruction[7:4]` as the opcode and `instruction[3:0]` as the address. A command is accepted when valid and ready are both 1.
4. In `READ_MEMORY`, capture `memory_read_data` into `saved_memory_data`.
5. In `EXECUTE`, use the saved opcode to update the accumulator. LOAD copies the saved memory value, ADD adds it, and SUB subtracts it. STORE and unused opcodes leave the accumulator unchanged; the provided output logic handles the memory write.

Start by implementing LOAD and following it through the waveform. Then add ADD and SUB. Finally check that STORE and the return to idle work. The full provided test needs all four operations, so intermediate failures are expected.

Leave the module ports, signal declarations, state names, and supplied output block in place. Don't add parameters, local parameters, helper functions, or tasks. The provided `enum` just gives readable names to the four states.

## Stuck? Open these hints one at a time

Before asking AI to write the code, make an attempt, compile it, and read the first error or failed test. Then open only the next hint you need. You can also message Simon on Slack or ask AI to **explain a specific concept or error** without generating the whole block.

<details>
<summary>Hint 1: Shape of the two blocks</summary>

The combinational block should have this overall shape:

```systemverilog
always_comb begin
    next_state = current_state;

    case (current_state)
        // One branch for each state, plus default.
    endcase
end
```

The clocked block should have this overall shape:

```systemverilog
always_ff @(posedge clk) begin
    if (reset) begin
        // Reset every stored value.
    end
    else begin
        // Update state and the other registers when required.
    end
end
```

</details>

<details>
<summary>Hint 2: Getting out of IDLE</summary>

Inside the `IDLE` branch, first check `command_valid`. If it is 1, use another `case` on `instruction[7:4]`. Opcodes `0000`, `0001`, and `0010` read memory. Opcode `0011` stores. Everything else is unused.

</details>

<details>
<summary>Hint 3: What belongs in the clocked block?</summary>

Every assignment in this block uses `<=`. The reset branch assigns all five stored values. In the non-reset branch, update `current_state` every edge, save the instruction only when `command_valid && command_ready`, capture memory only in `READ_MEMORY`, and change the accumulator only in `EXECUTE` for LOAD, ADD, or SUB.

</details>

<details>
<summary>Last resort: compare with the completed solution</summary>

Only open the [completed reference solution](../solutions/calculator_solutions.sv) after making a real attempt and using the hints. To simulate it, use it instead of the starter; never add both calculator files to the same project because both define a module named `calculator`.

</details>

---

[← Previous: ISA refresher](04-isa-refresher.md) · [Start here](../README.md) · [Next: Simulation and testbenches →](06-simulation-testbenches.md)
