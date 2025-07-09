library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity testbench is
end testbench;

architecture Behavioral of testbench is
    component top_module
        Port (
            clk : in STD_LOGIC;
            btnC : in STD_LOGIC;
            sw : in STD_LOGIC_VECTOR(2 downto 0);
            led : out STD_LOGIC_VECTOR(0 downto 0);
            seg : out STD_LOGIC_VECTOR(6 downto 0);
            an : out STD_LOGIC_VECTOR(3 downto 0);
            JA : inout STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
    
    signal clk : STD_LOGIC := '0';
    signal btnC : STD_LOGIC := '0';
    signal sw : STD_LOGIC_VECTOR(2 downto 0) := "000";
    signal led : STD_LOGIC_VECTOR(0 downto 0);
    signal seg : STD_LOGIC_VECTOR(6 downto 0);
    signal an : STD_LOGIC_VECTOR(3 downto 0);
    signal JA : STD_LOGIC_VECTOR(1 downto 0);
    
    constant clk_period : time := 10 ns;
    
begin
    uut: top_module
        port map (
            clk => clk,
            btnC => btnC,
            sw => sw,
            led => led,
            seg => seg,
            an => an,
            JA => JA
        );
    
    -- Clock generation
    clk <= not clk after clk_period/2;
    
    -- PMOD loopback
    JA(1) <= JA(0);
    
    -- Test process
    process
    begin
        -- Reset
        btnC <= '1';
        wait for 100 ns;
        btnC <= '0';
        wait for 100 ns;
        
        -- Test switch 1 (2Hz)
        sw <= "001";
        wait for 10 ms;
        
        -- Test switch 2 (1Hz)
        sw <= "010";
        wait for 10 ms;
        
        -- Test switch 3 (0.5Hz)
        sw <= "100";
        wait for 10 ms;
        
        wait;
    end process;
    
end Behavioral;