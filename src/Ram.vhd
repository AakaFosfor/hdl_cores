-- Random Access Memory, one R/W port
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: draft

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Ram is
  generic (
    G_DATA_WIDTH    : positive;
    G_ADDRESS_WIDTH : positive
  );
  port (
    Clk_ik        : in  std_logic;
    Address_ib    : in  unsigned(G_ADDRESS_WIDTH-1 downto 0);
    DataIn_ib     : in  std_logic_vector(G_DATA_WIDTH-1 downto 0);
    WriteEnable_i : in  std_logic;
    DataOut_ob    : in  std_logic_vector(G_DATA_WIDTH-1 downto 0)
  );
end entity;

architecture behav of Ram is

  type T_RAM is array (0 to (2**Address_ib'length)-1) of std_logic_vector(DataIn_ib'range);

  signal Data_m : T_RAM;

begin

  p_MemoryWrite: process (Clk_ik) is begin
    if rising_edge(Clk_ik) then
      if WriteEnable_i then
        Data_m(to_integer(Address_ib)) <= DataIn_ib;
      end if;
    end if;
  end process;

  DataOut_ob <= Data_m(to_integer(Address_ib));

end architecture;
