`timescale 1ns / 1ps

module monsterplexer(
    input clk,
    input signed [15:0] data_in0,
    input signed [15:0] data_in1,
    input signed [31:0] data_in2,
    input signed [31:0] data_in3,
    input signed [31:0] data_in4,
    input signed [31:0] data_in5,
    input        [1:0]  data_in6,
    input        [1:0]  data_in7,
    input               mode_fsk,
    input               mode_psk,
    input        [2:0]  sel,
    output reg signed [11:0] data_out1,
    output reg signed [11:0] data_out2
);

reg [31:0] temp_out1, temp_out2;
reg [11:0] rescale_datain6, rescale_datain7;



// Rescale input bitstreams (data_in6 and data_in7) for DAC - 12 bit
always @(posedge clk) begin
    // bitstream rescaler data_in6 - fsk
    if (mode_fsk == 1'b0) begin            // fsk M=2 
        if (data_in6 == 2'd0) begin
            rescale_datain6 = 0;
        end else if (data_in6 == 2'd1) begin
            rescale_datain6 = 4095;
        end
    end else if (mode_fsk == 1'b1) begin   // fsk M=4
        if (data_in6 == 2'd0) begin
            rescale_datain6 = 0;
        end else if (data_in6 == 2'd1) begin
            rescale_datain6 = 1024;
        end else if (data_in6 == 2'd2) begin
            rescale_datain6 = 2048;
        end else if (data_in6 == 2'd3) begin
            rescale_datain6 = 4095;
        end
    end
    
    // bitstream rescaler data_in7 - psk
    if (mode_psk == 1'b0) begin            // psk M=2
        if (data_in7 == 2'd0) begin
            rescale_datain7 = 0;
        end else if (data_in7 == 2'd1) begin
            rescale_datain7 = 4095;
        end
    end else if (mode_psk == 1'b1) begin   // psk M=4
        if (data_in7 == 2'd0) begin
            rescale_datain7 = 0;
        end else if (data_in7 == 2'd1) begin
            rescale_datain7 = 1024;
        end else if (data_in7 == 2'd2) begin
            rescale_datain7 = 2048;
        end else if (data_in7 == 2'd3) begin
            rescale_datain7 = 4095;
        end
    end
end



// CHANNEL 1 OUTPUT
always @(posedge clk) begin
    case(sel)
        3'b000: temp_out1 = {{16{data_in0[15]}}, data_in0[15:0]};
        3'b001: temp_out1 = {{16{data_in1[15]}}, data_in1[15:0]};
        3'b010: temp_out1 = data_in2;
        3'b011: temp_out1 = data_in3;
        3'b100: temp_out1 = data_in4;
        3'b101: temp_out1 = data_in5;
        3'b110: temp_out1 = {rescale_datain6[11:0]};
        3'b111: temp_out1 = {rescale_datain7[11:0]};
        default: temp_out1 = {{16{data_in0[15]}}, data_in0[15:0]};
    endcase
    
    case(sel)
        3'b000: data_out1 = $unsigned((4096/2) + temp_out1[11:0]); // half level + sliced signal
        3'b001: data_out1 = $unsigned((4096/2) + temp_out1[11:0]); // half level + sliced signal
        3'b010: data_out1 = $unsigned((4096/2) + temp_out1[11:0]); // half level + sliced signal
        3'b011: data_out1 = $unsigned((4096/2) + temp_out1[11:0]); // half level + sliced signal
        3'b100: data_out1 = $unsigned((4096/2) + temp_out1[11:0]); // half level + sliced signal
        3'b101: data_out1 = $unsigned((4096/2) + temp_out1[11:0]); // half level + sliced signal
        3'b110: data_out1 = temp_out1[11:0];    // reaffirm
        3'b111: data_out1 = temp_out1[11:0];    // reaffirm
        default: data_out1 = $unsigned((4096/2) + temp_out1[11:0]); // half level + sliced signal
    endcase 
end



// CHANNEL 2 OUTPUT
always @(posedge clk) begin  
    case(sel)
        3'b000: temp_out2 = {{16{data_in1[15]}}, data_in1[15:0]};
        3'b001: temp_out2 = data_in2;
        3'b010: temp_out2 = data_in3;
        3'b011: temp_out2 = data_in4;
        3'b100: temp_out2 = data_in5;
        3'b101: temp_out2 = {rescale_datain6[11:0]};
        3'b110: temp_out2 = {rescale_datain7[11:0]};
        3'b111: temp_out2 = {{16{data_in0[15]}}, data_in0[15:0]};
        default: temp_out2 = {{16{data_in1[15]}}, data_in1[15:0]};
    endcase   
    
    case(sel)
        3'b000: data_out2 = $unsigned((4096/2) + temp_out2[11:0]); // half level + sliced signal
        3'b001: data_out2 = $unsigned((4096/2) + temp_out2[11:0]); // half level + sliced signal
        3'b010: data_out2 = $unsigned((4096/2) + temp_out2[11:0]); // half level + sliced signal
        3'b011: data_out2 = $unsigned((4096/2) + temp_out2[11:0]); // half level + sliced signal
        3'b100: data_out2 = $unsigned((4096/2) + temp_out2[11:0]); // half level + sliced signal
        3'b101: data_out2 = temp_out2[11:0];    // just slicing
        3'b110: data_out2 = temp_out2[11:0];    // just slicing
        3'b111: data_out2 = $unsigned((4096/2) + temp_out2[11:0]);  // half level + sliced signal
        default: data_out2 = $unsigned((4096/2) + temp_out2[11:0]); // half level + sliced signal
    endcase
end

endmodule
