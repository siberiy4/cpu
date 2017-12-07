#! /bin/bash
# run.ps1
file_name = "cpu"
vlog -sv cpu.sv ; vsim -c -keepstdout cpu -do "add wave *;run -all;quit"