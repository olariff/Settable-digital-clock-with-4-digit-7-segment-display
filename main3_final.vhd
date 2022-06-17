
-- Description:    main file for final design
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- declare the necessary ports as seen on the constraint file
entity main3_final is port (
   sw : in UNSIGNED (15 downto 0);
   clk  : in  STD_LOGIC;
   btnU, btnD,  btnC, btnR, btnL  : in  STD_LOGIC;--btnL, btnR,
   seg  : out STD_LOGIC_VECTOR (6 downto 0);
   dp  : out STD_LOGIC;
   an   : out STD_LOGIC_VECTOR (3 downto 0));
   
end main3_final;

architecture Behavioral of main3_final is

begin

-- Port map four_digit to main3_final
four_digits_unit : entity work.four_digits(Behavioral)
        Port map(sw => sw, an => an, seg => seg, ck => clk, dp => dp, btnC => btnC, btnU => btnU, btnD => btnD, btnR => btnR, btnL => btnL
        );
        

end Behavioral;
