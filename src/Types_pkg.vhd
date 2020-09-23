-- Types package
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: draft

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Types_pkg is

  type T_SLV_ARRAY is array (natural range <>) of std_logic_vector;

end package;
