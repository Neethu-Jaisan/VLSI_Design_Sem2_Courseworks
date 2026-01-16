module soc_top (
    input  logic        soc_clk,
    input  logic        soc_rst_n,

    // AXI-Lite master interface (from TB)
    input  logic [31:0] m_addr,
    input  logic [31:0] m_wdata,
    input  logic        m_wr_en,
    input  logic        m_rd_en,
    input  logic        m_valid,
    output logic [31:0] m_rdata,
    output logic        m_ready,

    output logic        soc_irq,
    output logic        security_alert
);

    // -------------------------------
    // Internal bus wires
    // -------------------------------
    logic [31:0] s_addr;
    logic [31:0] s_wdata;
    logic        s_wr_en, s_rd_en;
    logic        s_valid;

    // Slave select
    logic sel_ctrl, sel_accel, sel_gpio, sel_mem, sel_sec;

    // -------------------------------
    // Slave response wires
    // -------------------------------
    logic [31:0] rdata_ctrl, rdata_accel, rdata_gpio, rdata_mem;
    logic        ready_ctrl, ready_accel, ready_gpio, ready_mem;

    // -------------------------------
    // Interconnect
    // -------------------------------
    axi_lite_interconnect u_interconnect (
        .clk        (soc_clk),
        .rst_n      (soc_rst_n),

        .m_addr     (m_addr),
        .m_wdata    (m_wdata),
        .m_wr_en    (m_wr_en),
        .m_rd_en    (m_rd_en),
        .m_valid    (m_valid),

        .s_addr     (s_addr),
        .s_wdata    (s_wdata),
        .s_wr_en    (s_wr_en),
        .s_rd_en    (s_rd_en),
        .s_valid    (s_valid),

        .sel_ctrl   (sel_ctrl),
        .sel_accel  (sel_accel),
        .sel_gpio   (sel_gpio),
        .sel_mem    (sel_mem),
        .sel_sec    (sel_sec)
    );

    // -------------------------------
    // Control Registers
    // -------------------------------
    ctrl_regs u_ctrl (
        .clk     (soc_clk),
        .rst_n   (soc_rst_n),
        .sel     (sel_ctrl),
        .addr    (s_addr),
        .wdata   (s_wdata),
        .wr_en   (s_wr_en),
        .rd_en   (s_rd_en),
        .rdata   (rdata_ctrl),
        .ready   (ready_ctrl)
    );

    // -------------------------------
    // HLS Accelerator (stub)
    // -------------------------------
    hls_accel_stub u_accel (
        .clk     (soc_clk),
        .rst_n   (soc_rst_n),
        .sel     (sel_accel),
        .addr    (s_addr),
        .wdata   (s_wdata),
        .wr_en   (s_wr_en),
        .rd_en   (s_rd_en),
        .rdata   (rdata_accel),
        .ready   (ready_accel),
        .irq     (soc_irq)
    );

    // -------------------------------
    // GPIO Stub
    // -------------------------------
    gpio_stub u_gpio (
        .clk     (soc_clk),
        .rst_n   (soc_rst_n),
        .sel     (sel_gpio),
        .addr    (s_addr),
        .wdata   (s_wdata),
        .wr_en   (s_wr_en),
        .rd_en   (s_rd_en),
        .rdata   (rdata_gpio),
        .ready   (ready_gpio)
    );

    // -------------------------------
    // Memory Stub
    // -------------------------------
    memory_stub u_mem (
        .clk     (soc_clk),
        .rst_n   (soc_rst_n),
        .sel     (sel_mem),
        .addr    (s_addr),
        .wdata   (s_wdata),
        .wr_en   (s_wr_en),
        .rd_en   (s_rd_en),
        .rdata   (rdata_mem),
        .ready   (ready_mem)
    );

    // -------------------------------
    // Security Monitor
    // -------------------------------
    security_monitor u_sec (
        .clk            (soc_clk),
        .rst_n          (soc_rst_n),
        .sel            (sel_sec),
        .addr           (s_addr),
        .valid          (s_valid),
        .security_alert (security_alert)
    );

    // -------------------------------
    // RESPONSE MULTIPLEXER
    // -------------------------------
    always_comb begin
        m_rdata = 32'b0;
        m_ready = 1'b0;

        if (sel_ctrl) begin
            m_rdata = rdata_ctrl;
            m_ready = ready_ctrl;
        end
        else if (sel_accel) begin
            m_rdata = rdata_accel;
            m_ready = ready_accel;
        end
        else if (sel_gpio) begin
            m_rdata = rdata_gpio;
            m_ready = ready_gpio;
        end
        else if (sel_mem) begin
            m_rdata = rdata_mem;
            m_ready = ready_mem;
        end
        else if (sel_sec) begin
            m_rdata = 32'h0;
            m_ready = 1'b1;
        end
    end

endmodule
