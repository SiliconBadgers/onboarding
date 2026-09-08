# Simulation and testbenches

[Start here](../README.md) · Document 6 of 10

### Run QuestaSim/ModelSim

## Mac Tutorial

If you're on Mac you will have to remote access a CAE computer to get access to QuestaSim. Don't worry! It's actually super simple and will take 2 minutes max. Here's a [tutorial](https://mediaspace.wisc.edu/media/QuestaSim+for+Mac/1_u631yf90)!

## Stuck?

If you get stuck in any of the following steps you can refer to this [video](https://mediaspace.wisc.edu/media/QuestaSim+ModelSim+Compile+Simulate+Tutorial/1_afrsdwu5) for help!

### Compile and read errors

1. Save your code in VS Code.
2. In QuestaSim/ModelSim, click **Compile** at the top, then **Compile All**.
3. Read the **Transcript** at the bottom. If something is wrong, the error appears in red.
4. Double-click the red error text to open the message details or jump to the file and line. If your version only shows details, use the filename and line number in that message to find it in VS Code.
5. Fix the first error, save, then **Compile → Compile All** again.

Common mistakes: missing semicolons, unmatched `begin`/`end`, misspelled signal names, and compiling a `.sv` file as plain Verilog. If the language is wrong, check the file's properties in the Project tab and select SystemVerilog.

Compiling with no errors only proves the tools can process your code. The testbench checks whether your circuit behaves correctly.

### Start the provided testbench

1. Click the **Library** tab.
2. Expand **work**.
3. Find **calculator_tb**, right-click it, and select **Simulate**.

You can also use **Simulate → Start Simulation** at the top, expand **work**, and select the testbench. If that route causes issues in your installation, use the Library/right-click method above.

Select `calculator_tb`, not `calculator` or `student_testbench` for this first test. The testbench creates the clock, sends the commands, and checks the results.

### Add waves before running

1. In the **Sim** pane, select the top-level `calculator_tb` instance. Its signals appear in **Objects**. If the pane is hidden, find it under **View**.
2. Select `clk`, `reset`, `instruction`, `command_valid`, `command_ready`, `command_done`, `accumulator`, `memory_address`, `memory_read_data`, `memory_write_data`, and `memory_write_enable`. Use Ctrl-click for several signals.
3. Right-click the selection and choose **Add Wave → Selected Signals** (some versions label this **Add to Wave**). The signals should appear in the **Wave** window.
4. Expand `calculator_tb` in the Sim pane and select `dut`. Add `current_state` from Objects too.
5. In Wave, right-click `instruction` and choose **Radix → Hexadecimal**. Set the accumulator and memory data signals to **Decimal/signed decimal**, so negative results show as negative numbers. Keep address unsigned.
6. Click **Run All**, or type `run -all` in the Transcript and press Enter. The provided testbench pauses itself when it finishes, so QuestaSim/ModelSim should not ask whether you want to finish the simulation.
7. Click inside the **Wave** window, then press the **Zoom Full magnifying-glass button**. Hover over the magnifying-glass icons until the tooltip says **Zoom Full**; a plain Zoom In button won't fit the whole run. You can also type `wave zoom full`.

If a signal is missing because it was optimized away, enter `quit -sim`, then `vsim -voptargs=+acc work.calculator_tb`, and add the signals again before running.

The provided test includes these calculations:

```text
LOAD 0 → ADD 1 → STORE 2       memory[2] should become 11
LOAD 0 → SUB 1 → STORE 3       memory[3] should become 5
```

A completed calculator should print **ALL TESTS PASSED**. A timeout usually means the state machine never returned the expected ready/done signal. The untouched starter is expected to time out; it must not print a pass.

### Read the waveform

Find a rising edge where valid and ready are both high. That is instruction acceptance. Follow the state changes and check that:

- LOAD changes the accumulator to 8.
- ADD changes it to 11; the change happens on a clock edge.
- STORE raises `memory_write_enable`, and the accumulator stays at 11.
- Done stays high for one cycle, then ready returns.
- The second calculation leaves the accumulator at 5.

Take a screenshot of **ALL TESTS PASSED**. You'll capture the waveform submission from your own testbench in [Write your own testbench](#write-your-own-testbench).

After changing RTL, end the loaded simulation with **Simulate → End Simulation** or `quit -sim`, compile all again, and load the testbench again. If only replaying the same compiled code, use `restart -f` followed by `run -all`. If waves were added after running, restart and rerun to capture the history.

## Write your own testbench

*Beginner path. Complete `tb/student_testbench.sv` after the supplied test passes.*

A testbench is the simulation environment around the hardware. It provides inputs and checks outputs. Its `#5` delays and `$display` messages are simulation instructions; they don't become gates in the calculator.

The scaffold provides signal declarations, module connections, and a clock. You write the reset sequence, commands, and result check. Your test should calculate **3 − 8 = −5** and store it at address 4.

1. Initialize reset, instruction, and valid so inputs don't start unknown. Keep reset high across at least two rising edges. After the second edge, wait `#1` before lowering reset.
2. Send `LOAD 1`, wait for completion, then send `SUB 0`, and finally `STORE 4`.
3. Follow the command handshake using only rising edges. After a rising edge, wait `#1`, check that ready is high, then present the instruction byte and valid. Keep them stable through the next rising edge so the command is accepted. Wait `#1`, lower valid, and check done after later rising edges.
4. Check `memory.memory[4]` against `-8'sd5`. This name means “the array named memory inside the instance named memory.”
5. Print **STUDENT TEST PASSED** only if the result is right. Otherwise use `$fatal(1, "Unexpected result");`. End a successful test with `$stop;`. This pauses the testbench without asking whether you want to finish the simulation.

Look at the provided testbench to understand the timing. `@(posedge clk);` waits for a rising edge, and the following `#1;` gives the calculator's nonblocking register updates time to settle before the testbench reads or changes signals. Inputs driven after that delay stay stable until the next rising edge, when the calculator accepts them. Recheck ready after a rising edge and `#1` before each command, even after seeing done.

Use `!==` for the result check so an unknown `X` also counts as wrong. The scaffold has a timeout so a missing clock/reset/command doesn't leave the simulation running forever.

Compile all, end any previous simulation, then use **Library → work → student_testbench → right-click → Simulate**. Add its signals, run all, and press Zoom Full as before. A fresh simulation reloads the provided memory. Take your waveform screenshot here: show clock, reset, instruction, accumulator, command_valid, command_ready, and command_done, with readable signal names, values, and time axis.

You will submit both your completed `calculator.sv` and `student_testbench.sv`. Keep `calculator_tb.sv` unchanged so its checks remain useful.

---

[← Previous: Calculator project](05-calculator-project.md) · [Start here](../README.md) · [Next: Chip design →](07-chip-design.md)
