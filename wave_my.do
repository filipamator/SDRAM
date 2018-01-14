onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sdram_tb/sdram_memctrl_i1/clock
add wave -noupdate /sdram_tb/sdram_memctrl_i1/reset
add wave -noupdate /sdram_tb/sdram_memctrl_i1/WE
add wave -noupdate /sdram_tb/sdram_memctrl_i1/RE
add wave -noupdate /sdram_tb/sdram_memctrl_i1/RW_ACK
add wave -noupdate /sdram_tb/sdram_memctrl_i1/R_READY
add wave -noupdate -radix hexadecimal /sdram_tb/sdram_memctrl_i1/ADDR
add wave -noupdate -radix hexadecimal /sdram_tb/sdram_memctrl_i1/DATA_IN
add wave -noupdate -radix hexadecimal /sdram_tb/sdram_memctrl_i1/DATA_OUT
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_CLK
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_CKE
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_CS
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_RAS
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_CAS
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_WE
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_BA
add wave -noupdate -radix hexadecimal /sdram_tb/sdram_memctrl_i1/SDRAM_ADDR
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_DQMU
add wave -noupdate /sdram_tb/sdram_memctrl_i1/SDRAM_DQML
add wave -noupdate -radix decimal /sdram_tb/sdram_memctrl_i1/SDRAM_DATA
add wave -noupdate /sdram_tb/sdram_memctrl_i1/state
add wave -noupdate /sdram_tb/sdram_memctrl_i1/next_state
add wave -noupdate /sdram_tb/sdram_memctrl_i1/sdram_cmd
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_SDRAM_BA
add wave -noupdate -radix hexadecimal /sdram_tb/sdram_memctrl_i1/s_SDRAM_ADDR
add wave -noupdate -radix hexadecimal /sdram_tb/sdram_memctrl_i1/s_SDRAM_DATA
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_SDRAM_OE
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_ARef_En
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_ARef_Counter
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_ARef_Flag
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_ARef_Flag_prev
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_counter
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_wait_counter
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_IsRowAct
add wave -noupdate /sdram_tb/sdram_memctrl_i1/s_ActAddr
add wave -noupdate /sdram_tb/sdram_memctrl_i1/c_ARef_Max
add wave -noupdate /sdram_tb/sdram_memctrl_i1/c_Delay_200us
add wave -noupdate -divider MEMORY
add wave -noupdate -expand /sdram_tb/mt48lc32m16a2_i1/Main/statebank
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {284935870 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 295
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {55325813 ps} {677590133 ps}
