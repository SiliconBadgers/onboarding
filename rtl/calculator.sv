/*
 * Student starter. Write the state-transition always_comb block, the
 * output-control always_comb block, and the register-update always_ff block
 * using docs/05-calculator-project.md.
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
    logic [3:0] saved_operand;
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
     * 6. Send LOAD, ADD, and SUB to READ_MEMORY. Send STORE and ADDI directly
     *    to EXECUTE. Send unused opcodes to FINISH.
     * 7. Advance READ_MEMORY to EXECUTE, EXECUTE to FINISH, and FINISH to IDLE.
     * 8. Add a default branch that sends the calculator back to IDLE.
     *
     * Use the hints at the bottom of docs/05-calculator-project.md if needed.
     */

    /*
     * TODO 2: Write the complete output-control always_comb block here.
     *
     * 1. Create another always_comb block.
     * 2. Default command_ready, command_done, and memory_write_enable to 0.
     * 3. Always drive memory_address from saved_operand and memory_write_data
     *    from accumulator.
     * 4. Add an if statement so the controls below are asserted only when
     *    reset is low.
     * 5. In IDLE, raise command_ready.
     * 6. In EXECUTE, raise memory_write_enable only when saved_opcode is STORE.
     * 7. In FINISH, raise command_done.
     *
     * Use the hints at the bottom of docs/05-calculator-project.md if needed.
     */

    /*
     * TODO 3: Write the complete register-update always_ff block here.
     *
     * 1. Create an always_ff block that runs on the rising edge of clk.
     * 2. Add an if statement that checks reset first.
     * 3. When reset is high, set current_state to IDLE and set saved_opcode,
     *    saved_operand, saved_memory_data, and accumulator to 0.
     * 4. Add an else branch for normal operation and update current_state
     *    with next_state on every rising edge.
     * 5. Inside the else branch, check whether command_valid and command_ready
     *    are both high. If they are, save the opcode and operand portions of
     *    instruction in saved_opcode and saved_operand.
     * 6. When current_state is READ_MEMORY, save memory_read_data in
     *    saved_memory_data.
     * 7. When current_state is EXECUTE, use a case statement on saved_opcode.
     *    LOAD copies saved_memory_data into the accumulator, ADD adds it, SUB
     *    subtracts it, and ADDI adds the sign-extended signed four-bit
     *    saved_operand. STORE and unused opcodes keep the old value.
     * 8. Use nonblocking assignments (<=) for every register update.
     *
     * Use the hints at the bottom of docs/05-calculator-project.md if needed.
     */

endmodule
