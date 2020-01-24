@echo off

if [%1]==[] (
  echo usage: %0 ^<module^>
  echo.
  echo Module missing!
  goto :eof
)

set MODULE=%1
set GHDL_OPT=--std=08
set SRC_DIR=..\src

echo Simulating module %MODULE%

ghdl -a %GHDL_OPT% %SRC_DIR%\%MODULE%.vhd 
ghdl -a %GHDL_OPT% %SRC_DIR%\%MODULE%_tb.vhd 

ghdl -e %GHDL_OPT% %MODULE%_tb

ghdl -r %GHDL_OPT% %MODULE%_tb --vcd=%MODULE%_tb.vcd

gtkwave %MODULE%_tb.vcd
