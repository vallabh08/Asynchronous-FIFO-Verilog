
`timescale 1ns/1ps

module FIFO_tb();

    parameter DATA_SIZE = 8; // Data bus size
    parameter ADDR_SIZE = 3; // Address bus size
    parameter WIDTH = 1 << ADDR_SIZE; // Depth of the FIFO memory

    reg [DATA_SIZE-1:0] wr_data;   // Input data
    wire [DATA_SIZE-1:0] rd_data;  // Output data
    wire wfull, rempty;      // Write full and read empty signals
    reg wr_en, rd_en, wr_clk, rd_clk, wr_rstn, rd_rstn; // Write and read signals

    FIFO #(DATA_SIZE, ADDR_SIZE) fifo (
        .rd_data(rd_data), 
        .wr_data(wr_data),
        .wfull(wfull),
        .rempty(rempty),
        .wr_en(wr_en), 
        .rd_en(rd_en), 
        .wr_clk(wr_clk), 
        .rd_clk(rd_clk), 
        .wr_rstn(wr_rstn), 
        .rd_rstn(rd_rstn)
    );

    integer i=0;
    integer seed = 1;

    // Read and write clock in loop
    always #5 wr_clk = ~wr_clk;    // faster writing
    always #10 rd_clk = ~rd_clk;   // slower reading
    
    initial begin
        // Initialize all signals
        wr_clk = 0;
        rd_clk = 0;
        wr_rstn = 1;     // Active low reset
        rd_rstn = 1;     // Active low reset
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        // Reset the FIFO
        #40 wr_rstn = 0; rd_rstn = 0;
        #40 wr_rstn = 1; rd_rstn = 1;

        // TEST CASE 1: Write data and read it back
        rd_en = 1;
        for (i = 0; i < 10; i = i + 1) begin
            wr_data = $random(seed) % 256;
            wr_en = 1;
            #10;
            wr_en = 0;
            #10;
        end

        // TEST CASE 2: Write data to make FIFO full and try to write more data
        rd_en = 0;
        wr_en = 1;
        for (i = 0; i < WIDTH + 3; i = i + 1) begin
            wr_data = $random(seed) % 256;
            #10;
        end

        // TEST CASE 3: Read data from empty FIFO and try to read more data
        wr_en = 0;
        rd_en = 1;
        for (i = 0; i < WIDTH + 3; i = i + 1) begin
            #20;
        end

        $finish;
    end

endmodule
