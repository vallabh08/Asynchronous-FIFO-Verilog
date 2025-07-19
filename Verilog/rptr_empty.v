
module rptr_empty #(
    parameter ADDR_SIZE = 4
) (
    input rd_clk,
    input rd_rstn,
    input rd_en,
    input [ADDR_SIZE:0] wr_ptr_gray_sync,

    output reg rempty,
    output [ADDR_SIZE-1:0] raddr,
    output [ADDR_SIZE:0] rptr_gray
);

    reg [ADDR_SIZE:0] rptr_bin;
    wire rempty_next;

    assign raddr = rptr_bin[ADDR_SIZE-1:0];
    assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

    wire [ADDR_SIZE:0] rptr_bin_next = rptr_bin + (rd_en & ~rempty);

    wire [ADDR_SIZE:0] rptr_gray_next = (rptr_bin_next>>1) ^ rptr_bin_next; 

    // Calculate the next state of the empty flag.
    assign rempty_next = rptr_gray_next == wr_ptr_gray_sync;

    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            rempty <= 1;
        end
        else begin
            rempty <= rempty_next;
        end    
    end

    // Sequential logic to update all state registers on the clock edge.
    always @(posedge rd_clk or negedge rd_rstn) begin
        if (!rd_rstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end

endmodule
