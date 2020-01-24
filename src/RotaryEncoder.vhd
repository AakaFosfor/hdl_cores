-- Rotary Encoder
-- Aaka Fosfor, 2019
-- https://github.com/AakaFosfor/hdl_cores
--
-- state: draft, not tested

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RotaryEncoder
  generic (
    G_WIDTH         : positive := 8
    G_DEBOUNCE_TIME : time := 50 ms;
  );
  port (
    Clk_ik      : in  std_logic;
    Reset_ir    : in  std_logic;
    EncA_i      : in  std_logic;
    EncB_i      : in  std_logic;
    Position_ob : out unsigned(G_WIDTH-1 downto 0)
  );
end entity;

architecture rtl of RotaryEncoder is

  signal EncADebounced   : std_logic;
  signal EncBDebounced   : std_logic;
  signal EncBDebounced_d : std_logic;
  signal PositionChanged : std_logic;
  signal Position_b      : unsigned(G_WIDTH-1 downto 0) := (others => '0');

begin

  i_DebounceA: entity work.Debounce
    generic map (
      G_DEBOUNCE_TIME => G_DEBOUNCE_TIME
    )
    port map (
      Clk_ik   => Clk_ik,
      Reset_ir => Reset_ir,
      Signal_i => EncA_i,
      Signal_o => EncADebounced
    );

  i_DebounceB: entity work.Debounce
    generic map (
      G_DEBOUNCE_TIME => G_DEBOUNCE_TIME
    )
    port map (
      Clk_ik   => Clk_ik,
      Reset_ir => Reset_ir,
      Signal_i => EncB_i,
      Signal_o => EncBDebounced
    );

  i_EdgeDetection: entity work.EdgeDetection
    port map (
      Clk_ik       => Clk_ik,
      Reset_ir     => Reset_ir,
      Signal_i     => EncADebounced,
      RisingEdge_o => PositionChanged
    );

  -- delay on line B to compensate EdgeDetection latency (1 clock cycle)
  p_EncBDelay: process(Clk_ik) is begin
    if rising_edge(Clk_ik) then
      EncBDebounced_d <= EncBDebounced;
    end if;
  end process;

  p_Position: process(Clk_ik) is begin
    if rising_edge(Clk_ik) then
      if Reset_ir then
        Position_b <= (others => '0');
      elsif PositionChanged then
        if EncBDebounced_d = 1 then
          Position_b <= Position_b + 1;
        else
          Position_b <= Position_b - 1;
        end if;
      end if;
    end if;
  end process;
  
  Position_ob <= Position_b;

end architecture;