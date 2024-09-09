/*
    Module Name: stop_watch
    Description: Very simple stop watch
*/
module sync_edge (
    input logic clk, nRst_i, button_i,
    output logic pb_o
);
    logic sync, pb_1, pb_2;
    // Write your code here!
    always_ff@(posedge clk, negedge nRst_i) begin
        if(!nRst_i) begin
            sync<=0;
            pb_1<=0;
            pb_2<=0;
        end else begin
            sync<=button_i;
            pb_1<=sync;
            pb_2<=pb_1;
        end
    end

    always_comb begin
        if(pb_1 && !pb_2) begin
            pb_o = 1;
        end else begin
            pb_o = 0;
        end
    end
endmodule

// module sync_edge (
//     input logic clk, nRst_i, button_i,
//     output logic pb_o
// );
//     logic [1:0] sync;
//     // Write your code here!
//     always_ff@(posedge clk, negedge nRst_i) begin
//         if(!nRst_i) begin
//             sync<=0;
//         end else begin
//             sync[0]<=button_i;
//             sync[1]<=sync[0];
//         end
//     end
//     assign pb_o = sync[0] && ~sync[1];

// endmodule