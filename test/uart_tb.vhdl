library IEEE;
use IEEE.std_logic_1164.all;

entity uart_tb is
    generic(
        WIDTH : integer := 8
    );
end uart_tb;

architecture Behavior of uart_tb is
    signal clk, reset, rx, rd_uart, wr_uart, tx, rx_empty, tx_full : std_logic := '0';
    signal w_data, r_data : std_logic_vector(WIDTH-1 downto 0);
    
    -- Clock period
    constant clk_period : time := 10 ns;
begin
    uut : entity work.UART(Behavior) port map(
        clk => clk,
        reset => reset,
        rx => rx,
        rd_uart => rd_uart, wr_uart => wr_uart,
        tx => tx,
        rx_empty => rx_empty,
        tx_full => tx_full,
        w_data => w_data,
        r_data => r_data
    );
    
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
    
        wait;
    end process;
end Behavior;

