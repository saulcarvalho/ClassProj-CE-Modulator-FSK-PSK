`timescale 1ns / 1ps

module psk_mapper(
    input                   clk,
    input                   mode,
    input       [1:0]       sel,  
    input       [15:0]      freq_in,
    output reg  [15:0]      freq_out,
    output reg  [15:0]      phase_out
); 
    
parameter [15:0] phase_step   = 16384;
parameter [15:0] phase_offset = 0;

always @(posedge clk) begin
    freq_out = freq_in;

    if (mode == 1'b0) begin                // 2PSK
        case(sel)
            1'b0: phase_out = phase_offset + phase_step * 0;      // 0º         <-    because of dds compiler resolution  
            1'b1: phase_out = phase_offset + phase_step * 2;      // 180º
            default: phase_out = phase_offset + phase_step * 0;   // 0º
        endcase
    end else if (mode == 1'b1) begin           // 4PSK - grey encoded
        case(sel)
            2'b00: phase_out = phase_offset + phase_step * 0;     // 0º        <-    because of dds compiler resolution  
            2'b01: phase_out = phase_offset + phase_step * 1;     // 90º             (2^16/360) * 90 = 16384
            2'b10: phase_out = phase_offset + phase_step * 3;     // 270º
            2'b11: phase_out = phase_offset + phase_step * 2;     // 180º
            default: phase_out = phase_offset + phase_step * 0;   // 0º  
        endcase
    end
end
      
endmodule
