library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Receiver_tb is
end Receiver_tb;

architecture Behavioral of Receiver_tb is

    signal clk: std_logic;
    signal reset: std_logic;
    signal rx, s_tick, rx_done_tick : std_logic;
    signal dout: std_logic_vector(7 downto 0);
    
begin
    p0:entity work.Receiver(Behavior) port map(clk=>clk, reset=>reset, rx => rx, s_tick => s_tick, rx_done_tick => rx_done_tick, dout => dout); 
    
    --tx_start <=;
    --s_tick <=;
    --din <=;
    
    clock:process
    begin
        clk <= '0';
        wait for 100 ns;
        clk <= '1';
        wait for 100 ns;
    end process;
    
    stimulus:process
    begin
        reset <= '1';
        wait for 100 ns;
        reset <= '0';
        wait;
    end process;
    
end Behavioral;
