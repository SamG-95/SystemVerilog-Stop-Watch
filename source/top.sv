// FPGA Top Level

`default_nettype none

module top (
  // I/O ports
  input  logic hz100, reset,
  input  logic [20:0] pb,
  output logic [7:0] left, right,
         ss7, ss6, ss5, ss4, ss3, ss2, ss1, ss0,
  output logic red, green, blue,

  // UART ports
  output logic [7:0] txdata,
  input  logic [7:0] rxdata,
  output logic txclk, rxclk,
  input  logic txready, rxready
);
  //stop_watch sw1 (.clk(hz100), .nRst_i(!pb[1]), .button_i(pb[0]), .state(left[2:0]), .time_o(right[4:0]), .digit1(ss0[6:0]), .digit2(ss1[6:0]));
  //stop_watch2 sw2 (.clk(hz100), .nRst_i(!pb[1]), .button_i(pb[0]), .state(left[2:0]), .time_o(right[5:0]), .digit1(ss0[6:0]), .digit2(ss1[6:0]), .digit3(ss2[6:0]), .digit4(ss3[6:0]));
  stop_watch3 sw2 (.clk(hz100), .nRst_i(!pb[1]), .button_i(pb[0]), .state(left[2:0]), .time_o(right[5:0]), .digit1(ss0[6:0]), .digit2(ss1[6:0]), .digit3(ss2[6:0]), .digit4(ss3[6:0]), .digit5(ss4[6:0]), .digit6(ss5[6:0]));
  assign ss2[7] = 1;
  assign ss4[7] = 1;
endmodule
