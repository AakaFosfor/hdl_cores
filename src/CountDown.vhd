-- CountDown
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.Functions_pkg.all;

--! @brief Count down with reset
entity CountDown is
  generic (
    G_VALUE : positive --! value to count down (clock cycles)
  );
  port (
    Clk_ik   : in  std_logic;
    Reset_ir : in  std_logic;
    Start_i  : in  std_logic;
    Stop_o   : out std_logic
  );
end entity;

architecture RTL of CountDown is

  signal Value_b  : unsigned(clog2(G_VALUE)-1 downto 0) := (others => '0');
  signal Counting : std_logic := '0';
  
begin

  p_Counting: process (Clk_ik) is begin
    if rising_edge(Clk_ik) then
      if Reset_ir then
        Counting <= '0';
      else
        if Start_i then
          Counting <= '1';
        elsif Stop_o then
          Counting <= '0';
        end if;
      end if;
    end if;
  end process;
  
  p_CountDown: process (Clk_ik) is begin
    if rising_edge(Clk_ik) then
      if Reset_ir then
        Value_b <= (others => '0');
      else
        if Start_i then
          Value_b <= to_unsigned(G_VALUE, Value_b'length);
        elsif Counting and not Stop_o then
          Value_b <= Value_b - 1;
        end if;
      end if;
    end if;
  end process;
  
  Stop_o <= not (or Value_b);
   
end architecture;
