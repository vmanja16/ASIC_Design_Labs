// $Id: $
// File name:   flex_counter.sv
// Created:     2/4/2016
// Author:      Vikram Manja
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: Flexible  counter for counting rollover.
`timescale 1ns / 10ps

module flex_counter
#(
  parameter NUM_CNT_BITS = 4
)
(
  input wire clk,
  input wire n_rst,
  input wire clear,
  input wire count_enable,
  input wire [NUM_CNT_BITS-1:0] rollover_val,
  output wire [NUM_CNT_BITS-1:0] count_out,
  output reg rollover_flag
);

reg [NUM_CNT_BITS-1:0] count;
reg [NUM_CNT_BITS-1:0] next_count;
reg roll;

// REGISTER SETTINGS
always_ff @ (posedge clk, negedge n_rst) begin
  if (n_rst==0) begin
    count<=0; //not sure if it should be 0 or all 1's
    rollover_flag <= 0;
  end
  else begin
  count <= next_count;
  rollover_flag <= roll;
  end
end

// NEXT STATE LOGIC
always_comb begin
  // Check CLEAR
  if (clear) begin
    next_count = 0;
  end
  // CHECK COUNT_ENABLE
  else if (count_enable) begin
    // CHECK ROLLOVER
    if (rollover_flag) begin
      next_count = 1;
    end
    else begin
      next_count = count + 1;
    end
  end
  // DEFAULT
  else begin
    next_count = count;
  end
  // SET ROLLOVER
  if (next_count==rollover_val) begin
    roll = 1'b1;
  end  
  else begin
    roll = 1'b0;
  end

end // ending always_comb block

// OUTPUT ASSIGNMENTS
assign count_out = count;

endmodule