module counter #(
    parameter          WIDTH=4
) (
    input              clk_i,
    input              rst_i,
    output [WIDTH-1:0] cnt_o
);

    reg [WIDTH-1:0] cnt;

    always @(posedge clk_i) begin
        if (rst_i == 1'b1)
            cnt <= {WIDTH{1'b0}};
        else
            cnt <= cnt + 1'b1;
    end

    assign cnt_o = cnt;

endmodule
