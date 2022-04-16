library IEEE;
use IEEE.std_logic_1164.all;

entity UART is
    generic(
        N: integer := 5;
        WIDTH : integer := 8
    );
    
    port (
        clk, reset       : in std_logic;
        rx               : in std_logic;
        rd_uart, wr_uart : in std_logic;
        w_data           : in std_logic_vector(WIDTH-1 downto 0);
        tx               : out std_logic;
        rx_empty         : out std_logic;
        tx_full          : out std_logic;
        r_data           : out std_logic_vector(WIDTH-1 downto 0)
    );
end UART;

architecture Behavior of UART is
    --
    -- Declare the components
    --
    -- The baud rate generator
    component Baud_Rate is
        generic(
            N: integer := 5;
            M: integer := 27
        );
        port(
            clk, reset: in std_logic;
            max_tick: out std_logic;
            q: out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    -- the FIFO component
    component FIFO is
        generic(WIDTH : integer := 8);
        port(
            clk    : in std_logic;
            wr     : in std_logic;
            rd     : in std_logic;
            w_data : in std_logic_vector(WIDTH-1 downto 0);
            empty  : out std_logic;
            full   : out std_logic;
            r_data : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;
    
    -- The receiver component
    component Receiver is
        generic(
            DBIT: integer := 8;
            SB_TICK: integer := 16
        );
        port(
            clk, reset: in std_logic;
            rx: in std_logic;
            s_tick: in std_logic;
            rx_done_tick: out std_logic;
            dout: out std_logic_vector(7 downto 0)
        );
    end component;
    
    -- The transmitter component
    component Transmitter is
        generic(
            DBIT: integer := 8;
            SB_TICK: integer := 16
        );   
        port(
            clk, reset: in std_logic;
            tx_start: in std_logic;
            s_tick: in std_logic;
            din: in std_logic_vector(7 downto 0);
            tx_done_tick: out std_logic;
            tx: out std_logic
        );
    end component;
    
    -- All the signals we need
    signal s_tick : std_logic_vector(N-1 downto 0);
    
    -- Receiver signals
    signal rx_done_tick : std_logic := '0';
    signal rx_w_data : std_logic_vector(7 downto 0);
    
    -- Transmitter signals
    signal tx_done_tick : std_logic := '0';
    signal tx_start, tx_start2, tx_rd : std_logic := '0';
    signal tx_din : std_logic_vector(7 downto 0);
begin
    -- Connect the components
    brg : Baud_Rate port map(clk => clk, reset => reset, max_tick => open, q => s_tick);
    tx_uut : Transmitter port map(
        clk => clk,     -- Entity => local
        reset => reset,
        s_tick => s_tick(0),        -- TODO: This is probably wrong
        tx_start => tx_start,
        tx_done_tick => tx_rd,
        din => tx_din,
        tx => tx
    );
    
    rx_uut : Receiver port map(
        clk => clk,     -- Entity => local
        reset => reset,
        rx => rx,
        s_tick => s_tick(0),        -- TODO: This is probably wrong
        rx_done_tick => rx_done_tick,
        dout => rx_w_data
    );
    
    -- FIFOs
    tx_fifo : FIFO port map(
        clk => clk,     -- Entity => local
        w_data => w_data,
        wr => wr_uart,
        full => tx_full,
        r_data => tx_din,
        rd => tx_rd,
        empty => tx_start2
    );
    
    rx_fifo : FIFO port map(
        clk => clk,     -- Entity => local
        w_data => rx_w_data,
        wr => rx_done_tick,
        r_data => r_data,
        rd => rd_uart,
        empty => rx_empty
    );
    
    tx_start <= not tx_start2;
end Behavior;

