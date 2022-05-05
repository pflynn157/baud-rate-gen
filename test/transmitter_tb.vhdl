library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Transmitter_tb is
end Transmitter_tb;

architecture Behavioral of Transmitter_tb is

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
    signal clk, reset, s_tick, tx_done_tick, tx : std_logic := '0';
    signal din : std_logic_vector(7 downto 0);
    
    -- Clock period
    constant clk_period : time := 5 ns;
begin
    -- Init the componenets
    uut1 : Baud_Rate port map (clk => clk, reset => reset, max_tick => s_tick, q => open);
    tx_uut : Transmitter port map (clk => clk, reset => reset, s_tick => s_tick,
                                   din => din, tx_done_tick => tx_done_tick, tx => tx);
    
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
        
        din <= "11001010";
        wait until tx_done_tick = '1';
        
        din <= "00000000";
        
        wait;
    end process;
end Behavioral;
