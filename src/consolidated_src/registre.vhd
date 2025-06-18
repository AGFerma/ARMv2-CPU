library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registre is
    port(clk:in std_logic;
        reset_n: in std_logic;
        din:in std_logic_vector(31 downto 0);
        dout:out std_logic_vector(31 downto 0);
        vdd : in bit;
        vss : in bit);
end registre;


architecture Behavior OF Registre is
    begin
        process(clk,reset_n)
        begin
            if rising_edge(clk) then 
                if reset_n= '0' then 
                    dout<= (others=>'0');
                else
                    dout<=din;
                end if;
            end if;
        
        end process;

end Behavior;
        
