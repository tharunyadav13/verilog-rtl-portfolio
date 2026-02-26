vlib work
vlog -sv +cover=bcesf tb_top.sv
vsim -coverage -voptargs="+acc" work.tb_top
add wave -r /tb_top/*
run -all
coverage report -details
