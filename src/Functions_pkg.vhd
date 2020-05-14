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

  type T_RAND is protected
    impure function getReal(maxVal : real := 1.0; minVal : real := 0.0) return real;
    impure function getInteger(maxVal : integer := 1; minVal : integer := 0) return integer;
    impure function getTime(maxVal : time := 1 ns; minVal : time := 0 ns; unit : time := ns) return time;
  end protected;

end package;

package body Functions_pkg is

  function clog2(x : natural) return positive is begin
    if x = 0 then
      return 0;
    else
      return positive(ceil(log2(real(x))));
    end if;
  end function;

  type T_RAND is protected body
    
    variable seed1, seed2 : integer := 1;

    impure function getReal(maxVal : real := 1.0; minVal : real := 0.0) return real is
      variable realValue: real;
    begin
      uniform(seed1, seed2, realValue);
      return realValue * (maxVal - minVal) + minVal;
    end function;
    
    impure function getInteger(maxVal : integer := 1; minVal : integer := 0) return integer is
      variable realValue: real;
    begin
      uniform(seed1, seed2, realValue);
      return integer(floor(realValue * real(maxVal - minVal + 1))) + minVal;
    end function;
    
    impure function getTime(maxVal : time := 1 ns; minVal : time := 0 ns; unit : time := ns) return time is
      variable intValue, maxValInt, minValInt: integer;
    begin
      maxValInt := maxVal / unit;
      minValInt := minVal / unit;
      intValue := getInteger(maxValInt, minValInt);
      return intValue * unit;
    end function;
    
  end protected body;

end package body;