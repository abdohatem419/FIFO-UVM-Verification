vlib work
vlog -f src_files.list -define SIM +cover -covercells
vsim -voptargs=+acc work.top_module -cover
add wave /top_module/fifo_interface_instance/*
coverage save top_module.ucdb -onexit 
run -all
#quit -sim
#vcover report top_module.ucdb -details -all -annotate -output coverage_report_fifo_uvm.txt

