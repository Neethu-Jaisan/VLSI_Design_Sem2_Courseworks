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

    // Internal wires
    logic [31:0] s_addr;
    logic [31:0] s_wdata;
    logic [31:0] s_rdata;
    logic        s_wr_en, s_rd_en;
    logic        s_valid, s_ready;

    // Slave select
    logic sel_ctrl, sel_accel, sel_gpio, sel_mem, sel_sec;

    // Interconnect
    axi_lite_interconnect u_interconnect (
        .clk        (soc_clk),
        .rst_n      (soc_rst_n),

        .m_addr     (m_addr),
        .m_wdata    (m_wdata),
        .m_wr_en    (m_wr_en),
        .m_rd_en    (m_rd_en),
        .m_valid    (m_valid),
        .m_rdata    (m_rdata),
        .m_ready    (m_ready),

        .s_addr     (s_addr),
        .s_wdata    (s_wdata),
        .s_wr_en    (s_wr_en),
        .s_rd_en    (s_rd_en),
        .s_valid    (s_valid),
        .s_ready    (s_ready),

        .sel_ctrl   (sel_ctrl),
        .sel_accel  (sel_accel),
        .sel_gpio   (sel_gpio),
        .sel_mem    (sel_mem),
        .sel_sec    (sel_sec)
    );

    // Control Registers
    ctrl_regs u_ctrl (
        .clk     (soc_clk),
        .rst_n   (soc_rst_n),
        .sel     (sel_ctrl),
        .addr    (s_addr),
        .wdata   (s_wdata),
        .wr_en   (s_wr_en),
        .rd_en   (s_rd_en),
        .rdata   (/* TODO */),
        .ready   (/* TODO */)
    );

    // HLS Accelerator (stub for now)
    hls_accel_stub u_accel (
        .clk     (soc_clk),
        .rst_n   (soc_rst_n),
        .sel     (sel_accel),
        .addr    (s_addr),
        .wdata   (s_wdata),
        .wr_en   (s_wr_en),
        .rd_en   (s_rd_en),
        .rdata   (/* TODO */),
        .ready   (/* TODO */),
        .irq     (soc_irq)
    );

    // GPIO Stub
    gpio_stub u_gpio (/* same pattern */);

    // Memory Stub
    memory_stub u_mem (/* same pattern */);

    // Security Monitor
    security_monitor u_sec (
        .clk            (soc_clk),
        .rst_n          (soc_rst_n),
        .sel            (sel_sec),
        .addr           (s_addr),
        .valid          (s_valid),
        .security_alert (security_alert)
    );

endmodule
