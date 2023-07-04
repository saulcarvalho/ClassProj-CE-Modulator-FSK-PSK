`timescale 1ns / 1ps

module sign_32bit_to_unsign_12bit (
  input signed  [31:0] input_signal,
  output reg    [11:0] output_signal
);
  
  always @(*) begin
        output_signal = $unsigned((4096/2) + input_signal[11:0]); // half level + positive signal
  end

endmodule