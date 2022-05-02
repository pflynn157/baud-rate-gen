library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_tb is
    generic(
        w : integer := 8;
        r : integer := 7
    );
end ram_tb;

architecture Behavior of ram_tb is
    component RAM is
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
    end component;
    
    -- Init the signals
    signal clk, we, en : std_logic := '0';
    signal addr : std_logic_vector(r-1 downto 0);
    signal di, do : std_logic_vector(w-1 downto 0);
    
    -- Clock period
    constant clk_period : time := 10 ns;
begin
    -- Init the component
    uut : RAM port map(clk => clk, we => we, en => en,
                        addr => addr, di => di, do => do);
                        
    -- Clock definition
    clk_proc : process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;
    
    -- Test
    test_proc : process
    begin
        en <= '1';
        addr <= "0000000";
        di <= "00011101";
        we <= '1';
        wait for clk_period;
        
        addr <= "0000001";
        di <= "11100011";
        we <= '1';
        wait for clk_period;
        wait;
    end process;
end Behavior;

