// Student starter. Write the state-transition always_comb block and the
// register-update always_ff block using docs/05-calculator-project.md.
// This file compiles before the TODOs are complete, but it will not pass simulation.
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

    // TODO 1: Write the complete next-state always_comb block here.
    // Use the state diagram and hints in docs/05-calculator-project.md.

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

    // TODO 2: Write the complete register-update always_ff block here.
    // It must handle reset, the state register, accepted instructions,
    // memory reads, and accumulator operations. The project guide has hints.

endmodule
