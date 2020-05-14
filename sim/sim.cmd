@echo off

if [%1]==[] goto help
if [%1]==[-h] goto help

set MODULE=%1
shift
set GHDL_OPT=--std=08
set SRC_DIR=..\src

if not exist %SRC_DIR%\%MODULE%_tb.vhd (
  echo ERROR: A testbench for the module %MODULE% not found!
  echo.
  goto help
)

del %MODULE%_tb.vcd > NUL 2>&1

echo Compiling module %MODULE% testbench
ghdl -a %GHDL_OPT% %SRC_DIR%\Functions_pkg.vhd
if "%1" neq "" echo Compiling dependency...
:dependencyLoop
if "%1" neq "" (
  ghdl -a %GHDL_OPT% %SRC_DIR%\%1.vhd
  shift
  goto dependencyLoop
)
ghdl -a %GHDL_OPT% %SRC_DIR%\%MODULE%.vhd
ghdl -a %GHDL_OPT% %SRC_DIR%\%MODULE%_tb.vhd

echo Elaborating module %MODULE% testbench
ghdl -e %GHDL_OPT% %MODULE%_tb

echo Simulating module %MODULE% testbench
ghdl -r %GHDL_OPT% %MODULE%_tb --vcd=%MODULE%_tb.vcd

if exist %MODULE%_tb.vcd gtkwave --script=sim.tcl %MODULE%_tb.vcd

goto :eof

:help
  echo usage: %0 ^<module^> [dependency1], [dependency2], ...
