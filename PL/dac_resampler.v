`timescale 1ns / 1ps

module dac_resampler(
    input               clk,
    input       [11:0]  signal_in1,
    input       [11:0]  signal_in2,
    output reg  [11:0]  signal_out1,
    output reg  [11:0]  signal_out2
);
    
    always @(posedge clk) begin
        signal_out1 <= signal_in1;
        signal_out2 <= signal_in2;
    end
endmodule
