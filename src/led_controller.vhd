library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_controller is
    Port (
        clk : in STD_LOGIC;  -- 100kHz external clock
        reset : in STD_LOGIC;
        switches : in STD_LOGIC_VECTOR(2 downto 0);  -- SW1, SW2, SW3
        led_out : out STD_LOGIC;
        led_pulse : out STD_LOGIC  -- Pulse counter için
    );
end led_controller;

architecture Behavioral of led_controller is
    signal counter : integer range 0 to 99999 := 0;
    signal led_2hz : STD_LOGIC := '0';
    signal led_1hz : STD_LOGIC := '0';
    signal led_0_5hz : STD_LOGIC := '0';
    signal current_led : STD_LOGIC := '0';
    signal prev_led : STD_LOGIC := '0';
    
begin
    -- Frekans üretimi (100kHz clock ile)
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            led_2hz <= '0';
            led_1hz <= '0';
            led_0_5hz <= '0';
        elsif rising_edge(clk) then
            counter <= counter + 1;
            
            -- 2Hz: 100kHz / 50000 = 2Hz
            if counter = 24999 then
                led_2hz <= not led_2hz;
            end if;
            
            -- 1Hz: 100kHz / 100000 = 1Hz
            if counter = 49999 then
                led_1hz <= not led_1hz;
            end if;
            
            -- 0.5Hz: 100kHz / 200000 = 0.5Hz
            if counter = 99999 then
                led_0_5hz <= not led_0_5hz;
                counter <= 0;
            end if;
        end if;
    end process;
    
    -- Switch öncelik sistemi
    process(switches, led_2hz, led_1hz, led_0_5hz)
    begin
        if switches(0) = '1' then      -- SW1 (2Hz)
            current_led <= led_2hz;
        elsif switches(1) = '1' then   -- SW2 (1Hz)
            current_led <= led_1hz;
        elsif switches(2) = '1' then   -- SW3 (0.5Hz)
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
    led_pulse <= current_led and not prev_led;  -- Rising edge detection
    
end Behavioral;