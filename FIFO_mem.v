
module FIFO_mem #(
    parameter DATA_SIZE = 8,
    parameter ADDR_SIZE = 4
) (
    input wr_clk, wr_en, rd_clk, rd_en,
    input [ADDR_SIZE-1 : 0] wr_addr, rd_addr,
    input [DATA_SIZE-1 : 0] wr_data,
    output reg [DATA_SIZE-1 : 0] rd_data
);

    localparam DEPTH = (1 << ADDR_SIZE);
    reg [DATA_SIZE-1 : 0] mem [0 : DEPTH-1];

    // Write logic
    always @(posedge wr_clk) begin
        if (wr_en) begin
            mem[wr_addr] <= wr_data;
        end
    end

    // Read logic
    always @(posedge rd_clk) begin
        if (rd_en) begin
            rd_data <= mem[rd_addr];
        end
    end

endmodule
