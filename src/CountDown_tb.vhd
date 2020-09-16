-- Counter
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

entity CountDown_tb is
end entity;

architecture tb of CountDown_tb is

  constant C_CLK_PERIOD : time     := 10 ns;
  constant C_VALUE      : positive := 12;

  signal Clk_ik   : std_logic := '0';
  signal Reset_ir : std_logic := '1';
  signal Start_i  : std_logic := '0';
  signal Stop_o   : std_logic;

begin

  Clk_ik <= not Clk_ik after C_CLK_PERIOD/2;
  Reset_ir <= '0' after 10*C_CLK_PERIOD;

  i_Dut: entity work.CountDown
    generic map (
      G_VALUE => C_VALUE
    )
    port map (
      Clk_ik   => Clk_ik  ,
      Reset_ir => Reset_ir,
      Start_i  => Start_i ,
      Stop_o   => Stop_o  
    );

  p_Test: process is begin
    wait until Reset_ir = '0';
    
    wait for 40 ns;
    
    -- to test a single countdown
    wait until falling_edge(Clk_ik);
    Start_i <= '1';
    wait until falling_edge(Clk_ik);
    Start_i <= '0';
    
    wait for C_CLK_PERIOD*C_VALUE*2;

    -- to test a prolonged countdown
    for i in 0 to 5 loop
      wait until falling_edge(Clk_ik);
      Start_i <= '1';
      wait until falling_edge(Clk_ik);
      Start_i <= '0';
      
      wait for C_CLK_PERIOD*C_VALUE/2;
    end loop;

    wait for C_CLK_PERIOD*C_VALUE;

    stop(0);
  end process;
  
end architecture;
