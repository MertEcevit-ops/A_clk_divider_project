library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_controller is
    Port (
        clk : in STD_LOGIC;  -- 100kHz external clock
        reset : in STD_LOGIC;
        switches : in STD_LOGIC_VECTOR(2 downto 0);  -- SW0, SW1, SW2
        led_out : out STD_LOGIC;
        led_pulse : out STD_LOGIC  -- Pulse counter için
    );
end led_controller;

architecture Behavioral of led_controller is
    -- Separate counters for each frequency
    signal counter_2hz : integer range 0 to 24999 := 0;    -- 2Hz counter
    signal counter_1hz : integer range 0 to 49999 := 0;    -- 1Hz counter  
    signal counter_0_5hz : integer range 0 to 99999 := 0;  -- 0.5Hz counter
    
    -- LED signals
    signal led_2hz : STD_LOGIC := '0';
    signal led_1hz : STD_LOGIC := '0';
    signal led_0_5hz : STD_LOGIC := '0';
    signal current_led : STD_LOGIC := '0';
    signal prev_led : STD_LOGIC := '0';
    
begin
    -- 2Hz frequency generation
    process(clk, reset)
    begin
        if reset = '1' then
            counter_2hz <= 0;
            led_2hz <= '0';
        elsif rising_edge(clk) then
            if counter_2hz = 24999 then  -- 100kHz / 25000 = 2Hz (toggle every 25k cycles)
                counter_2hz <= 0;
                led_2hz <= not led_2hz;
            else
                counter_2hz <= counter_2hz + 1;
            end if;
        end if;
    end process;
    
    -- 1Hz frequency generation
    process(clk, reset)
    begin
        if reset = '1' then
            counter_1hz <= 0;
            led_1hz <= '0';
        elsif rising_edge(clk) then
            if counter_1hz = 49999 then  -- 100kHz / 50000 = 1Hz (toggle every 50k cycles)
                counter_1hz <= 0;
                led_1hz <= not led_1hz;
            else
                counter_1hz <= counter_1hz + 1;
            end if;
        end if;
    end process;
    
    -- 0.5Hz frequency generation
    process(clk, reset)
    begin
        if reset = '1' then
            counter_0_5hz <= 0;
            led_0_5hz <= '0';
        elsif rising_edge(clk) then
            if counter_0_5hz = 99999 then  -- 100kHz / 100000 = 0.5Hz (toggle every 100k cycles)
                counter_0_5hz <= 0;
                led_0_5hz <= not led_0_5hz;
            else
                counter_0_5hz <= counter_0_5hz + 1;
            end if;
        end if;
    end process;
    
    -- Switch priority system
    process(switches, led_2hz, led_1hz, led_0_5hz)
    begin
        if switches(0) = '1' then      -- SW0 (2Hz) - highest priority
            current_led <= led_2hz;
        elsif switches(1) = '1' then   -- SW1 (1Hz)
            current_led <= led_1hz;
        elsif switches(2) = '1' then   -- SW2 (0.5Hz)
            current_led <= led_0_5hz;
        else
            current_led <= '0';
        end if;
    end process;
    
    -- Pulse detection for counter
    process(clk, reset)
    begin
        if reset = '1' then
            prev_led <= '0';
        elsif rising_edge(clk) then
            prev_led <= current_led;
        end if;
    end process;
    
    led_out <= current_led;
    led_pulse <= current_led and not prev_led;
    
end Behavioral;