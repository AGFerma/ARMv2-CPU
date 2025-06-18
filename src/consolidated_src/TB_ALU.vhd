library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use Work.all;

entity TB_ALU is
end entity;

architecture TB of TB_ALU is 

signal op1 :  std_logic_vector(31 downto 0);
signal op2 :  std_logic_vector(31 downto 0);
signal cin :  std_logic;
signal cmd :  std_logic_vector(1 downto 0);

signal res :  std_logic_vector(31 downto 0);
signal cout :  std_logic;
signal z :  std_logic;
signal n :  std_logic;
signal v :  std_logic;
signal vdd :  bit;
signal vss :  bit;

begin
    import_alu : entity work.ALU(structural)
    port map(op1,op2,cin,cmd,res,cout,z,n,v,vdd,vss);

    op1<=(31 downto 28 =>'1',8=>'1',others=>'0'), (others=>'1') after 10 ns,(others=>'1') after 15 ns, (others=>'1') after 20 ns,(30 downto 28 =>'1',8=>'1',others=>'0') after 40 ns ;
    op2<=(31 downto 28 =>'1',others=>'0'), (others=>'0') after 10 ns, (others=>'1') after 20 ns, (30 downto 28 =>'1',8=>'1',others=>'0') after 40 ns;
    cin<='0', '1' after 5 ns;
    cmd <="00" , "01" after 45 ns, "10" after 60 ns, "11" after 70 ns; 
    
end TB; 
