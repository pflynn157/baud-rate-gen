library IEEE;
use IEEE.std_logic_1164.all;

entity classification_tb is
    generic(
        w : integer := 8
    );
end classification_tb;

architecture Behavior of classification_tb is
    -- The component
    component Classification is
        generic(
            w : integer := 8
        );
        port(
            clk : in std_logic;
            en : in std_logic;
            din : in std_logic_vector(w-1 downto 0);
            dout : out std_logic_vector(w-1 downto 0)
        );
    end component;
    
    -- Signals
    signal clk, en : std_logic := '0';
    signal din, dout : std_logic_vector(w-1 downto 0);
    
    -- Clock period
    constant clk_period : time := 10 ns;
begin
    -- Init the component
    uut : Classification port map(clk => clk, en => en, din => din, dout => dout);
    
    -- Clock
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
        din <= "00000010";
        wait for clk_period;
        
        din <= "00011000";
        wait for clk_period;
        
        din <= "00000111";
        wait for clk_period;
        
        din <= "00001000";
        wait for clk_period;
        
        din <= "00010000";
        wait for clk_period;
        
        wait;
    end process;
end Behavior;

