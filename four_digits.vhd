
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

library UNISIM;
use UNISIM.VComponents.all;

-- declare the necessary ports
entity four_digits is

    Port ( 
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           ck_out : out STD_LOGIC;
           sw : UNSIGNED(15 downto 0);
           dp  : out STD_LOGIC;
           btnC : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnU_pulse : inout STD_LOGIC;
           btnD_pulse : inout STD_LOGIC;
           btnR_pulse : inout STD_LOGIC;
           btnL_pulse : inout STD_LOGIC;
           btnR : in STD_LOGIC;
           btnL : in STD_LOGIC;
           ck : in STD_LOGIC              
           );
end four_digits;

architecture Behavioral of four_digits is

-- declare the signal variables for easy use in the processes

Signal y : STD_LOGIC_VECTOR (1 downto 0);
Signal d: UNSIGNED (3 downto 0);
Signal ckdiv: STD_LOGIC_VECTOR (20 downto 0);

Signal d0: UNSIGNED (3 downto 0):="0000";
Signal d1: UNSIGNED (7 downto 4):="0000";
Signal d2: UNSIGNED (11 downto 8):="0000";
Signal d3: UNSIGNED (15 downto 12):="0000";
Signal d4: UNSIGNED (19 downto 16):="0000";
Signal d5: UNSIGNED (22 downto 19):="0000";
Signal under_sec : UNSIGNED (26 downto 23):="0000";

Signal count : INTEGER := 0;
Signal a : STD_LOGIC := '0';
Signal clk_counter : natural range 0 to 50000000 := 0;
Signal x : STD_LOGIC_VECTOR (15 downto 0);
Signal flag : UNSIGNED (3 downto 0):="0000";

begin
    
    -- Port map the ports from clock divider to four_digits
    
    one_digit_clk_divider_unit : entity work.one_digit_clk_divider(Behavioral)
            Port map (ck => ck, ck_out => ck_out, y => y); 
    
    --  Port map all the ports from the debouncer to the four digit decoder
    debouncer_unit : entity work.debouncer(Behavioral)
    Port map(clk => ck, btnC => btnC, btnU => btnU, btnD => btnD, btnL => btnL, btnR => btnR,  btnU_pulse => btnU_pulse,
        btnD_pulse => btnD_pulse, btnR_pulse => btnR_pulse, btnL_pulse => btnL_pulse
            );      
    

-- Begin a process for the multiplexing of the four digit segment display using the two bits of the y signal as the select inputs, s0 and s1
-- The segment is driven for each select input case
    process(y)
        begin
            case y is
                 
                when "00" => d <= d2;
                    an(0) <= '0';
                    an(1) <= '1';
                    an(2) <= '1';
                    an(3) <= '1';
                    
                    case d2 is
                        when "0000" => seg <= "1000000"; -- "0"
                        when "0001" => seg <= "1111001"; -- "1"
                        when "0010" => seg <= "0100100"; -- "2"
                        when "0011" => seg <= "0110000"; -- "3"
                        when "0100" => seg <= "0011001"; -- "4"
                        when "0101" => seg <= "0010010"; -- "5"
                        when "0110" => seg <= "0000010"; -- "6"
                        when "0111" => seg <= "1111000"; -- "7"
                        when "1000" => seg <= "0000000"; -- "8"
                        when "1001" => seg <= "0010000"; -- "9"
                        when others => seg <= "1000000";
                     end case;
                    
                when "01" => d <= d3;
                    an(0) <= '1';
                    an(1) <= '0';
                    an(2) <= '1';
                    an(3) <= '1';
                    
                    case d3 is
                        when "0000" => seg <= "1000000"; -- "0"
                        when "0001" => seg <= "1111001"; -- "1"
                        when "0010" => seg <= "0100100"; -- "2"
                        when "0011" => seg <= "0110000"; -- "3"
                        when "0100" => seg <= "0011001"; -- "4"
                        when "0101" => seg <= "0010010"; -- "5"                    
                        when others => seg <= "1000000";
                     end case;
                    
                when "10" => d <= d4;
                    an(0) <= '1';
                    an(1) <= '1';
                    an(2) <= '0';
                    an(3) <= '1';
                    
                    case d4 is
                        when "0000" => seg <= "1000000"; -- "0"
                        when "0001" => seg <= "1111001"; -- "1"
                        when "0010" => seg <= "0100100"; -- "2"
                        when "0011" => seg <= "0110000"; -- "3"
                        when "0100" => seg <= "0011001"; -- "4"
                        when "0101" => seg <= "0010010"; -- "5"
                        when "0110" => seg <= "0000010"; -- "6"
                        when "0111" => seg <= "1111000"; -- "7"
                        when "1000" => seg <= "0000000"; -- "8"
                        when "1001" => seg <= "0010000"; -- "9"
                        when others => seg <= "1000000";
                     end case;
                    
                when others => d <= d5;
                    an(0) <= '1';
                    an(1) <= '1';
                    an(2) <= '1';
                    an(3) <= '0';
                    
                    case d5 is
                        when "0000" => seg <= "1000000"; -- "0"
                        when "0001" => seg <= "1111001"; -- "1"
                        when "0010" => seg <= "0100100"; -- "2"
