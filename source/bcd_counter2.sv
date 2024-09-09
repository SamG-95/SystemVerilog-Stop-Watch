module bcd_counter2(
    input logic [2:0] state,
    input logic sec_pulse, clk, nrst,
    output logic [5:0] Combo,
    output logic [3:0] time_o1, time_1o, time_1oo, time_1ooo,
    output logic enable
);
    logic [5:0] nextCombo; 
    logic [5:0] ssCombo, digit2;
    logic [3:0] digit1, digit3, digit4;

    always_ff @(posedge clk, negedge nrst) begin 
        if(nrst == 0) begin
            time_1oo <= 0;
            time_1ooo <= 0;
            Combo <= 0;
        end else begin
            Combo <= nextCombo;
            time_1oo <= digit3;
            time_1ooo <= digit4;
        end
    end

    parameter IDLE = 3'b100;
    parameter CLEAR = 3'b010;
    parameter RUNNING = 3'b001;

    always_comb begin
      digit3 = time_1oo;
      digit4 = time_1ooo;
      enable = 1;
      nextCombo = Combo;
      if(state == CLEAR) begin
        nextCombo = 0;
        enable = 0;
        digit3 = 0;
        digit4 = 0;
      end else if(sec_pulse == 1 && state == RUNNING) begin
        nextCombo = Combo + 1;
      end
      if(time_1oo > 9) begin
        digit4 = time_1ooo + 1;
        digit3 = 0;
      end
      if(Combo > 59) begin
        nextCombo = 0;
        ssCombo = 0;
        digit1 = 4'b0;
        digit2 = 6'b0;
        digit3 = time_1oo + 1;
      end else if (Combo > 49) begin
        ssCombo = Combo + 6;
        digit2 = ssCombo - 56;
        digit1 = 4'b0101;
      end else if (Combo > 39) begin
        ssCombo = Combo + 6;
        digit2 = ssCombo - 46;
        digit1 = 4'b0100;
          end else if (Combo > 29) begin
        ssCombo = Combo + 6;
        digit2 = ssCombo - 36;
        digit1 = 4'b0011;
      end else if (Combo > 19) begin
        ssCombo = Combo + 6;
        digit2 = ssCombo - 26;
        digit1 = 4'b0010;
      end else if (Combo > 9) begin
        ssCombo = Combo + 6;
        digit2 = ssCombo - 16;
        digit1 = 4'b0001;
      end
      else begin
        ssCombo = Combo;
        digit1 = 4'b0000;
        digit2 = ssCombo;
      end
    end
    assign time_1o = digit1;
    assign time_o1 = digit2[3:0]; 


    // always_comb begin
    //   if(Combo > 9) begin
    //     Combo2 = Combo + 6;
    //   end
    //   else begin
    //     Combo2 = Combo;
    //   end
    // end

endmodule