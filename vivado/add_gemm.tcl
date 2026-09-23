# Add the 4x4 GEMM RTL and testbench to an existing Vivado project.
set root [file normalize [file join [pwd] ..]]
add_files [file join $root gemm gemm_4x4.v]
add_files -fileset sim_1 [file join $root gemm gemm_4x4_tb.v]
set_property top gemm_4x4_tb [get_filesets sim_1]
puts "Added 4x4 INT8 GEMM RTL and testbench."
