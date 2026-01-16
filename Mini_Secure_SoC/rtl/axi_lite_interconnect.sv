always_comb begin
    sel_ctrl  = (m_addr[15:12] == 4'h0);
    sel_accel = (m_addr[15:12] == 4'h1);
    sel_gpio  = (m_addr[15:12] == 4'h2);
    sel_mem   = (m_addr[15:12] == 4'h3);
    sel_sec   = (m_addr[15:12] == 4'h4);
end
