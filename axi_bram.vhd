----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.08.2025 16:38:08
-- Design Name: 
-- Module Name: axi - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- BOTH MASTER AND SLAVE
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity axi4_bram_master_slave is
    generic (
        -- AXI4 Parameters
        C_AXI_ID_WIDTH    : integer := 4;    -- ID width for AXI transactions
        C_AXI_ADDR_WIDTH  : integer := 12;   -- Address width (for 4KB memory)
        C_AXI_DATA_WIDTH  : integer := 32;   -- Data width
        C_AXI_LEN_WIDTH   : integer := 8;    -- Burst length width (up to 256 transfers)
        -- BRAM Parameters
        RAM_WIDTH         : integer := 32;   -- Data width of BRAM
        RAM_DEPTH         : integer := 1024  -- Depth of BRAM (number of words)
    );
    port (
        -- AXI4 Slave Interface (Port A)
        s_axi_aclk    : in  std_logic;
        s_axi_aresetn : in  std_logic;
        -- Slave Write Address Channel (Port A)
        s_axi_awid    : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        s_axi_awaddr  : in  std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_awlen   : in  std_logic_vector(C_AXI_LEN_WIDTH-1 downto 0);
        s_axi_awsize  : in  std_logic_vector(2 downto 0);
        s_axi_awburst : in  std_logic_vector(1 downto 0);
        s_axi_awvalid : in  std_logic;
        s_axi_awready : out std_logic;
        -- Slave Write Data Channel (Port A)
        s_axi_wdata   : in  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        s_axi_wstrb   : in  std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
        s_axi_wlast   : in  std_logic;
        s_axi_wvalid  : in  std_logic;
        s_axi_wready  : out std_logic;
        -- Slave Write Response Channel (Port A)
        s_axi_bid     : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        s_axi_bresp   : out std_logic_vector(1 downto 0);
        s_axi_bvalid  : out std_logic;
        s_axi_bready  : in  std_logic;
        -- Slave Read Address Channel (Port A)
        s_axi_arid    : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        s_axi_araddr  : in  std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_arlen   : in  std_logic_vector(C_AXI_LEN_WIDTH-1 downto 0);
        s_axi_arsize  : in  std_logic_vector(2 downto 0);
        s_axi_arburst : in  std_logic_vector(1 downto 0);
        s_axi_arvalid : in  std_logic;
        s_axi_arready : out std_logic;
        -- Slave Read Data Channel (Port A)
        s_axi_rid     : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        s_axi_rdata   : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        s_axi_rresp   : out std_logic_vector(1 downto 0);
        s_axi_rlast   : out std_logic;
        s_axi_rvalid  : out std_logic;
        s_axi_rready  : in  std_logic;
        -- AXI4 Master Interface (Port B)
        m_axi_aclk    : in  std_logic;
        m_axi_aresetn : in  std_logic;
        -- Master Write Address Channel (Port B)
        m_axi_awid    : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        m_axi_awaddr  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        m_axi_awlen   : out std_logic_vector(C_AXI_LEN_WIDTH-1 downto 0);
        m_axi_awsize  : out std_logic_vector(2 downto 0);
        m_axi_awburst : out std_logic_vector(1 downto 0);
        m_axi_awvalid : out std_logic;
        m_axi_awready : in  std_logic;
        -- Master Write Data Channel (Port B)
        m_axi_wdata   : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        m_axi_wstrb   : out std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
        m_axi_wlast   : out std_logic;
        m_axi_wvalid  : out std_logic;
        m_axi_wready  : in  std_logic;
        -- Master Write Response Channel (Port B)
        m_axi_bid     : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        m_axi_bresp   : in  std_logic_vector(1 downto 0);
        m_axi_bvalid  : in  std_logic;
        m_axi_bready  : out std_logic;
        -- Master Read Address Channel (Port B)
        m_axi_arid    : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        m_axi_araddr  : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
        m_axi_arlen   : out std_logic_vector(C_AXI_LEN_WIDTH-1 downto 0);
        m_axi_arsize  : out std_logic_vector(2 downto 0);
        m_axi_arburst : out std_logic_vector(1 downto 0);
        m_axi_arvalid : out std_logic;
        m_axi_arready : in  std_logic;
        -- Master Read Data Channel (Port B)
        m_axi_rid     : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
        m_axi_rdata   : in  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
        m_axi_rresp   : in  std_logic_vector(1 downto 0);
        m_axi_rlast   : in  std_logic;
        m_axi_rvalid  : in  std_logic;
        m_axi_rready  : out std_logic
    );
