
module wptr_full #(
    parameter ADDR_SIZE = 4
) (
    input wr_clk,
    input wr_rstn,
    input wr_en,
    input [ADDR_SIZE:0] rd_ptr_gray_sync,

    output reg wfull,
    output [ADDR_SIZE-1:0] waddr,
    output [ADDR_SIZE:0] wptr_gray
);

    reg [ADDR_SIZE:0] wptr_bin;
    wire wfull_next;

    assign waddr = wptr_bin[ADDR_SIZE-1:0];
    assign wptr_gray = (wptr_bin >> 1) ^ wptr_bin;

    wire [ADDR_SIZE:0] wptr_bin_next = wptr_bin + (wr_en & ~wfull);

    wire [ADDR_SIZE:0] wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;

    // Calculate the next state of the full flag based on the next pointer state.
    assign wfull_next = (wptr_gray_next == {~rd_ptr_gray_sync[ADDR_SIZE], ~rd_ptr_gray_sync[ADDR_SIZE-1], rd_ptr_gray_sync[ADDR_SIZE-2:0]});

    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            wfull <= 0;
        end
        else begin
            wfull <= wfull_next;
        end  
    end

    // logic to update all state registers on the clock edge.
    always @(posedge wr_clk or negedge wr_rstn) begin
        if (!wr_rstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;    
        end
    end

endmodule
