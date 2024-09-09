/*
    Module Name: stop_watch
    Description: Very simple stop watch
*/

module stop_watch (
    input logic clk, nRst_i,
    input logic button_i,
    output logic [2:0] state,
    output logic [4:0] time_o,
    output logic [6:0] digit1, digit2
);
    // Write your code here!
    logic pb_o, sec_pulse, time_1o, enable;
    //logic [2:0] state;
    logic [3:0] time_o1;
    logic [2:0] state_temp;

    sync_edge se1 (.clk(clk), .nRst_i(nRst_i), .button_i(button_i),.pb_o(pb_o));
    fsm fsm1 (.pb_o(pb_o), .clk(clk), .rst(nRst_i), .state(state));
    assign state_temp = state;
    clock_divider cd1 (.clk(clk), .nrst(nRst_i), .start(1), .sec_pulse(sec_pulse));
    bcd_counter bcd1 (.state(state_temp), .sec_pulse(sec_pulse), .clk(clk), .nrst(nRst_i), .Combo(time_o), .time_o1(time_o1), .time_1o(time_1o), .enable(enable));
    ssdec ssd1 (.in(time_o1[3:0]), .enable(enable), .out(digit1));
    ssdec ssd2 (.in({3'b0,time_1o}), .enable(enable), .out(digit2));

endmodule