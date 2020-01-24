-- Counter (testbench)
-- Aaka Fosfor, 2019
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

entity Counter_tb is
end entity;

architecture tb of Counter_tb is

  constant C_WIDTH : integer := 3;

  signal Clk_k    : std_logic := '0';
  signal Reset_r  : std_logic := '1';
  signal Value_b  : unsigned(C_WIDTH-1 downto 0);
  signal Overflow : std_logic;

begin

  Clk_k <= not Clk_k after 5 ns;
  Reset_r <= '0' after 50 ns;

  i_Dut: entity work.Counter
    generic map (
      G_WIDTH => C_WIDTH
    )
    port map (
      Clk_ik     => Clk_k,
      Reset_ir   => Reset_r,
      Value_ob   => Value_b,
      Overflow_o => Overflow
    );
    
  p_Test: process is begin
    wait until Reset_r = '0';
    for i in 0 to 2**C_WIDTH-1 loop
      assert to_integer(Value_b) = i
        report "Value doesn't match!"
        severity failure;
      assert Overflow = '0'
        report "Overflow set!"
        severity failure;
      wait until falling_edge(Clk_k);
    end loop;
    assert Overflow = '1'
      report "Overflow not set!"
      severity failure;
    wait for 100 ns;
    stop(0);
  end process;
   
end architecture;
