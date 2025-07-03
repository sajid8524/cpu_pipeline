@echo off
REM Create required directories if they don't exist
if not exist "waveforms" mkdir waveforms
if not exist "sim" mkdir sim

REM Run CPU testbench
echo Running CPU testbench...
iverilog -o sim\tb_cpu rtl\cpu_top.v rtl\if_stage.v rtl\id_stage.v rtl\ex_stage.v rtl\mem_stage.v rtl\wb_stage.v rtl\hazard_unit.v rtl\forwarding_unit.v rtl\branch_predictor.v rtl\register_file.v rtl\alu.v tb\tb_cpu.v
if errorlevel 1 (
    echo Error compiling CPU testbench
    exit /b 1
)
vvp sim\tb_cpu
if exist tb_cpu.vcd move tb_cpu.vcd waveforms\

REM Run Hazard Unit testbench
echo Running Hazard Unit testbench...
iverilog -o sim\tb_hazard rtl\hazard_unit.v tb\tb_hazard_unit.v
if errorlevel 1 (
    echo Error compiling Hazard Unit testbench
    exit /b 1
)
vvp sim\tb_hazard
if exist tb_hazard_unit.vcd move tb_hazard_unit.vcd waveforms\

REM Run Forwarding Unit testbench
echo Running Forwarding Unit testbench...
iverilog -o sim\tb_forward rtl\forwarding_unit.v tb\tb_forwarding_unit.v
if errorlevel 1 (
    echo Error compiling Forwarding Unit testbench
    exit /b 1
)
vvp sim\tb_forward
if exist tb_forwarding_unit.vcd move tb_forwarding_unit.vcd waveforms\

REM Run Branch Predictor testbench
echo Running Branch Predictor testbench...
iverilog -o sim\tb_branch rtl\branch_predictor.v tb\tb_branch_predictor.v
if errorlevel 1 (
    echo Error compiling Branch Predictor testbench
    exit /b 1
)
vvp sim\tb_branch
if exist tb_branch_predictor.vcd move tb_branch_predictor.vcd waveforms\

REM Run Memory Stage testbench
echo Running Memory Stage testbench...
iverilog -o sim\tb_mem rtl\mem_stage.v tb\tb_mem_stage.v
if errorlevel 1 (
    echo Error compiling Memory Stage testbench
    exit /b 1
)
vvp sim\tb_mem
if exist tb_mem_stage.vcd move tb_mem_stage.vcd waveforms\

echo All simulations completed. VCD files are in waveforms\
pause