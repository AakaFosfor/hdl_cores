-- Counter
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: draft

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! @brief Synchronize the asynchronous reset to the provided clock - asynchronous assert, synchronous de-assert.
entity ResetSyncer is
  generic (
    G_LENGTH : positive := 3 --! delay in clock cycles between async. and sync. de-assertion
  );
  port (
    Clk_ik    : in  std_logic;
    Reset_iar : in  std_logic;
    Reset_or  : out std_logic
  );
end entity;

architecture RTL of ResetSyncer is

  signal ResetSync_b : std_logic_vector(G_LENGTH-1 downto 0) := (others => '0');

begin

  p_ReseSync: process (Clk_ik, Reset_iar) is begin
    if Reset_iar then
      ResetSync_b <= (others => '1');
    elsif rising_edge(Clk_ik) then
      ResetSync_b <= '0' & ResetSync_b(ResetSync_b'left downto 1);
    end if;
  end process;
  
  Reset_or <= ResetSync_b(0);
  
end architecture;
