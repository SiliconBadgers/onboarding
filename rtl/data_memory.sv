module data_memory (
    input  logic                   clk,
    input  logic                   write_enable,
    input  logic [3:0]             address,
    input  logic signed [7:0]      write_data,
    output logic signed [7:0]      read_data
);

    // 16 signed bytes. The initial values are provided for this simulation lab.
    // This initial block is not a universal ASIC power-on/reset mechanism.
    logic signed [7:0] memory [0:15] = '{8'sd8, 8'sd3, 14{8'sd0}};

    // Asynchronous read: changing address changes read_data without a clock.
    always_comb begin
        read_data = memory[address];
    end

    // Synchronous write: memory changes only on a rising edge with write_enable.
    always_ff @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= write_data;
        end
    end

endmodule
