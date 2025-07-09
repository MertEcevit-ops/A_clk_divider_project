library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity seven_segment_driver is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        count_in : in STD_LOGIC_VECTOR(15 downto 0);
        seg : out STD_LOGIC_VECTOR(6 downto 0);
        an : out STD_LOGIC_VECTOR(3 downto 0)
    );
end seven_segment_driver;

architecture Behavioral of seven_segment_driver is
    signal refresh_counter : unsigned(19 downto 0) := (x"00000");
    signal refresh_select : STD_LOGIC_VECTOR(1 downto 0);
    signal digit_value : STD_LOGIC_VECTOR(3 downto 0);
    
    -- BCD digits (4 bit each)
    signal digit0, digit1, digit2, digit3 : STD_LOGIC_VECTOR(3 downto 0);
    
    -- Internal signals for conversion
    signal count_reg : unsigned(15 downto 0);
    
begin
    -- Register the input
    process(clk, reset)
    begin
        if reset = '1' then
            count_reg <= (others => '0');
        elsif rising_edge(clk) then
            count_reg <= unsigned(count_in);
        end if;
    end process;
    
    -- Binary to BCD conversion process
    process(count_reg)
        variable temp_count : unsigned(15 downto 0);
        variable ones_var : unsigned(15 downto 0);
        variable tens_var : unsigned(15 downto 0);
        variable hundreds_var : unsigned(15 downto 0);
        variable thousands_var : unsigned(15 downto 0);
    begin
        temp_count := count_reg;
        
        -- Calculate individual digits
        ones_var := temp_count mod 10;
        tens_var := (temp_count / 10) mod 10;
        hundreds_var := (temp_count / 100) mod 10;
        thousands_var := (temp_count / 1000) mod 10;
        
        -- Convert to 4-bit STD_LOGIC_VECTOR
        digit0 <= STD_LOGIC_VECTOR(ones_var(3 downto 0));
        digit1 <= STD_LOGIC_VECTOR(tens_var(3 downto 0));
        digit2 <= STD_LOGIC_VECTOR(hundreds_var(3 downto 0));
        digit3 <= STD_LOGIC_VECTOR(thousands_var(3 downto 0));
    end process;
    
    -- Refresh counter for digit multiplexing
    process(clk, reset)
    begin
        if reset = '1' then
            refresh_counter <= (others => '0');
        elsif rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    
    -- Use top 2 bits for digit selection (refresh rate ~100Hz)
    refresh_select <= STD_LOGIC_VECTOR(refresh_counter(19 downto 18));
    
    -- Digit selection multiplexer
    process(refresh_select, digit0, digit1, digit2, digit3)
    begin
        case refresh_select is
            when "00" =>
                digit_value <= digit0;  -- ones
            when "01" =>
                digit_value <= digit1;  -- tens
            when "10" =>
                digit_value <= digit2;  -- hundreds
            when "11" =>
                digit_value <= digit3;  -- thousands
            when others =>
                digit_value <= "0000";
        end case;
    end process;
    
    -- Anode control (active low) - determines which digit is active
    process(refresh_select)
    begin
        case refresh_select is
            when "00" =>
                an <= "1110";  -- activate digit 0 (rightmost)
            when "01" =>
                an <= "1101";  -- activate digit 1
            when "10" =>
                an <= "1011";  -- activate digit 2
            when "11" =>
                an <= "0111";  -- activate digit 3 (leftmost)
            when others =>
                an <= "1111";  -- all digits off
        end case;
    end process;
    
    -- 7-segment decoder (active low segments)
    process(digit_value)
    begin
        case digit_value is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when "1010" => seg <= "0001000"; -- A (10)
            when "1011" => seg <= "0000011"; -- B (11)
            when "1100" => seg <= "1000110"; -- C (12)
            when "1101" => seg <= "0100001"; -- D (13)
            when "1110" => seg <= "0000110"; -- E (14)
            when "1111" => seg <= "0001110"; -- F (15)
            when others => seg <= "1111111"; -- blank
        end case;
    end process;
    
end Behavioral;