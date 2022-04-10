library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Baud_Rate is
    generic(
        N: integer := 5;
        M: integer := 27
    );
        
    Port(
        clk, reset: in std_logic;
        max_tick: out std_logic;
        q: out std_logic_vector(N-1 downto 0)
    );
end Baud_Rate;

architecture Behavioral of Baud_Rate is
    signal r_reg: unsigned(N-1 downto 0);
    signal r_next: unsigned(N-1 downto 0);
begin
    process(clk, reset)
    begin
        if (reset = '1') then
            r_reg <= (others => '0');
        elsif (clk'event and clk='1') then
            r_reg <= r_next;
        end if;
    end process;

    -- next state logic
    r_next <= (others => '0') when r_reg=(M-1) else r_reg + 1;

    -- output logic
    q <= std_logic_vector(r_reg);
    max_tick <= '1' when r_reg=(M-1) else '0';
end Behavioral;
