library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Baud_Rate_tb is
end Baud_Rate_tb;

architecture Behavioral of Baud_Rate_tb is
    signal clk: std_logic;
    signal reset: std_logic;
    signal max_tick: std_logic;
    signal q: std_logic_vector(4 downto 0);
begin
    p0:entity work.Baud_Rate(Behavioral) port map(clk=>clk, reset=>reset, max_tick=>max_tick, q=>q); 
    
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
        wait for 300 ns;
        reset <= '0';
        wait;
    end process;
    
end Behavioral;
