
module FIFO #(
    parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 4
) (
    input wr_clk, wr_rstn, wr_en,
    input [DATA_SIZE-1:0] wr_data,
    output wfull,
    input rd_clk, rd_rstn, rd_en,
    output [DATA_SIZE-1:0] rd_data,
    output rempty
);

    wire [ADDR_SIZE:0] wptr_gray, rptr_gray;
    wire [ADDR_SIZE:0] wr_ptr_gray_sync, rd_ptr_gray_sync;
    wire [ADDR_SIZE-1:0] wr_addr, rd_addr;

    wptr_full #(
        .ADDR_SIZE(ADDR_SIZE)) 
        wptr_full_inst (
            .wr_clk(wr_clk), 
            .wr_rstn(wr_rstn), 
            .wr_en(wr_en), 
            .rd_ptr_gray_sync(rd_ptr_gray_sync), 
            .wfull(wfull), 
            .waddr(wr_addr), 
            .wptr_gray(wptr_gray));

    rptr_empty #(
        .ADDR_SIZE(ADDR_SIZE))
        rptr_empty_inst (
            .rd_clk(rd_clk),
            .rd_rstn(rd_rstn), 
            .rd_en(rd_en), 
            .wr_ptr_gray_sync(wr_ptr_gray_sync), 
            .rempty(rempty), 
            .raddr(rd_addr), 
            .rptr_gray(rptr_gray));

    synchronizer #(
        .WIDTH(ADDR_SIZE + 1)) 
        r2w_sync_inst (
            .dest_clk(wr_clk), 
            .dest_rstn(wr_rstn), 
            .source_signal(rptr_gray), 
            .sync_signal(rd_ptr_gray_sync));

    synchronizer #(
        .WIDTH(ADDR_SIZE + 1)) 
        w2r_sync_inst (
            .dest_clk(rd_clk), 
            .dest_rstn(rd_rstn), 
            .source_signal(wptr_gray),
            .sync_signal(wr_ptr_gray_sync));

    FIFO_mem #(
        .DATA_SIZE(DATA_SIZE),
        .ADDR_SIZE(ADDR_SIZE)) 
        fifo_mem_inst (
            .wr_clk(wr_clk), 
            .rd_clk(rd_clk),
            .wr_en(wr_en & ~wfull),
            .rd_en(rd_en & ~rempty),
            .wr_data(wr_data), 
            .rd_data(rd_data),
            .wr_addr(wr_addr), 
            .rd_addr(rd_addr));

endmodule
