library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UART is
    port (
        clk : in std_logic;
        reset : in std_logic;
        rx : in std_logic;
        rx_ready : out std_logic;
        tx : out std_logic
    );
end UART;

architecture Behavior of UART is

    -- The baud rate generator component
    component Baud_Rate is
        generic(
            N: integer := 5;
            M: integer := 5     -- Originally 27 -> need shorter
        );
        Port(
            clk, reset: in std_logic;
            max_tick: out std_logic;
            q: out std_logic_vector(N-1 downto 0)
        );
    end component;
    
    -- The RX component
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
    
    -- The FIFO component
    component FIFO is
        generic(
            WIDTH : integer := 8
        );
        
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
    
    -- The RAM component
    component RAM is
        generic(
            w : integer := 8;
            r : integer := 7
        );
        port(
            clk : in std_logic;
            we : in std_logic;
            en : in std_logic;
            addr : in std_logic_vector(r-1 downto 0);
            di : in std_logic_vector(w-1 downto 0);
            do : out std_logic_vector(w-1 downto 0)
        );
    end component;
    
    -- The TX component
    component Transmitter is
        port(
            clk, reset: in std_logic;
            s_tick: in std_logic;
            din: in std_logic_vector(7 downto 0);
            tx_done_tick: out std_logic;
            tx: out std_logic
        );
    end component;

    -- Signals
    signal rx_rx, s_tick, rx_done_tick : std_logic := '0';
    signal rx_dout, rx_rdata, tx_rdata : std_logic_vector(7 downto 0);
    
    signal rx_rd, rx_empty : std_logic := '0';
    signal tx_wr, tx_rd, tx_empty, tx_done_tick, tx_tx : std_logic := '0';
    
    type t_tx_stage is (none, idle, ram_write, fifo_write, fifo_read);
    signal tx_stage, tx_stage_next : t_tx_stage := none;
    
    -- RAM signals
    signal we, en : std_logic := '0';
    signal addr : std_logic_vector(6 downto 0) := "0000000";
    signal do : std_logic_vector(7 downto 0);
    
begin
    -- Init the componenets
    uut_baud_rate : Baud_Rate port map (clk => clk, reset => reset, max_tick => s_tick, q => open);
    uut_rx : Receiver port map (clk => clk, reset => reset, rx => rx_rx, s_tick => s_tick, rx_done_tick => rx_done_tick, dout => rx_dout);
    rx_fifo : FIFO port map(clk => clk, wr => rx_done_tick, rd => rx_rd, w_data => rx_dout, empty => rx_empty, full => open, r_data => rx_rdata);
    uut_ram : RAM port map(clk => clk, we => we, en => en, addr => addr, di => rx_dout, do => do);
    tx_fifo : FIFO port map(clk => clk, wr => tx_wr, rd => tx_rd, w_data => do, empty => tx_empty, full => open, r_data => tx_rdata);
    uut_tx : Transmitter port map(clk => clk, reset => reset, s_tick => s_tick, din => tx_rdata, tx_done_tick => tx_done_tick, tx => tx_tx);
    
    process(clk)
    begin
        if rising_edge(clk) and reset = '1' then
        
        elsif rising_edge(clk) and reset = '0' then
            rx_rx <= rx;
            
            -- Stages for the transmitter portion
            if rx_done_tick = '1' then
                tx_stage <= idle;
            else
                tx_stage <= tx_stage_next;
            end if;
        end if;
    end process;
    
    process(rx_done_tick)
    begin
        if rx_done_tick = '1' then
            addr <= std_logic_vector(unsigned(addr)+1);
        end if;
    end process;
    
    process(tx_stage)
    begin
        case tx_stage is
            when idle => tx_stage_next <= ram_write;
            
            when ram_write =>
                tx_stage_next <= fifo_write;
                
            when fifo_write =>
                tx_wr <= '1';
                tx_stage_next <= fifo_read;
                
            when fifo_read =>
                tx_wr <= '0';
                tx_rd <= '1';
                tx_stage_next <= none;
                
            when others =>
        end case;
    end process;
    
    we <= not rx_empty;
    rx_ready <= s_tick;
    en <= '1';
    tx <= tx_tx;
end Behavior;

