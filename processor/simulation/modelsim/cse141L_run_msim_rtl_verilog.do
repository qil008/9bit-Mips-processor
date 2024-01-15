transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/reg_file.sv}
vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/PC_LUT.sv}
vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/PC.sv}
vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/dat_mem.sv}
vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/Control.sv}
vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/alu.sv}
vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/instr_ROM.sv}
vlog -sv -work work +incdir+C:/Users/qianq/Desktop/cse141L/class_demo_proc {C:/Users/qianq/Desktop/cse141L/class_demo_proc/top_level.sv}

