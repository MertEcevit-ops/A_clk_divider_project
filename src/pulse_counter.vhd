library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pulse_counter is
    Port (
        clk_25mhz : in STD_LOGIC;
        reset : in STD_LOGIC;
        pulse_in : in STD_LOGIC;
        count_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end pulse_counter;

architecture Behavioral of pulse_counter is
    signal pulse_sync : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal pulse_edge : STD_LOGIC;
    signal counter : unsigned(15 downto 0) := (others => '0');
    
begin
    -- Pulse synchronization (clock domain crossing)
    process(clk_25mhz, reset)
    begin
        if reset = '1' then
            pulse_sync <= (others => '0');
        elsif rising_edge(clk_25mhz) then
            pulse_sync <= pulse_sync(1 downto 0) & pulse_in;
        end if;
    end process;
    
    -- Edge detection
    pulse_edge <= pulse_sync(1) and not pulse_sync(2);
    
    -- Counter
    process(clk_25mhz, reset)
    begin
        if reset = '1' then
            counter <= (others => '0');
        elsif rising_edge(clk_25mhz) then
            if pulse_edge = '1' then
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    count_out <= STD_LOGIC_VECTOR(counter);
    
end Behavioral;