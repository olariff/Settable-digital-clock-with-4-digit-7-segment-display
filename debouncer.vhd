


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- This is the code for the debouncer to register a single click of a button as a single pulse
-- declare all button ports, clock ports and the single pulse variables of the buttons
entity debouncer is
    Port ( btnC : in STD_LOGIC;
           btnU : in STD_LOGIC;
           btnD : in STD_LOGIC;
           btnR : in STD_LOGIC;
           btnL : in STD_LOGIC;
           btnU_pulse : inout STD_LOGIC;
           btnD_pulse : inout STD_LOGIC;
           btnR_pulse : inout STD_LOGIC;
           btnL_pulse : inout STD_LOGIC;
           btnC_pulse : inout STD_LOGIC;
           clk : in STD_LOGIC
           );
end debouncer;


architecture Behavioral of debouncer is

-- declare the necessary signals to be used on the process
Signal count : INTEGER := 0;

-- create a state machine with two states no_action and hold_on
type state_type is (no_action,hold_on);

-- declare initial state at which the process begins
Signal state: state_type := no_action;
Signal a : STD_LOGIC := '0';
constant delay: integer := 50000000;

begin

-- begin process
process(clk)
begin
    
    -- at the next lock rising edge, execute the case statement
    if(rising_edge(clk)) then
        case(state) is
            when no_action =>
                
                -- if and elsif statements to check if any of the buttons are pressed, if so move on to the next state (hold on)
                if(btnU = '1') then
                    state <= hold_on;
                
                elsif(btnD = '1') then
                    state <= hold_on;
                
                elsif(btnR = '1') then
                    state <= hold_on;
                    
                elsif(btnL = '1') then
                    state <= hold_on;
                     
                --if no button is pressed remain in this state (no_action)            
                else
                    state <= no_action;
                    
                end if;
                btnU_pulse <= '0';
                btnD_pulse <= '0';
                btnR_pulse <= '0';
                btnL_pulse <= '0';
                
            when hold_on =>
                -- declare the count that serves as the wait time before the button can be pressed again, in this case it is about half a second
                if(count = 25000000) then
                    count <= 0;
                    
                    -- check if any buttons are pressed, if so set their pulse to 1
                    if(btnU = '1') then
                        btnU_pulse <= '1';
                        
                    elsif(btnD = '1') then
                        btnD_pulse <= '1';    
                    
                    elsif(btnR = '1') then
                        btnR_pulse <= '1';    
                        
                    elsif(btnL = '1') then
                        btnL_pulse <= '1';
                        
                    -- if no button is pressed, return to the previous state (no_action)
                    end if;
                    state <= no_action;
                    
                else
                    count <= count + 1;
                    
                end if;
            end case;                           
        end if;    
end process;


end Behavioral;
