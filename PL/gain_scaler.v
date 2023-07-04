`timescale 1ns / 1ps
module gain_scaler(
    input                clk,
    input       [8:0]    gain_fsk,
    input       [8:0]    gain_psk,
    output reg  [8:0]    scaled_gain_fsk,
    output reg  [8:0]    scaled_gain_psk
);

always @(posedge clk) begin
    scaled_gain_fsk <= gain_fsk * 5;   // scales the gain value from PS side
    scaled_gain_psk <= gain_psk * 5;
end

endmodule
