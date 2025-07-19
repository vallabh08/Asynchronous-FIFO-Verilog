
module synchronizer #(
    parameter WIDTH = 8
) (
    input dest_clk, dest_rstn,
    input [WIDTH-1:0] source_signal,
    output [WIDTH-1:0] sync_signal
);

    reg [WIDTH-1:0] q1_reg;

    always @(posedge dest_clk or negedge dest_rstn) begin
        if (!dest_rstn) begin
            q1_reg <= 0;
            sync_signal <= 0;
        end else begin
            q1_reg <= source_signal;
            sync_signal <= q1_reg;
        end
    end

endmodule
