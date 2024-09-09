/*
    Module Name: fsm.sv
    Description: Finite state machine 
    RUNNING: 001
    IDLE: 010
    CLEAR: 100
*/

module fsm (

    input logic pb_o, clk, rst,         // Input representing the button press
    output logic [2:0] state // Outputs representing control signals
);

logic [4:0] count; // Counter for time tracking
logic [2:0] next_state; // State variables

// states
parameter IDLE = 3'b100;
parameter CLEAR = 3'b010;
parameter RUNNING = 3'b001;

// State transition logic
always_ff @(posedge clk or negedge rst) begin
    if (~rst) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

always_comb begin 
    case (state)
        IDLE: begin
            if (pb_o) begin
                next_state = CLEAR;
            end else begin
                next_state = IDLE;
            end
        end
        CLEAR: begin
            if (pb_o) begin
                next_state = RUNNING;
            end else begin
                next_state = CLEAR;
            end
        end
        RUNNING: begin
            if (pb_o) begin
                next_state = IDLE;
            end else begin
                next_state = RUNNING;
            end
        end
        default: next_state = IDLE; // Default state is IDLE
    endcase
end



endmodule