end axi4_bram_master_slave;

architecture Behavioral of axi4_bram_master_slave is
    -- BRAM signals
    type ram_type is array (0 to RAM_DEPTH-1) of std_logic_vector(RAM_WIDTH-1 downto 0);
    signal ram : ram_type;
    
    -- AXI4 Slave signals (Port A)
    signal axi_awready_s : std_logic := '0';
    signal axi_wready_s  : std_logic := '0';
    signal axi_bvalid_s  : std_logic := '0';
    signal axi_arready_s : std_logic := '0';
    signal axi_rvalid_s  : std_logic := '0';
    signal axi_rlast_s   : std_logic := '0';
    signal axi_bid_s     : std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
    signal axi_rid_s     : std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
    signal axi_rdata_s   : std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
    
    -- AXI4 Master signals (Port B)
    signal axi_awvalid_m : std_logic := '0';
    signal axi_wvalid_m  : std_logic := '0';
    signal axi_bready_m  : std_logic := '0';
    signal axi_arvalid_m : std_logic := '0';
    signal axi_rready_m  : std_logic := '0';
    signal axi_wdata_m   : std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);
    signal axi_wstrb_m   : std_logic_vector((C_AXI_DATA_WIDTH/8)-1 downto 0);
    signal axi_awaddr_m  : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_araddr_m  : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
    
    -- BRAM address and control signals
    signal addr_s       : unsigned(C_AXI_ADDR_WIDTH-3 downto 0); -- Slave address
    signal addr_m       : unsigned(C_AXI_ADDR_WIDTH-3 downto 0); -- Master address
    signal we_s         : std_logic := '0'; -- Slave write enable
    signal we_m         : std_logic := '0'; -- Master write enable
    signal burst_len_s  : unsigned(C_AXI_LEN_WIDTH-1 downto 0);
    signal burst_cnt_s  : unsigned(C_AXI_LEN_WIDTH-1 downto 0);
    
    -- State machines
    type state_type is (IDLE, WRITE_ADDR, WRITE_DATA, WRITE_RESP, READ_ADDR, READ_DATA);
    signal state_s : state_type := IDLE; -- Slave state
    signal state_m : state_type := IDLE; -- Master state
    
    -- Master transaction trigger (for demonstration)
    signal trigger_write : std_logic := '0';
    signal trigger_read  : std_logic := '0';
    constant MASTER_ADDR : std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0) := x"000"; -- Example external address
    
