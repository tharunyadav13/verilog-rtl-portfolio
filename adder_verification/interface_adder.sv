`timescale 1ns/1ps

interface add_if(input logic clk);
  logic reset;            // active-low reset: 0=reset, 1=run
  logic [3:0] A;
  logic [3:0] B;
  logic [4:0] out;
endinterface
