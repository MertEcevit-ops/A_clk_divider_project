-- Description       : One bit data synchronizer chain with generics for CDC

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity asynch_sync is
    generic (
        VENDOR              : string               := "XILINX"; --"XILINX", "ALTERA", "GOWIN"
        RESET_ACTIVE_STATUS : std_logic            := '1';-- '0': active low, '1': active high
        SYNCH_FF_NUMBER     : natural range 2 to 5 := 3 -- Adjust according to metastability requirements
    );
    port (
        clk_25mhz   : in std_logic;
        reset       : in std_logic;
        clk_ext     : in std_logic;
        clk_led     : out std_logic
    );
end asynch_sync;

architecture rtl of asynch_sync is
    
begin
    -- Xilinx-specific implementation
    xilinx_gen : if VENDOR = "XILINX" generate
        
        signal sync_reg : std_logic_vector(SYNCH_FF_NUMBER-1 downto 0) := (others => '0');
        
        -- XILINX Attributes applied to the signal
        attribute ASYNC_REG                 : string;
        attribute ASYNC_REG  of sync_reg    : signal is "true";
        attribute DONT_TOUCH                : string;
        attribute DONT_TOUCH of sync_reg    : signal is "true";
    begin
        xilinx_sync : process (clk_25mhz, reset)
        begin
            if reset = RESET_ACTIVE_STATUS then
                sync_reg <= (others => '0');
            elsif rising_edge(clk_25mhz) then  
                sync_reg <= sync_reg(SYNCH_FF_NUMBER-2 downto 0) & clk_ext;
            end if;
        end process xilinx_sync;

        clk_led <= sync_reg(SYNCH_FF_NUMBER-1); 
    end generate xilinx_gen;
    
    -- Optional: Add other vendor implementations
    altera_gen : if VENDOR = "ALTERA" generate
        signal sync_reg : std_logic_vector(SYNCH_FF_NUMBER-1 downto 0) := (others => '0');
        
        -- Altera-specific attributes (if needed)
        attribute preserve                  : boolean;
        attribute preserve of sync_reg      : signal is true;
    begin
        altera_sync : process (clk_25mhz, reset)
        begin
            if reset = RESET_ACTIVE_STATUS then
                sync_reg <= (others => '0');
            elsif rising_edge(clk_25mhz) then  
                sync_reg <= sync_reg(SYNCH_FF_NUMBER-2 downto 0) & clk_ext;
            end if;
        end process altera_sync;

        clk_led <= sync_reg(SYNCH_FF_NUMBER-1); 
    end generate altera_gen;
    
    -- Generic implementation (no vendor-specific attributes)
    generic_gen : if VENDOR /= "XILINX" and VENDOR /= "ALTERA" generate
        signal sync_reg : std_logic_vector(SYNCH_FF_NUMBER-1 downto 0) := (others => '0');
    begin
        generic_sync : process (clk_25mhz, reset)
        begin
            if reset = RESET_ACTIVE_STATUS then
                sync_reg <= (others => '0');
            elsif rising_edge(clk_25mhz) then  
                sync_reg <= sync_reg(SYNCH_FF_NUMBER-2 downto 0) & clk_ext;
            end if;
        end process generic_sync;

        clk_led <= sync_reg(SYNCH_FF_NUMBER-1); 
    end generate generic_gen;

end rtl;