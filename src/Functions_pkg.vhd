-- Function package
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

package Functions_pkg is

  function clog2(x : natural) return positive;

end package;

package body Functions_pkg is

  function clog2(x : natural) return positive is begin
    if x = 0 then
      return 0;
    else
      return positive(ceil(log2(real(x))));
    end if;
  end function;

end package body;