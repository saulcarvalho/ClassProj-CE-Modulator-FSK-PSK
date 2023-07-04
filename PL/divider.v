`timescale 1ns / 1ps

module divider(
    input                       clk,
    input wire signed [15:0]    signal_in,
    output reg signed [15:0]    sig_gain_out
);
    
always @(posedge clk) begin
    sig_gain_out = (signal_in / 560);     // to bring the actual max peak integer of the signal output of the dds to around 58 instead of 32767
end

endmodule
