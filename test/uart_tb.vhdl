library IEEE;
use IEEE.std_logic_1164.all;

entity uart_tb is
end uart_tb;

architecture Behavior of uart_tb is

    -- The UART component
    component UART is
        port (
            clk : in std_logic;
            reset : in std_logic;
            rx : in std_logic;
            rx_ready : out std_logic;
            tx : out std_logic
        );
    end component;
    
    -- Signals
    signal clk, reset, rx, rx_ready, tx : std_logic := '0';
    
    -- Clock period
    constant clk_period : time := 5 ns;
begin
    uut : UART port map (clk => clk, reset => reset, rx => rx, rx_ready => rx_ready, tx => tx);
    
    -- The clock process
    clk_proc : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
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
            wait until rx_ready = '1';
            rx <= '0';
            wait until rx_ready = '1';
        end loop;
        
        wait;
    end process;
end Behavior;

