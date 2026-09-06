// Student starter. Complete TODO 1, TODO 2, and TODO 3 using the README.
// This file compiles before the TODOs are complete; it will not pass simulation.
module calculator (
    input  logic                   clk,
    input  logic                   reset,

    input  logic                   command_valid,
    output logic                   command_ready,
    input  logic [7:0]             instruction,

    input  logic signed [7:0]      memory_read_data,
    output logic                   memory_write_enable,
    output logic [3:0]             memory_address,
    output logic signed [7:0]      memory_write_data,

    output logic signed [7:0]      accumulator,
    output logic                   command_done
);

    // These enum names label the four states; no numeric parameters are needed.
    typedef enum logic [1:0] {
        IDLE,
        READ_MEMORY,
        EXECUTE,
        FINISH
    } state_t;

    state_t current_state;
    state_t next_state;

    logic [3:0] saved_opcode;
    logic [3:0] saved_address;
    logic signed [7:0] saved_memory_data;

    always_comb begin
        next_state = current_state;

        // TODO 1: Complete the transitions described in the README.
        // IDLE: if a command is valid, inspect instruction[7:4].
        //       LOAD/ADD/SUB need READ_MEMORY; STORE goes to EXECUTE;
        //       an unused opcode goes directly to FINISH.
        // READ_MEMORY -> EXECUTE -> FINISH -> IDLE.
        // Keep the default branch for recovery from an invalid state.
        case (current_state)
            IDLE: begin
                next_state = IDLE;           // Replace this placeholder.
            end
            READ_MEMORY: begin
                next_state = READ_MEMORY;    // Replace this placeholder.
            end
            EXECUTE: begin
                next_state = EXECUTE;        // Replace this placeholder.
            end
            FINISH: begin
                next_state = FINISH;         // Replace this placeholder.
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // Provided: outputs depend on the current state and stored values.
    always_comb begin
        command_ready       = 1'b0;
        command_done        = 1'b0;
        memory_write_enable = 1'b0;
        memory_address      = saved_address;
        memory_write_data   = accumulator;

        // Suppress a pending write immediately when reset is asserted.
        if (!reset) begin
            if (current_state == IDLE) begin
                command_ready = 1'b1;
            end

            if ((current_state == EXECUTE) && (saved_opcode == 4'b0011)) begin
                memory_write_enable = 1'b1;
            end

            if (current_state == FINISH) begin
                command_done = 1'b1;
            end
        end
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            current_state     <= IDLE;
            saved_opcode      <= 4'b0000;
            saved_address     <= 4'd0;
            saved_memory_data <= 8'sd0;
            accumulator       <= 8'sd0;
        end
        else begin
            current_state <= next_state;

            // Provided: split and save an accepted instruction.
            // Later input changes must not change the command being executed.
            if (command_valid && command_ready) begin
                saved_opcode  <= instruction[7:4];
                saved_address <= instruction[3:0];
            end

            // TODO 2: At the end of READ_MEMORY, save memory_read_data.
            // Use an if statement and a nonblocking assignment (<=).

            // TODO 3: In EXECUTE, use a case statement on saved_opcode.
            // LOAD copies saved_memory_data into the accumulator.
            // ADD adds saved_memory_data to the accumulator.
            // SUB subtracts saved_memory_data from the accumulator.
            // STORE and unused opcodes leave the accumulator unchanged.
            // The provided output logic already handles writing memory.
        end
    end

endmodule
