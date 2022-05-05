--
-- This is probably not the right way to do the receiver, but the original didn't work at all
-- This listens for the clock and the baud rate generator. The RX takes in one input of data.
-- 
-- When the clock and the baud rate generator go high, the RX receives the data and puts it in
-- the current location of the array.
--
-- When the array is full, "rx_done_tick" goes high, and the process starts over.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Receiver is
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
end Receiver;

architecture Behavior of Receiver is
    signal b_reg : std_logic_vector(7 downto 0) := "00000000";
    signal done : std_logic := '0';
    signal location : integer := 0;
    
    constant max : integer := 7;
begin
    process (clk) is
    begin
        if rising_edge(clk) and reset = '1' then
            -- TODO
            rx_done_tick <= '0';
        elsif rising_edge(clk) and reset = '0' then
            if s_tick = '1' then
                if location = max then
                    rx_done_tick <= '1';
                    done <= '1';
                    location <= 0;
                    dout <= b_reg;
                else
                    b_reg(location) <= rx;
                    location <= location + 1;
                    rx_done_tick <= '0';
                    done <= '0';
                    dout <= "00000000";
                end if;
            end if;
            
            if done = '1' then
                rx_done_tick <= '0';
            end if;
        end if;
    end process;
end Behavior;

