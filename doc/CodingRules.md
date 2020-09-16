# Coding Rules

## Basic Text Rules

1. Spaces, no TABs
1. Two spaces

## HDL

* synchronous reset
* default values for control signals and out ports driven in the entity
* VHDL keywords lowecase

### Signal and Port Naming

In general: CamelCase, even abbreviations (UartFifoModule).
All uppercase with underscores only for: constants, generics, types (C_DATA_WIDTH).

| Prefix | Rule | Suffix | Example |
|--:|:--|:--:|:--|
| | Input port | \_i | SerialData_i |
| | Output port | \_o | Overflow_o |
| | Clock | \_k | Clk_c |
| | Reset | \_r | Reset_r |
| | Generic bus | \_b | Data_b |
| | Bus with actual size | \_b\[0-9\]+ | Data_b8 |
| | Generic memory (2D array) | \_m | Memory_bm |
| | Memory with actual size | \_b\[0-9\]+m\[0-9\]+ | Memory_b8m512 |
| f\_ | Function | | f_CheckData() |
| i\_ | Instantiation | | i_Dut |
| C\_ | Constant | | C_DATA_WIDTH |
| G\_ | Generic | | G_CLOCK_FREQUENCY |
| T\_ | Types | | T_MEMORY |

Prefixes/suffixes can be (reasonably) combined:
* Clk_ik
* Data_ob8
