library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Transmitter is    
    port(
        clk, reset: in std_logic;
        s_tick: in std_logic;
        din: in std_logic_vector(7 downto 0);
        tx_done_tick: out std_logic;
        tx: out std_logic
    );
end Transmitter;

architecture Behavioral of Transmitter is
    signal location : integer := 0;
    signal buf : std_logic_vector(7 downto 0) := "00000000";
    signal done : std_logic := '0';
    
    constant max : integer := 8;
begin
    process (clk)
    begin
        if rising_edge(clk) and reset = '1' then
            location <= 0;
            tx_done_tick <= '0';
        elsif rising_edge(clk) and reset = '0' then
            if buf /= din then
            buf <= din;
            location <= 0;
            end if;
            
            if s_tick = '1' then
                if location < max then
                    if is_X(buf(location)) then
                        tx <= '0';
                    else
                        tx <= buf(location);
                    end if;
                    
                    location <= location + 1;
                    done <= '0';
                    tx_done_tick <= '0';
                elsif location >= max then
                    done <= '1';
                    location <= 0;
                    buf <= "00000000";
                    tx_done_tick <= '1';
                end if;
            end if;
            
            if done = '1' then
                tx_done_tick <= '0';
            end if;
        end if;
    end process;
end Behavioral;
