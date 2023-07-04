`timescale 1ns / 1ps

module fsk_mapper(
    input                   clk,
    input       [1:0]       sel,
    input       [15:0]      start_f,
    input       [15:0]      step_f,
    output reg  [15:0]      freq_out
);   

parameter [15:0] external_step_frequency = 0;
reg [15:0] step;
    
always @(posedge clk) begin
    if (external_step_frequency == 0) begin // step frequency = half of start frequency 
        step = start_f / 2;
    end else begin                          // external step frequency
        step = step_f;
    end
    
    case(sel)
        2'd00: freq_out = start_f + 0*step;       // 399.684 kHz      (689.11  * 580) = 399 684 Hz
        2'b01: freq_out = start_f + 1*step;       
        2'b10: freq_out = start_f + 2*step;
        2'b11: freq_out = start_f + 3*step;
        default: freq_out = start_f + 0*step;
    endcase
end

endmodule


