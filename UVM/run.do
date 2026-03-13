vlib work

vlog -mfcu -sv full_adder.sv interface.sv transaction.sv my_sequence.sv sequencer.sv driver.sv monitor.sv agent.sv scoreboard.sv environment.sv test.sv tb_top.sv

vsim tb_top

view wave
add wave -r sim:/tb_top/*

run -all
