`timescale 1ns/1ps

module calculator_tb;

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

    calculator dut (
        .clk                 (clk),
        .reset               (reset),
        .command_valid       (command_valid),
        .command_ready       (command_ready),
        .instruction         (instruction),
        .memory_read_data    (memory_read_data),
        .memory_write_enable (memory_write_enable),
        .memory_address      (memory_address),
        .memory_write_data   (memory_write_data),
        .accumulator         (accumulator),
        .command_done        (command_done)
    );

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

    integer error_count;

    // Run All must stop even if a broken controller never raises done.
    initial begin
        #2000;
        $fatal(1, "TIMEOUT: no completed test. Check reset, transitions, ready, and done.");
    end

    initial begin
        reset         = 1'b1;
        command_valid = 1'b0;
        instruction   = 8'h00;
        error_count   = 0;

        // Change test inputs on falling edges, away from the DUT's rising edge.
        repeat (2) @(negedge clk);
        reset = 1'b0;

        // LOAD 0
        @(negedge clk);
        while (command_ready !== 1'b1) begin
            @(negedge clk);
        end
        instruction   = 8'h00;
        command_valid = 1'b1;
        @(negedge clk); // A rising edge has accepted the instruction.
        command_valid = 1'b0;
        while (command_done !== 1'b1) begin
            @(negedge clk);
        end
        if (accumulator !== 8'sd8) begin
            $display("ERROR after LOAD 0: expected accumulator = 8, got %0d", accumulator);
            error_count = error_count + 1;
        end

        // ADD 1
        @(negedge clk);
        while (command_ready !== 1'b1) begin
            @(negedge clk);
        end
        instruction   = 8'h11;
        command_valid = 1'b1;
        @(negedge clk); // A rising edge has accepted the instruction.
        command_valid = 1'b0;
        while (command_done !== 1'b1) begin
            @(negedge clk);
        end
        if (accumulator !== 8'sd11) begin
            $display("ERROR after ADD 1: expected accumulator = 11, got %0d", accumulator);
            error_count = error_count + 1;
        end

        // STORE 2
        @(negedge clk);
        while (command_ready !== 1'b1) begin
            @(negedge clk);
        end
        instruction   = 8'h32;
        command_valid = 1'b1;
        @(negedge clk); // A rising edge has accepted the instruction.
        command_valid = 1'b0;
        while (command_done !== 1'b1) begin
            @(negedge clk);
        end
        if (accumulator !== 8'sd11) begin
            $display("ERROR after STORE 2: expected accumulator = 11, got %0d", accumulator);
            error_count = error_count + 1;
        end

        if (memory.memory[2] !== 8'sd11) begin
            $display("ERROR: expected memory[2] = 11, got %0d", memory.memory[2]);
            error_count = error_count + 1;
        end
        else begin
            $display("PASS: 8 + 3 = %0d", memory.memory[2]);
        end

        // LOAD 0
        @(negedge clk);
        while (command_ready !== 1'b1) begin
            @(negedge clk);
        end
        instruction   = 8'h00;
        command_valid = 1'b1;
        @(negedge clk); // A rising edge has accepted the instruction.
        command_valid = 1'b0;
        while (command_done !== 1'b1) begin
            @(negedge clk);
        end
        if (accumulator !== 8'sd8) begin
            $display("ERROR after LOAD 0: expected accumulator = 8, got %0d", accumulator);
            error_count = error_count + 1;
        end

        // SUB 1
        @(negedge clk);
        while (command_ready !== 1'b1) begin
            @(negedge clk);
        end
        instruction   = 8'h21;
        command_valid = 1'b1;
        @(negedge clk); // A rising edge has accepted the instruction.
        command_valid = 1'b0;
        while (command_done !== 1'b1) begin
            @(negedge clk);
        end
        if (accumulator !== 8'sd5) begin
            $display("ERROR after SUB 1: expected accumulator = 5, got %0d", accumulator);
            error_count = error_count + 1;
        end

        // STORE 3
        @(negedge clk);
        while (command_ready !== 1'b1) begin
            @(negedge clk);
        end
        instruction   = 8'h33;
        command_valid = 1'b1;
        @(negedge clk); // A rising edge has accepted the instruction.
        command_valid = 1'b0;
        while (command_done !== 1'b1) begin
            @(negedge clk);
        end
        if (accumulator !== 8'sd5) begin
            $display("ERROR after STORE 3: expected accumulator = 5, got %0d", accumulator);
            error_count = error_count + 1;
        end

        if (memory.memory[3] !== 8'sd5) begin
            $display("ERROR: expected memory[3] = 5, got %0d", memory.memory[3]);
            error_count = error_count + 1;
        end
        else begin
            $display("PASS: 8 - 3 = %0d", memory.memory[3]);
        end

        // Confirm that done is a pulse and the controller becomes ready again.
        @(negedge clk);
        if ((command_done !== 1'b0) || (command_ready !== 1'b1)) begin
            $display("ERROR: expected ready = 1 and done = 0 after FINISH.");
            error_count = error_count + 1;
        end

        if (error_count != 0) begin
            $fatal(1, "TEST FAILED with %0d error(s)", error_count);
        end

        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule
