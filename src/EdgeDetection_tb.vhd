-- Edge Detection (testbench)
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

entity EdgeDetection_tb is
end entity;

architecture tb of EdgeDetection_tb is

  signal Clk_k         : std_logic := '0';
  signal Reset_r       : std_logic := '1';
  signal Signal_i      : std_logic := '0';
  signal Edge_o        : std_logic;
  signal RisingEdge_o  : std_logic;
  signal FallingEdge_o : std_logic;
  
  signal Edges         : std_logic_vector(2 downto 0);

begin

  Clk_k <= not Clk_k after 5 ns;
  Reset_r <= '0' after 50 ns;

  i_Dut: entity work.EdgeDetection
    port map (
      Clk_ik        => Clk_k,
      Reset_ir      => Reset_r,
      Signal_i      => Signal_i,
      Edge_o        => Edge_o,
      RisingEdge_o  => RisingEdge_o,
      FallingEdge_o => FallingEdge_o
    );
    
  Edges <= Edge_o & RisingEdge_o & FallingEdge_o;
    
  p_Test: process is begin
    wait until Reset_r = '0';
    
    wait until Clk_k = '1';
    Signal_i <= '1';
    wait until Clk_k = '1';
    assert Edges = "110"
      report "Badly detected rising edge!"
      severity failure;
    
    wait until Clk_k = '1';
    Signal_i <= '0';
    wait until Clk_k = '1';
    assert Edges = "101"
      report "Badly detected rising edge!"
      severity failure;
    
    wait until Clk_k = '1';
    stop(0);
  end process;
   
end architecture;
