/*
 * Student starter. Write the state-transition always_comb block and the
 * register-update always_ff block using docs/05-calculator-project.md.
 * This file compiles before the TODOs are complete, but it will not pass simulation.
 */
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

    /*
     * TODO 1: Write the complete next-state always_comb block here.
     *
     * 1. Create an always_comb block.
     * 2. At the beginning of the block, make next_state default to current_state.
     * 3. Add a case statement that checks current_state.
     * 4. Add branches for IDLE, READ_MEMORY, EXECUTE, and FINISH.
     * 5. In IDLE, check command_valid. When it is high, use another case
     *    statement to check the opcode in instruction[7:4].
     * 6. Use the state diagram in the project guide to choose next_state for
     *    each opcode and each current state.
     * 7. Add a default branch that sends the calculator back to IDLE.
     *
     * Use the hints at the bottom of docs/05-calculator-project.md if needed.
     */

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

    /*
     * TODO 2: Write the complete register-update always_ff block here.
     *
     * 1. Create an always_ff block that runs on the rising edge of clk.
     * 2. Add an if statement that checks reset first.
     * 3. When reset is high, set current_state to IDLE and set saved_opcode,
     *    saved_address, saved_memory_data, and accumulator to 0.
     * 4. Add an else branch for normal operation and update current_state
     *    with next_state on every rising edge.
     * 5. Inside the else branch, check whether command_valid and command_ready
     *    are both high. If they are, save the opcode and address portions of
     *    instruction in saved_opcode and saved_address.
     * 6. When current_state is READ_MEMORY, save memory_read_data in
     *    saved_memory_data.
     * 7. When current_state is EXECUTE, use a case statement on saved_opcode.
     *    LOAD copies the saved memory value into the accumulator, ADD adds it,
     *    and SUB subtracts it. STORE and unused opcodes keep the old value.
     * 8. Use nonblocking assignments (<=) for every register update.
     *
     * Use the hints at the bottom of docs/05-calculator-project.md if needed.
     */

endmodule
