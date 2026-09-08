`timescale 1ns/1ps

// Complete this file after the supplied calculator_tb passes.
// Goal: LOAD 1, SUB 0, STORE 4 should put 3 - 8 = -5 into memory[4].
module student_testbench;

    logic clk;
    logic reset;
    logic command_valid;
    logic command_ready;
    logic [7:0] instruction;

    logic signed [7:0] memory_read_data;
    logic memory_write_enable;
    logic [3:0] memory_address;
    logic signed [7:0] memory_write_data;

    logic signed [7:0] accumulator;
    logic command_done;

    /*
     * TODO 1: Instantiate the calculator module here and name the instance dut.
     *
     * 1. Start a calculator module instantiation named dut.
     * 2. Connect every calculator port using named port connections.
     * 3. Each port connects to the testbench signal with the same name.
     * 4. End the final connection and close the instantiation correctly.
     *
     * Use the hint at the bottom of the "Write your own testbench" section in
     * docs/06-simulation-testbenches.md if needed.
     */

    data_memory memory (
        .clk          (clk),
        .write_enable (memory_write_enable),
        .address      (memory_address),
        .write_data   (memory_write_data),
        .read_data    (memory_read_data)
    );

    // Provided: a 10 ns clock period (5 ns low, 5 ns high).
    initial begin
        clk = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end

    initial begin
        #2000;
        $fatal(1, "TIMEOUT: check your reset, stimulus, ready, and done.");
    end

    initial begin
        /*
         * TODO 2: Initialize reset, command_valid, and instruction.
         * Hold reset high for two rising edges. After the second rising edge,
         * wait #1 before releasing reset so the DUT's updates have settled.
         */

        /*
         * TODO 3: Send LOAD 1. See docs/06-simulation-testbenches.md and
         * calculator_tb.sv for the pattern.
         * Wait for a rising edge, then wait #1 before checking command_ready.
         * Set instruction and raise command_valid while ready is high.
         * Keep them stable through the next rising edge, wait #1, and then
         * lower command_valid. Check command_done after rising edges and #1.
         */

        // TODO 4: Repeat the same pattern for SUB 0 and STORE 4.

        /*
         * TODO 5: Check memory.memory[4] against -8'sd5 using !==.
         * Print an error and call $fatal(1, "...") if they do not match.
         * Otherwise print STUDENT TEST PASSED and call $stop.
         * Replace the temporary stop below with your check.
         */
        $fatal(1, "TODO: complete student_testbench.sv before running it.");
    end

endmodule
