/*
    Module Name: stop_watch
    Description: Very simple stop watch
*/

module stop_watch3 (
    input logic clk, nRst_i,
    input logic button_i,
    output logic [2:0] state,
    output logic [5:0] time_o,
    output logic [6:0] digit1, digit2, digit3, digit4, digit5, digit6
);
    // Write your code here!
    logic pb_o, sec_pulse, enable;
    //logic [2:0] state;
    logic [3:0] time_o1, time_1o, time_1oo, time_1ooo, time_1oooo, time_1ooooo;
    logic [2:0] state_temp;

    sync_edge se1 (.clk(clk), .nRst_i(nRst_i), .button_i(button_i),.pb_o(pb_o));
    fsm fsm1 (.pb_o(pb_o), .clk(clk), .rst(nRst_i), .state(state));
    assign state_temp = state;
    clock_divider cd1 (.clk(clk), .nrst(nRst_i), .start(1), .sec_pulse(sec_pulse));
    bcd_counter3 bcd3 (.state(state_temp), .sec_pulse(sec_pulse), .clk(clk), .nrst(nRst_i), .Combo(time_o), .time_o1(time_o1), .time_1o(time_1o), .time_1oo(time_1oo), .time_1ooo(time_1ooo), .time_1oooo(time_1oooo), .time_1ooooo(time_1ooooo), .enable(enable));
    ssdec ssd1 (.in(time_o1[3:0]), .enable(enable), .out(digit1));
    ssdec ssd2 (.in(time_1o[3:0]), .enable(enable), .out(digit2));
    ssdec ssd3 (.in(time_1oo[3:0]), .enable(enable), .out(digit3));
    ssdec ssd4 (.in(time_1ooo[3:0]), .enable(enable), .out(digit4));
    ssdec ssd5 (.in(time_1oooo[3:0]), .enable(enable), .out(digit5));
    ssdec ssd6 (.in(time_1ooooo[3:0]), .enable(enable), .out(digit6));

endmodule