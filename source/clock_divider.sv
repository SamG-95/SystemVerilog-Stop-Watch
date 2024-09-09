module clock_divider (
    input logic clk, nrst, start,
    output logic sec_pulse
);
    // Write your code here!
    logic [6:0] count, next_count;

    always_ff @(posedge clk, negedge nrst) begin 
        if(nrst == 0) begin
            count <= 0;
        end else begin
            count <= next_count;
        end
    end

    always_comb begin
        sec_pulse = 0;
        next_count = count;
        if(start) begin
            if(count != 99) begin
                next_count = count + 1;
            end else begin
                sec_pulse = 1;
                next_count = 0;
            end
        end else begin
            next_count = 0;
        end
    end

endmodule