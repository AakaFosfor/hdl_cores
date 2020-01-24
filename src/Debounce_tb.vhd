-- Debounce (testbench)
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

entity Debounce_tb is
end entity;

architecture tb of Debounce_tb is

  constant C_CLK_FREQUENCY : real := 100.0e6; -- in Hz
  constant C_DEBOUNCE_TIME : time := 1 us;
  
  constant C_CLK_PERIOD    : time := (1 sec)/C_CLK_FREQUENCY;

  signal Clk_k    : std_logic := '0';
  signal Reset_r  : std_logic := '1';
  signal Signal_i : std_logic := '0';
  signal Signal_o : std_logic;

begin

  Clk_k <= not Clk_k after C_CLK_PERIOD/2;
  Reset_r <= '0' after 10*C_CLK_PERIOD;

  i_Dut: entity work.Debounce
    generic map (
      G_CLK_FREQUENCY => C_CLK_FREQUENCY,
      G_DEBOUNCE_TIME => C_DEBOUNCE_TIME
    )
    port map (
      Clk_ik   => Clk_k,
      Reset_ir => Reset_r,
      Signal_i => Signal_i,
      Signal_o => Signal_o
    );

  p_Test: process is begin
    wait until Reset_r = '0';

    wait for 2*C_DEBOUNCE_TIME;
    Signal_i <= '1';
    wait for C_DEBOUNCE_TIME/2;
    Signal_i <= '0';
    
    wait for 2*C_DEBOUNCE_TIME;
    Signal_i <= '1';
    wait for 2*C_DEBOUNCE_TIME;
    Signal_i <= '0';
    
    wait for 2*C_DEBOUNCE_TIME;
    stop(0);
  end process;
  
  p_Checker: process(Signal_o) is begin
    assert (Signal_o'last_event < C_DEBOUNCE_TIME) or (now = 0 sec)
      report "A shorter pulse than C_DEBOUNCE_TIME passed!"
      severity failure;
  end process;
   
end architecture;