begin
    -- Map slave signals to output ports
    s_axi_awready <= axi_awready_s;
    s_axi_wready  <= axi_wready_s;
    s_axi_bvalid  <= axi_bvalid_s;
    s_axi_bid     <= axi_bid_s;
    s_axi_arready <= axi_arready_s;
    s_axi_rvalid  <= axi_rvalid_s;
    s_axi_rlast   <= axi_rlast_s;
    s_axi_rid     <= axi_rid_s;
    s_axi_rdata   <= axi_rdata_s;
    s_axi_bresp   <= "00"; -- OKAY response
    s_axi_rresp   <= "00"; -- OKAY response
    
    -- Map master signals to output ports
    m_axi_awid    <= (others => '0'); -- Fixed ID for simplicity
    m_axi_awaddr  <= axi_awaddr_m;
    m_axi_awlen   <= (others => '0'); -- Single transaction
    m_axi_awsize  <= "010"; -- 32-bit transfers
    m_axi_awburst <= "01"; -- INCR burst
    m_axi_awvalid <= axi_awvalid_m;
    m_axi_wdata   <= axi_wdata_m;
    m_axi_wstrb   <= axi_wstrb_m;
    m_axi_wlast   <= '1'; -- Single transaction
    m_axi_wvalid  <= axi_wvalid_m;
    m_axi_bready  <= axi_bready_m;
    m_axi_arid    <= (others => '0'); -- Fixed ID
    m_axi_araddr  <= axi_araddr_m;
    m_axi_arlen   <= (others => '0'); -- Single transaction
    m_axi_arsize  <= "010"; -- 32-bit transfers
    m_axi_arburst <= "01"; -- INCR burst
    m_axi_arvalid <= axi_arvalid_m;
    m_axi_rready  <= axi_rready_m;
    
    -- AXI4 Slave Control Process (Port A)
    process (s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                state_s       <= IDLE;
                axi_awready_s <= '0';
                axi_wready_s  <= '0';
                axi_bvalid_s  <= '0';
                axi_arready_s <= '0';
                axi_rvalid_s  <= '0';
                axi_rlast_s   <= '0';
                axi_bid_s     <= (others => '0');
                axi_rid_s     <= (others => '0');
                we_s          <= '0';
                burst_cnt_s   <= (others => '0');
                addr_s        <= (others => '0');
            else
                case state_s is
                    when IDLE =>
                        axi_awready_s <= '0';
                        axi_wready_s  <= '0';
                        axi_bvalid_s  <= '0';
                        axi_arready_s <= '0';
                        axi_rvalid_s  <= '0';
                        axi_rlast_s   <= '0';
                        we_s          <= '0';
                        if s_axi_awvalid = '1' then
                            state_s       <= WRITE_ADDR;
                            axi_awready_s <= '1';
                            axi_bid_s     <= s_axi_awid;
                            addr_s        <= unsigned(s_axi_awaddr(C_AXI_ADDR_WIDTH-1 downto 2));
                            burst_len_s   <= unsigned(s_axi_awlen);
                            burst_cnt_s   <= (others => '0');
                        elsif s_axi_arvalid = '1' then
                            state_s       <= READ_ADDR;
                            axi_arready_s <= '1';
                            axi_rid_s     <= s_axi_arid;
                            addr_s        <= unsigned(s_axi_araddr(C_AXI_ADDR_WIDTH-1 downto 2));
                            burst_len_s   <= unsigned(s_axi_arlen);
                            burst_cnt_s   <= (others => '0');
                        end if;
                    
                    when WRITE_ADDR =>
                        axi_awready_s <= '0';
                        if s_axi_wvalid = '1' then
                            state_s      <= WRITE_DATA;
                            axi_wready_s <= '1';
                        end if;
                    
                    when WRITE_DATA =>
                        if s_axi_wvalid = '1' and axi_wready_s = '1' then
                            we_s <= '1';
                            if s_axi_wlast = '1' then
                                state_s      <= WRITE_RESP;
                                axi_wready_s <= '0';
                                axi_bvalid_s <= '1';
                            elsif burst_cnt_s < burst_len_s then
                                burst_cnt_s <= burst_cnt_s + 1;
                                if s_axi_awburst = "01" then -- INCR burst
                                    addr_s <= addr_s + 1;
                                end if;
                            end if;
                        else
                            we_s <= '0';
                        end if;
                    
                    when WRITE_RESP =>
                        we_s <= '0';
                        if s_axi_bready = '1' and axi_bvalid_s = '1' then
                            axi_bvalid_s <= '0';
                            state_s      <= IDLE;
                        end if;
                    
                    when READ_ADDR =>
                        axi_arready_s <= '0';
                        state_s       <= READ_DATA;
                        axi_rvalid_s  <= '1';
                    
                    when READ_DATA =>
                        if s_axi_rready = '1' and axi_rvalid_s = '1' then
                            if burst_cnt_s = burst_len_s then
                                axi_rlast_s  <= '1';
                                axi_rvalid_s <= '0';
                                state_s      <= IDLE;
                            else
                                axi_rlast_s <= '0';
                                burst_cnt_s <= burst_cnt_s + 1;
                                if s_axi_arburst = "01" then -- INCR burst
                                    addr_s <= addr_s + 1;
                                end if;
                            end if;
                        end if;
                    
                    when others =>
                        state_s <= IDLE;
                end case;
            end if;
        end if;
    end process;
    
    -- AXI4 Master Control Process (Port B)
    process (m_axi_aclk)
    begin
        if rising_edge(m_axi_aclk) then
            if m_axi_aresetn = '0' then
                state_m       <= IDLE;
                axi_awvalid_m <= '0';
                axi_wvalid_m  <= '0';
                axi_bready_m  <= '0';
                axi_arvalid_m <= '0';
                axi_rready_m  <= '0';
                we_m          <= '0';
                axi_wdata_m   <= (others => '0');
                axi_wstrb_m   <= (others => '0');
                axi_awaddr_m  <= (others => '0');
                axi_araddr_m  <= (others => '0');
                trigger_write <= '0';
                trigger_read  <= '0';
            else
                case state_m is
                    when IDLE =>
                        axi_awvalid_m <= '0';
                        axi_wvalid_m  <= '0';
                        axi_bready_m  <= '0';
                        axi_arvalid_m <= '0';
                        axi_rready_m  <= '0';
                        we_m          <= '0';
                        -- Example trigger: initiate a write or read after reset
                        if trigger_write = '0' and trigger_read = '0' then
                            trigger_write <= '1'; -- Start with a write
                            state_m       <= WRITE_ADDR;
                            axi_awvalid_m <= '1';
                            axi_awaddr_m  <= MASTER_ADDR;
                            axi_wdata_m   <= x"DEADBEEF"; -- Example data
                            axi_wstrb_m   <= (others => '1');
                        elsif trigger_write = '1' and trigger_read = '0' then
                            trigger_read  <= '1'; -- Follow with a read
                            state_m       <= READ_ADDR;
                            axi_arvalid_m <= '1';
                            axi_araddr_m  <= MASTER_ADDR;
                        end if;
                    
                    when WRITE_ADDR =>
                        if m_axi_awready = '1' and axi_awvalid_m = '1' then
                            axi_awvalid_m <= '0';
                            state_m       <= WRITE_DATA;
                            axi_wvalid_m  <= '1';
                        end if;
                    
                    when WRITE_DATA =>
                        if m_axi_wready = '1' and axi_wvalid_m = '1' then
                            axi_wvalid_m <= '0';
                            state_m      <= WRITE_RESP;
                            axi_bready_m <= '1';
                        end if;
                    
                    when WRITE_RESP =>
                        if m_axi_bvalid = '1' and axi_bready_m = '1' then
                            axi_bready_m <= '0';
                            state_m      <= IDLE;
                        end if;
                    
                    when READ_ADDR =>
                        if m_axi_arready = '1' and axi_arvalid_m = '1' then
                            axi_arvalid_m <= '0';
                            state_m       <= READ_DATA;
                            axi_rready_m  <= '1';
                        end if;
                    
                    when READ_DATA =>
                        if m_axi_rvalid = '1' and axi_rready_m = '1' then
                            axi_rready_m <= '0';
                            we_m         <= '1'; -- Store read data in BRAM
                            state_m      <= IDLE;
                        end if;
                    
                    when others =>
                        state_m <= IDLE;
                end case;
            end if;
        end if;
    end process;
    
    -- BRAM Write and Read Process
    process (s_axi_aclk, m_axi_aclk)
    begin
        -- Slave Port (Port A)
        if rising_edge(s_axi_aclk) then
            if we_s = '1' then
                for i in 0 to (C_AXI_DATA_WIDTH/8)-1 loop
                    if s_axi_wstrb(i) = '1' then
                        ram(to_integer(addr_s))((i+1)*8-1 downto i*8) <= s_axi_wdata((i+1)*8-1 downto i*8);
                    end if;
                end loop;
            end if;
            axi_rdata_s <= ram(to_integer(addr_s));
        end if;
        
        -- Master Port (Port B)
        if rising_edge(m_axi_aclk) then
            if we_m = '1' then
                ram(to_integer(addr_m)) <= m_axi_rdata; -- Store data from master read
            end if;
        end if;
    end process;

end Behavioral;
