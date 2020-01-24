-- Counter
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Counter is
  generic (
    G_WIDTH : positive
  );
  port (
    Clk_ik     : in  std_logic;
    Reset_ir   : in  std_logic;
    Value_ob   : out unsigned(G_WIDTH-1 downto 0);
    Overflow_o : out std_logic := '0'
  );
end entity;

architecture RTL of Counter is

  signal Value_b : unsigned(G_WIDTH-1 downto 0) := (others => '0');

begin

  p_Counter: process (Clk_ik) is begin
    if rising_edge(Clk_ik) then
      if Reset_ir then
        Value_b    <= (others => '0');
        Overflow_o <= '0';
      else
        Value_b    <= Value_b + 1;
        Overflow_o <= and Value_b;
      end if;
    end if;
  end process;
  
  Value_ob <= Value_b;
   
end architecture;
