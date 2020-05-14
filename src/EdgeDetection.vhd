-- Edge Detection
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EdgeDetection is
  port (
    Clk_ik        : in  std_logic;
    Reset_ir      : in  std_logic;
    Signal_i      : in  std_logic;
    Edge_o        : out std_logic := '0';
    RisingEdge_o  : out std_logic := '0';
    FallingEdge_o : out std_logic := '0'
  );
end entity;

architecture RTL of EdgeDetection is

  signal Signal_d : std_logic := '0';

begin

  p_Delay: process (Clk_ik) is begin
    if rising_edge(Clk_ik) then
      if Reset_ir then
        Signal_d <= '0';
      else
        Signal_d <= Signal_i;
      end if;
    end if;
  end process;
  
  Edge_o        <=     Signal_i xor     Signal_d;
  RisingEdge_o  <=     Signal_i and not Signal_d;
  FallingEdge_o <= not Signal_i and     Signal_d;

end architecture;
