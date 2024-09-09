module bcd_counter(
    input logic [2:0] state,
    input logic sec_pulse, clk, nrst,
    output logic [4:0] Combo,
    output logic [3:0] time_o1,
    output logic time_1o, enable
);
    logic [4:0] nextCombo, ssCombo;

    always_ff @(posedge clk, negedge nrst) begin 
        if(nrst == 0) begin
            Combo <= 0;
        end else begin
            Combo <= nextCombo;
        end
    end

    parameter IDLE = 3'b100;
    parameter CLEAR = 3'b010;
    parameter RUNNING = 3'b001;

    always_comb begin
      enable = 1;
      nextCombo = Combo;
      if(state == CLEAR) begin
        nextCombo = 0;
        enable = 0;
      end else if(sec_pulse == 1 && state == RUNNING) begin
        nextCombo = Combo + 1;
      end
      if(Combo > 9) begin
        ssCombo = Combo + 6;
      end
      else begin
        ssCombo = Combo;
      end
    end
    assign time_1o = ssCombo[4];
    assign time_o1 = ssCombo[3:0]; 
endmodule