library IEEE;
use IEEE.std_logic_1164.all;

entity Classification is
    generic(
        w : integer := 8
    );
    port(
        clk : in std_logic;
        en : in std_logic;
        din : in std_logic_vector(w-1 downto 0);
        dout : out std_logic_vector(w-1 downto 0)
    );
end Classification;

architecture Behavior of Classification is
begin
    process (clk) is
    begin
        if rising_edge(clk) and en = '1' then
            if din >= "00000000" and din <= "00001000" then
                dout <= "00000001";
            elsif din > "00001000" and din <= "00010000" then
                dout <= "00000010";
            elsif din > "00010000" and din <= "00100000" then
                dout <= "00000100";
            else
                dout <= din;
            end if;
        end if;
    end process;
end Behavior;
