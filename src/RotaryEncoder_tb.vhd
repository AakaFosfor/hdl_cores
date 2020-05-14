-- Rotary Encoder (testbench)
-- Aaka Fosfor, 2020
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: final
--
-- Pulse A -> pulse B: increment position
-- Pulse B -> pulse A: decrement position

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library std;
use std.env.all;

use work.Functions_pkg.all;

entity RotaryEncoder_tb is
end entity;

architecture tb of RotaryEncoder_tb is

  constant C_TEST_COUNT    : positive := 100;
  constant C_MAX_STEP      : positive := 20;
  constant C_MIN_DELTA_T   : time := 5 us;
  constant C_MAX_DELTA_T   : time := 20 us;
  constant C_TIMEOUT       : time := 100 ns;

  constant C_CLK_FREQUENCY : real := 10.0e6; -- in Hz
  constant C_DEBOUNCE_TIME : time := 1 us;
  constant C_WIDTH         : positive := 8;
  
  constant C_CLK_PERIOD    : time := (1 sec)/C_CLK_FREQUENCY;

  signal Clk_k       : std_logic := '0';
  signal Reset_r     : std_logic := '1';
  signal EncA_i      : std_logic := '0';
  signal EncB_i      : std_logic := '0';
  signal Position_ob : unsigned(C_WIDTH-1 downto 0);
  
begin

  Clk_k <= not Clk_k after C_CLK_PERIOD/2;
  Reset_r <= '0' after 10*C_CLK_PERIOD;

  i_Dut: entity work.RotaryEncoder
    generic map (
      G_CLK_FREQUENCY => C_CLK_FREQUENCY,
      G_DEBOUNCE_TIME => C_DEBOUNCE_TIME,
      G_WIDTH         => C_WIDTH
    )
    port map (
      Clk_ik      => Clk_k,
      Reset_ir    => Reset_r,
      EncA_i      => EncA_i,
      EncB_i      => EncB_i,
      Position_ob => Position_ob
    );

  p_Test: process is
  
    variable ExpectedPosition_b : unsigned(C_WIDTH-1 downto 0) := to_unsigned(0, C_WIDTH);
    variable Rand               : T_RAND;
    variable DirectionUp        : boolean;
    variable RandTime           : time;

    procedure StepUp(DeltaT : time) is begin
      ExpectedPosition_b := ExpectedPosition_b + 1;
      
      EncA_i<= '1';
      wait for DeltaT;
      EncB_i<= '1';
      wait for DeltaT;
      EncA_i<= '0';
      wait for DeltaT;
      EncB_i<= '0';
      wait for DeltaT;
    end procedure;
  
    procedure StepDown(DeltaT : time) is begin
      ExpectedPosition_b := ExpectedPosition_b - 1;
      
      EncB_i<= '1';
      wait for DeltaT;
      EncA_i<= '1';
      wait for DeltaT;
      EncB_i<= '0';
      wait for DeltaT;
      EncA_i<= '0';
      wait for DeltaT;
    end procedure;
  
  begin
    wait until Reset_r = '0';

    for i in 1 to C_TEST_COUNT loop
      DirectionUp := Rand.getBoolean;
      for j in 1 to Rand.getInteger(C_MAX_STEP) loop
        RandTime := Rand.getTime(C_MAX_DELTA_T, C_MIN_DELTA_T, ns);
        if DirectionUp then
          StepUp(RandTime);
        else
          StepDown(RandTime);
        end if;
        wait for Rand.getTime(C_MAX_DELTA_T, C_MIN_DELTA_T, ns);
      end loop;
      wait on Position_ob for C_TIMEOUT;
      assert (Position_ob = ExpectedPosition_b)
        report "Wrong position value! Read " & integer'image(to_integer(Position_ob)) &
          ", expected " & integer'image(to_integer(ExpectedPosition_b))
        severity failure;
    end loop;

    stop(0);
  end process;
  
end architecture;
