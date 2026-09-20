# Vivado starter script. Change PART for your FPGA.
set PART "xc7vx485tffg1157-1"
set PROJECT_NAME "advanced-mnist-npu"
set PROJECT_DIR "./vivado_project"
create_project $PROJECT_NAME $PROJECT_DIR -part $PART -force
add_files [list ../rtl/systolic_pe.v ../rtl/systolic_array_4x4.v ../rtl/input_buffer.v ../rtl/weight_buffer.v ../rtl/bias_add.v ../rtl/argmax.v ../rtl/npu_controller.v ../rtl/mnist_npu_top.v]
add_files -fileset sim_1 ../sim/mnist_npu_tb.v
set_property top mnist_npu_top [get_filesets sources_1]
set_property top mnist_npu_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
puts "Created advanced-mnist-npu as a Verilog starter project."
