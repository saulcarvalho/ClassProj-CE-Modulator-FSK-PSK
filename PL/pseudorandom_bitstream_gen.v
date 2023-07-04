`timescale 1ns / 1ps

module random_bitstream_generator(
    input               clk,         // 44.1 kHz clock
    input               mode,        // allows to change the size of the words in the bitstream
    output reg [1:0]    data_out     // output bitstream of 1bit or 2bit words, depending on mode input
);

reg [31:0] seed, bit;
parameter [31:0] seed_value = 165;
parameter seed_arrangement  = 1'b0;
parameter simulation        = 1'b0;

initial begin
    if (simulation == 0) begin
        seed = seed_value;
    end else begin
        seed = urandom();
    end
end

always @(posedge clk) begin
    // Fibonacci LFSR seed examples
    if (simulation == 0) begin
        if (seed_arrangement == 1) begin
            bit = seed[27] ^ seed[17] ^ seed[7] + 1;
        end else begin
            bit = seed[25] ^ seed[15] ^ seed[5] + 1;
        end
        seed = {bit[0], seed[31:1]};   // discard the LSB of seed, set the MSB of bit as MSB of seed
    end
    
    // change between 1bit or 2bit word bitstreams
    if (mode == 1'b0) begin
        data_out = {1'b0, seed[0:0]};
    end else if (mode == 1'b1) begin
        data_out = seed[1:0];
    end else begin
        data_out = 2'b00;
    end
end

endmodule