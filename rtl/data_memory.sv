module data_memory (
    input  logic                   clk,
    input  logic                   write_enable,
    input  logic [3:0]             address,
    input  logic signed [7:0]      write_data,
    output logic signed [7:0]      read_data
);

    // 16 signed bytes. The initial values are provided for this simulation lab.
    // This initial block is not a universal ASIC power-on/reset mechanism.
    logic signed [7:0] memory [0:15];

    initial begin
        memory[0]  = 8'sd8;
        memory[1]  = 8'sd3;
        memory[2]  = 8'sd0;
        memory[3]  = 8'sd0;
        memory[4]  = 8'sd0;
        memory[5]  = 8'sd0;
        memory[6]  = 8'sd0;
        memory[7]  = 8'sd0;
        memory[8]  = 8'sd0;
        memory[9]  = 8'sd0;
        memory[10] = 8'sd0;
        memory[11] = 8'sd0;
        memory[12] = 8'sd0;
        memory[13] = 8'sd0;
        memory[14] = 8'sd0;
        memory[15] = 8'sd0;
    end

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
