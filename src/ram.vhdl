library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram is
    generic(
        w : integer := 8;
        r : integer := 7
    );
    port(
        clk : in std_logic;
        we : in std_logic;
        en : in std_logic;
        addr : in std_logic_vector(r-1 downto 0);
        di : in std_logic_vector(w-1 downto 0);
        do : out std_logic_vector(w-1 downto 0)
    );
end ram;

architecture Behavior of ram is
    type ram_type is array(0 to 2**r-1) of std_logic_vector(w-1 downto 0);
    signal mem : ram_type := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (en = '1') then
                do <= mem(to_integer(unsigned(addr)));
                if (we = '1') then
                    mem(to_integer(unsigned(addr))) <= di;
                end if;
            end if;
        end if;
    end process;
end Behavior;
