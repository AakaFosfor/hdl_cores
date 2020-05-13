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

del %MODULE%_tb.vcd > NUL 2>&1

echo Simulating module %MODULE%

ghdl -a %GHDL_OPT% %SRC_DIR%\Functions_pkg.vhd 
ghdl -a %GHDL_OPT% %SRC_DIR%\%MODULE%.vhd 
ghdl -a %GHDL_OPT% %SRC_DIR%\%MODULE%_tb.vhd 

ghdl -e %GHDL_OPT% %MODULE%_tb

ghdl -r %GHDL_OPT% %MODULE%_tb --vcd=%MODULE%_tb.vcd

if exist %MODULE%_tb.vcd gtkwave --script=sim.tcl %MODULE%_tb.vcd
