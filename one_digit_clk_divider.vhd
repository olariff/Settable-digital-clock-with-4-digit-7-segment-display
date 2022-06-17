
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


-- This is the code for the Clock divider to multiplex through the segments
--declare the necessary ports
entity one_digit_clk_divider is
    Port ( ck : in STD_LOGIC;
    y : out STD_LOGIC_VECTOR (1 downto 0);
    ck_out : out STD_LOGIC
    );
end one_digit_clk_divider;

architecture Behavioral of one_digit_clk_divider is

-- declare signals for use in clock process
Signal count : INTEGER := 0;
Signal a : STD_LOGIC := '0';
Signal ckdiv: STD_LOGIC_VECTOR (20 downto 0);

begin

    
    y <= ckdiv(20 downto 19);
     
     -- Process for the clock divider   
     process(ck)
        begin
        
            -- when a rising clock edge occurs
            if ck'event and ck = '1' then
                ckdiv <= ckdiv + 1;
                count <= count + 1;
            
               
            if(count = 100000) then
--                a <= not a;
                count <= 0;   
                 
            end if;
            end if;
--            ck_out <= a;
    end process;       

end Behavioral;
