library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Receiver_tb is
end Receiver_tb;

architecture Behavioral of Receiver_tb is

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

    -- Signals
    signal clk, reset, rx, s_tick, rx_done_tick : std_logic := '0';
    signal dout : std_logic_vector(7 downto 0);
    
    -- Clock period
    constant clk_period : time := 5 ns;
begin
    -- Init the componenets
    uut1 : Baud_Rate port map (clk => clk, reset => reset, max_tick => s_tick, q => open);
    uut2 : Receiver port map (clk => clk, reset => reset, rx => rx, s_tick => s_tick, rx_done_tick => rx_done_tick, dout => dout);
    
    -- The clock
    clk_proc : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;
    
    -- The test process
    test_proc : process
    begin
        -- Perform a reset
        reset <= '1';
        wait for clk_period * 3;
        reset <= '0';
        
        -- Now, pass values
        for i in 0 to 5 loop
            rx <= '1';
            wait until s_tick = '1';
            rx <= '0';
            wait until s_tick = '1';
        end loop;
        
        wait;
    end process;
end Behavioral;

