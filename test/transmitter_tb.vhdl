library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Transmitter_tb is
end Transmitter_tb;

architecture Behavioral of Transmitter_tb is

    signal clk: std_logic;
    signal reset: std_logic;
    signal tx_start: std_logic;
    signal s_tick: std_logic;
    signal din: std_logic_vector(7 downto 0);
    signal tx_done_tick: std_logic;
    signal tx: std_logic;
    
begin
    p0:entity work.Transmitter(Behavioral) port map(clk=>clk, reset=>reset, tx_start=>tx_start, s_tick=>s_tick, din=>din, tx_done_tick=>tx_done_tick, tx=>tx); 
    
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
