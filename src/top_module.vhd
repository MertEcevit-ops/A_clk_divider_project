library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_module is
    Port (
        clk : in STD_LOGIC;  -- 100MHz system clock
        btnC : in STD_LOGIC;  -- Reset button
        sw : in STD_LOGIC_VECTOR(2 downto 0);  -- Switches
        led : out STD_LOGIC_VECTOR(0 downto 0);  -- LED output
        seg : out STD_LOGIC_VECTOR(6 downto 0);  -- 7-segment segments
        an : out STD_LOGIC_VECTOR(3 downto 0);   -- 7-segment anodes
        JA : inout STD_LOGIC_VECTOR(1 downto 0)  -- PMOD pins
    );
end top_module;

architecture Behavioral of top_module is
    -- Internal signals
    signal reset : STD_LOGIC;
    signal clk_25mhz : STD_LOGIC;
    signal clk_100khz : STD_LOGIC;
    signal external_clk : STD_LOGIC;
    signal clk_led : STD_LOGIC;  -- MISSING SIGNAL DECLARATION - FIXED
    signal led_pulse : STD_LOGIC;
    signal pulse_count : STD_LOGIC_VECTOR(15 downto 0);
    
    -- Component declarations
    component clock_generator
        Port (
            clk_100mhz : in STD_LOGIC;
            reset : in STD_LOGIC;
            clk_25mhz : out STD_LOGIC;
            clk_100khz : out STD_LOGIC
        );
    end component;
    
    component led_controller
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            switches : in STD_LOGIC_VECTOR(2 downto 0);
            led_out : out STD_LOGIC;
            led_pulse : out STD_LOGIC
        );
    end component;
    
    component pulse_counter
        Port (
            clk_25mhz : in STD_LOGIC;
            reset : in STD_LOGIC;
            pulse_in : in STD_LOGIC;
            count_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    
    component seven_segment_driver
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            count_in : in STD_LOGIC_VECTOR(15 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0);
            an : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;

    component asynch_sync is  -- FIXED: Added full component declaration with generics
        generic (
            VENDOR              : string               := "XILINX";
            RESET_ACTIVE_STATUS : std_logic            := '1';
            SYNCH_FF_NUMBER     : natural range 2 to 5 := 3
        );
        port (
            clk_25mhz   : in std_logic;
            reset       : in std_logic;
            clk_ext     : in std_logic;
            clk_led     : out std_logic
        );
    end component;
    
begin
    -- Reset logic (active high)
    reset <= btnC;
    
    -- PMOD connections
    JA(0) <= clk_100khz;      -- Output 100kHz clock
    external_clk <= JA(1);    -- Input external clock
    
    -- Component instantiations
    clock_gen_inst: clock_generator
        port map (
            clk_100mhz => clk,
            reset => reset,
            clk_25mhz => clk_25mhz,
            clk_100khz => clk_100khz
        );
    
    cdc_inst: asynch_sync
        generic map (
            VENDOR => "XILINX",
            RESET_ACTIVE_STATUS => '1',
            SYNCH_FF_NUMBER => 3
        )
        port map (
            clk_25mhz => clk_25mhz,
            reset     => reset,
            clk_ext   => external_clk,
            clk_led   => clk_led
        );
    
    led_ctrl_inst: led_controller
        port map (
            clk => clk_led,
            reset => reset,
            switches => sw,
            led_out => led(0),
            led_pulse => led_pulse
        );
    
    pulse_cnt_inst: pulse_counter
        port map (
            clk_25mhz => clk_25mhz,
            reset => reset,
            pulse_in => led_pulse,
            count_out => pulse_count
        );
    
    seg_driver_inst: seven_segment_driver
        port map (
            clk => clk_25mhz,
            reset => reset,
            count_in => pulse_count,
            seg => seg,
            an => an
        );
    
end Behavioral;