transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Aca - Fakultet/IR4/IR4VLSI/Projekat/WIP/Pipeline/PCreg.vhd}