--                        when "0011" => seg <= "0110000"; -- "3"
--                        when "0100" => seg <= "0011001"; -- "4"
--                        when "0101" => seg <= "0010010"; -- "5"
                        when others => seg <= "1000000";
                     end case;
                    
           end case;
      end process;
       
       
-- Begin another process for the up counter of each segment, allowing each segment to stop and restart counting
--  at a particular number and also set the number on each segment manually        
       process(ck)
       begin
           if rising_edge(ck) then
                clk_counter <= clk_counter + 1;
--           dp <= '0';

--select the which anode you want to change on the 4 digit seven segment display 

            if btnL_pulse = '1' and flag /= 3 then
                flag <= flag + "0001";
            end if;  
            
            if btnR_pulse = '1' and flag /= 0 then
                flag <= flag - "0001";
            end if;   
            
            -- Depending on the anode selected (flag), this code is written to change the number on that anode within the 24hr range using the up and down buttons
            if flag = 0 then

                if btnD_pulse = '1' then
                    if d2  = 0 then
                        d2 <= d2;
                    else    
                        d2 <= d2 - "0001";
                    end if;           
    
                elsif btnU_pulse = '1' then   
                        d2 <= d2 + 1;
                    
                else    
                        d2 <= d2;    
                      
                end if;      
            end if;  
              
              if flag = 1 then

                if btnD_pulse = '1' then

                    if d3  = 0 then
                        d3 <= d3;
                    else    
                        d3 <= d3 - 1;
                    end if;           
                
                elsif btnU_pulse = '1' then
  
                        d3 <= d3 + 1;
                    
                else    
                        d3 <= d3;      
                end if; 
              end if;
              
              if flag = 2 then

            if btnD_pulse = '1' then

                    if d4  = 0 then
                        d4 <= d4;
                    else    
                        d4 <= d4 - 1;
                end if;        
   
                
                elsif btnU_pulse = '1' then    
                        d4 <= d4 + 1; 
                    
                else    
                        d4 <= d4;     
                end if; 
              end if;
              
              if flag = 3 then
                
            if btnD_pulse = '1' then

                    if d5 = 0 then
                        d5 <= d5;
                    else    
                        d5 <= d5 - 1;
                end if;            
                
                elsif btnU_pulse = '1' then
   
                        d5 <= d5 + 1;
                    
                else    
                        d5 <= d5;      
                end if;
              end if;      
              
              -- code for the counting up of the seven segment clock  
              if clk_counter >= 50000000 then
                    a <= not a;
                    clk_counter <= 0;
                    under_sec <= under_sec + "0001";
                    
                    -- enables the clock to move by the second
                    if under_sec > 0 then
                        under_sec <= "0000";
                        d0 <= d0 + "0001";
                    
                    -- the second unit cannot be greater than 9
                    if d0 > 8 then
                        d0 <= "0000";
                        d1 <= d1 + "0001";
                    
                    -- the second tens cannot be greater than 5
                    if d1 > 4 then
                        d1 <= "0000";
                        d2 <= d2 + "0001";
                    
                    -- the minute unit cannot be greater than 9    
                    if d2 > 8 then
                        d2 <= "0000";
                        d3 <= d3 + "0001";
                    
                    -- the minute tens cannot be greater than 5    
                    if d3 > 4 then
                        d3 <= "0000";
                        d4 <= d4 + "0001";
                    
                    -- the hour unit cannot be greater than 9    
                    if d4 > 8 then
                        d4 <= "0000";
                        d5 <= d3 + "0001";
                    
                    -- the hour tens cannot be greater than 2    
                    if d5 > 1 then
                        d5 <= "0000";
                    
                    -- when the hours' ten is on 2, the hour unit cannot be greater than 4, as it is a 24hr clock    
                    if d5 > 1 and d4 > 3 then
                        d4 <= "0000";
                        d5 <= "0000";
                        end if;
                        
                    end if;  
                        
                    end if;        
                        
                    end if;  
                        
                    end if;    
                        
                    end if;    
                    end if; 
                       
                end if;    
             end if;
             end if;  
        end process;             
       
end Behavioral;
