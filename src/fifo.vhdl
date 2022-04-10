library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIFO is
    generic(
        WIDTH : integer := 8
    );
    
    port(
        clk    : in std_logic;
        wr     : in std_logic;
        rd     : in std_logic;
        w_data : in std_logic_vector(WIDTH-1 downto 0);
        empty  : out std_logic;
        full   : out std_logic;
        r_data : out std_logic_vector(WIDTH-1 downto 0)
    );
end FIFO;

architecture Behavior of FIFO is
    type register_file is array (0 to 7) of std_logic_vector((WIDTH-1) downto 0);
    signal regs : register_file;
    
    signal wp : std_logic_vector(3 downto 0) := "0000";
    signal rp : std_logic_vector(3 downto 0) := "0000";
begin
    process (clk) is
    begin
        if rising_edge(clk) then
            if wp = rp then
                if wp(3) = '1' then
                    wp(3) <= '0';
                end if;
                
                empty <= '1';
            end if;
        
            -- Write
            if wr = '1' then
                if wp(3) = '0' then
                    regs(to_integer(unsigned(wp))) <= w_data;
                end if;
                
                wp <= std_logic_vector(to_unsigned(to_integer(unsigned(wp)) + 1, 4));
            end if;
            
            -- Read
            if rd = '1' then
                r_data <= regs(to_integer(unsigned(rp(2 downto 0))));
                rp <= std_logic_vector(to_unsigned(to_integer(unsigned(rp)) + 1, 4));
            end if;
            
            -- Set empty/full bits
            full <= wp(3);
            empty <= rp(3);
        end if;
    end process;
end Behavior;

