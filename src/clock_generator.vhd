library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_generator is
    Port (
        clk_100mhz : in STD_LOGIC;
        reset : in STD_LOGIC;
        clk_25mhz : out STD_LOGIC;
        clk_100khz : out STD_LOGIC
    );
end clock_generator;

architecture Behavioral of clock_generator is
    signal clk_25mhz_int : STD_LOGIC := '0';
    signal clk_100khz_int : STD_LOGIC := '0';
    signal counter_25mhz : integer range 0 to 1 := 0;
    signal counter_100khz : integer range 0 to 499 := 0;
    
begin
    -- 25MHz clock üretimi (100MHz / 4 = 25MHz)
    process(clk_100mhz, reset)
    begin
        if reset = '1' then
            clk_25mhz_int <= '0';
            counter_25mhz <= 0;
        elsif rising_edge(clk_100mhz) then
            if counter_25mhz = 1 then
                counter_25mhz <= 0;
                clk_25mhz_int <= not clk_25mhz_int;
            else
                counter_25mhz <= counter_25mhz + 1;
            end if;
        end if;
    end process;
    
    -- 100kHz clock üretimi (100MHz / 1000 = 100kHz)
    process(clk_100mhz, reset)
    begin
        if reset = '1' then
            clk_100khz_int <= '0';
            counter_100khz <= 0;
        elsif rising_edge(clk_100mhz) then
            if counter_100khz = 499 then
                counter_100khz <= 0;
                clk_100khz_int <= not clk_100khz_int;
            else
                counter_100khz <= counter_100khz + 1;
            end if;
        end if;
    end process;
    
    clk_25mhz <= clk_25mhz_int;
    clk_100khz <= clk_100khz_int;
    
end Behavioral;