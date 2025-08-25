module axi_stream #(
    parameter DATA_WIDTH = 32,
    parameter FIFO_DEPTH = 512,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)
) (
    input  wire                  clk,
    input  wire                  rst_n,
    
    // AXI-Stream Slave Interface
    input  wire                  s_axis_tvalid,
    output reg                   s_axis_tready,
    
    // AXI-Stream Master Interface
    output reg  [DATA_WIDTH-1:0] m_axis_tdata,
    output reg                   m_axis_tvalid,
    input  wire                  m_axis_tready
);

    // FIFO memory
    reg [DATA_WIDTH-1:0] mem [0:FIFO_DEPTH-1];
    reg [ADDR_WIDTH:0]   wr_ptr;  // One extra bit for full/empty detection
    reg [ADDR_WIDTH:0]   rd_ptr;
    reg [DATA_WIDTH-1:0] counter; // 32-bit counter as data source
    
    // Internal signals
    wire                 full;
    wire                 empty;
    wire                 write_en;
    wire                 read_en;
    
    // Full and empty flags
    assign full  = (wr_ptr[ADDR_WIDTH-1:0] == rd_ptr[ADDR_WIDTH-1:0]) && 
                   (wr_ptr[ADDR_WIDTH] != rd_ptr[ADDR_WIDTH]);
    assign empty = (wr_ptr == rd_ptr);
    
    // AXI-Stream control signals
    assign write_en = s_axis_tvalid & s_axis_tready;
    assign read_en  = m_axis_tvalid & m_axis_tready;
    
    // Counter logic (data source)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter <= {DATA_WIDTH{1'b0}}; 
        end else if (write_en) begin
            counter <= counter + 1;
        end
    end
    
    // Write pointer logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 0;
        end else if (write_en) begin
            wr_ptr <= wr_ptr + 1;
        end
    end
    
    // Read pointer logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 0;
        end else if (read_en) begin
            rd_ptr <= rd_ptr + 1;
        end
    end
    
    // FIFO write (store counter value)
    always @(posedge clk) begin
        if (write_en) begin
            mem[wr_ptr[ADDR_WIDTH-1:0]] <= counter; // Write 32-bit counter directly
        end
    end
    
    // FIFO read
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            m_axis_tdata <= 0;
        end else if (read_en) begin
            m_axis_tdata <= mem[rd_ptr[ADDR_WIDTH-1:0]];
        end
    end
    
    // AXI-Stream ready/valid signals
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            s_axis_tready <= 0;
            m_axis_tvalid <= 0;
        end else begin
            s_axis_tready <= !full;
            m_axis_tvalid <= !empty;
        end
    end

endmodule
