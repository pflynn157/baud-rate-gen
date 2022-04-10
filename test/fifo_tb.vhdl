library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fifo_tb is
    generic(
            WIDTH : integer := 8
        );
end fifo_tb;

architecture Behavior of fifo_tb is
    -- Init the FIFO component
    component FIFO is
        port(
            clk    : in std_logic;
            wr     : in std_logic;
            rd     : in std_logic;
            w_data : in std_logic_vector(WIDTH-1 downto 0);
            empty  : out std_logic;
            full   : out std_logic;
            r_data : out std_logic_vector(WIDTH-1 downto 0)
        );
    end component;
    
    -- Init the signals
    signal clk, wr, rd, empty, full : std_logic := '0';
    signal w_data, r_data : std_logic_vector(WIDTH-1 downto 0);
    
    -- Clock period definition
    constant clk_period : time := 10 ns;
begin
    -- Init the component
    uut : FIFO port map(clk => clk, wr => wr, rd => rd, w_data => w_data, empty => empty, full => full, r_data => r_data);
    
    -- Clock period definition
    clk_proc : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    test_proc : process
    begin
        wr <= '0';
        rd <= '0';
        wait for clk_period;
        
        -- 8 writes
        for i in 0 to 7 loop
            wr <= '1';
            w_data <= std_logic_vector(to_unsigned(i, WIDTH));
            wait for clk_period;
        end loop;
        
        wr <= '1';
        w_data <= std_logic_vector(to_unsigned(10, WIDTH));
        wait for clk_period;
        
        -- 4 reads
        for i in 0 to 3 loop
            rd <= '1';
            wr <= '0';
            wait for clk_period;
        end loop;
        
        -- 4 writes
        for i in 0 to 3 loop
            wr <= '1';
            rd <= '0';
            w_data <= std_logic_vector(to_unsigned(i, WIDTH));
            wait for clk_period;
        end loop;
        
        -- 7 reads + 1 other read
        for i in 0 to 8 loop
            rd <= '1';
            wr <= '0';
            wait for clk_period;
        end loop;
        
        -- 8 writes
        for i in 0 to 7 loop
            wr <= '1';
            w_data <= std_logic_vector(to_unsigned(i, WIDTH));
            wait for clk_period;
        end loop;
        
        wr <= '1';
        w_data <= std_logic_vector(to_unsigned(10, WIDTH));
        wait for clk_period;
        
        -- 7 reads + 1 other read
        for i in 0 to 8 loop
            rd <= '1';
            wr <= '0';
            wait for clk_period;
        end loop;
        
        wait;
    end process;
    
    -- Test processes
    -- Write
    --write_proc : process
    --begin
    --    wait for 10 ns;
    --    wr <= '0';
    --    w_data <= std_logic_vector(to_unsigned(0, WIDTH));
    --    
    --    for i in 0 to 10 loop
    --        wr <= '1';
    --        w_data <= std_logic_vector(to_unsigned(i, WIDTH));
    --        wait for clk_period;
    --        
    --        if full = '1' then
    --            wr <= '0';
    --            wait for clk_period;
    --            while full = '1' loop
    --                wait for clk_period;
    --            end loop;
    --            wait for clk_period;
    --        end if;
    --        
    --        wr <= '0';
    --        wait for clk_period;
    --    end loop;
    --    
    --    wait;
    --end process;
    --
    -- Read
    --read_proc: process
    --begin
    --    wait for clk_period * 4;
    --    
    --    for i in 0 to 10 loop
    --        rd <= '1';
    --        wait for clk_period;
    --        
    --        rd <= '0';
    --        wait for clk_period;
    --    end loop;
    --    
    --    wait;
    --end process;
end Behavior;

