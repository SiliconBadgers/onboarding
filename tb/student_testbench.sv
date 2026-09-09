`timescale 1ns/1ps

// Complete this file after the supplied calculator_tb passes.
// Goal: LOAD 1, ADDI -2, STORE 4 should put 3 + (-2) = 1 into memory[4].
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
         *
         * 1. Set reset to 1.
         * 2. Set command_valid to 0 so no command is sent during reset.
         * 3. Set instruction to 8'h00 so it does not begin as an unknown X.
         * 4. Wait for two rising clock edges using repeat and @(posedge clk).
         * 5. Wait #1 after the second edge so register updates settle.
         * 6. Set reset to 0.
         */

        /*
         * TODO 3: Send LOAD 1, encoded as 8'h01.
         *
         * Use this same command pattern for every instruction:
         * 1. Wait for a rising edge, then wait #1.
         * 2. If command_ready is not 1 yet, keep waiting for rising edges and
         *    #1 delays until it becomes 1.
         * 3. Set instruction to 8'h01 and set command_valid to 1.
         * 4. Keep both inputs unchanged through the next rising edge. That is
         *    the edge where valid and ready are both 1, so LOAD is accepted.
         * 5. Wait #1 after that edge, then set command_valid back to 0.
         * 6. While command_done is not 1, wait for another rising edge and
         *    then #1 before checking it again.
         * 7. Once done is 1, LOAD has finished and accumulator should be 3.
         *
         * See calculator_tb.sv if you need to see this pattern as code.
         */

        /*
         * TODO 4: Send ADDI -2, then STORE 4.
         *
         * ADDI -2:
         * 1. Wait until command_ready is 1 using rising edges and #1 delays.
         * 2. Present 8'h4E and raise command_valid.
         * 3. Keep them stable through the next rising edge, wait #1, and lower
         *    command_valid.
         * 4. Wait through rising edges and #1 delays until command_done is 1.
         * 5. The accumulator should now contain 1 because 3 + (-2) = 1.
         *
         * STORE 4:
         * 6. Wait until command_ready is 1 again.
         * 7. Present 8'h34 and raise command_valid.
         * 8. Keep them stable through the next rising edge, wait #1, and lower
         *    command_valid.
         * 9. Wait through rising edges and #1 delays until command_done is 1.
         *
         * Encoding reminder: 8'h4E is opcode 0100 followed by signed immediate
         * 1110 (-2). 8'h34 is STORE opcode 0011 followed by address 0100 (4).
         */

        /*
         * TODO 5: Check the handshake and stored result.
         *
         * 1. At this point command_done is 1 because STORE just finished.
         * 2. Wait for one more rising edge and then #1.
         * 3. Check that command_done is now 0 and command_ready is now 1. If
         *    either value is wrong, call $fatal with a helpful message.
         * 4. Check memory.memory[4] against 8'sd1 using !==. The !== operator
         *    also treats an unknown X as a failure.
         * 5. If the memory value is wrong, call $fatal with the expected and
         *    actual values.
         * 6. If every check passed, print STUDENT TEST PASSED with $display.
         * 7. Call $stop so Run All pauses without a finish confirmation.
         * 8. Delete the temporary $fatal line below after adding your checks.
         */
        $fatal(1, "TODO: complete student_testbench.sv before running it.");
    end

endmodule
