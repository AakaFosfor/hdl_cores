-- Signal Debounce
-- Aaka Fosfor, 2019
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: draft, not tested

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Debounce
  generic (
    G_CLK_FREQUENCY: real; -- in Hz
    G_DEBOUNCE_TIME: time := 20 ms
  );
  port (
    Clk_ik: in std_logic;
    Reset_ir: in std_logic;
    Signal_i: in std_logic;
    Signal_o: in std_logic := '0'
  );
end entity;

architecture rtl of Debounce is

  constant C_COUNTER_MAX: integer := G_CLK_FREQUENCY * G_DEBOUNCE_TIME / 1 s;
  constant C_COUNTER_WIDTH: positive := clog2(C_COUNTER_MAX);

  signal Signal_d: std_logic;
  signal Counter_b: unsigned(C_COUNTER_WIDTH-1 downto 0) := to_unsigned(C_COUNTER_MAX, C_COUNTER_WIDTH);

begin

  p_SignalDelay: process(Clk_ik) is begin
    if rising_edge(Clk_ik) then
      Signal_d <= Signal_i;
    end if;
  end process;

  p_Debounce: process(Clk_ik) is begin
    if rising_edge(Clk_ik) then
      if Reset_ir or (Signal_d /= Signal_i) then
        Counter_b <= to_unsigned(C_COUNTER_MAX, C_COUNTER_WIDTH);
      else
        if or Counter_b = '1' then
          -- still something to count
          Counter_b <= Counter_b - 1;
        else
          -- time interval over and no change on the input
          Signal_o <= Signal_i;
        end if;
      end if;
    end if;
  end process;

end architecture;