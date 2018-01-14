onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider MEMORY
add wave -noupdate -expand /sdram_tb/mt48lc32m16a2_i1/Main/statebank
add wave -noupdate /sdram_tb/memctrl_i1/clk
add wave -noupdate /sdram_tb/memctrl_i1/rst
add wave -noupdate /sdram_tb/memctrl_i1/W_REQ
add wave -noupdate /sdram_tb/memctrl_i1/R_REQ
add wave -noupdate /sdram_tb/memctrl_i1/RW_ACK
add wave -noupdate /sdram_tb/memctrl_i1/R_VALID
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/RADDR
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/CacheDout
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/SdramDout
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemClk
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemCKE
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemCS
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemRAS
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemCAS
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemWE
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemBA
add wave -noupdate -color Gold -itemcolor Gold -radix hexadecimal /sdram_tb/memctrl_i1/MemAddr
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemUDQM
add wave -noupdate -color Gold -itemcolor Gold /sdram_tb/memctrl_i1/MemLDQM
add wave -noupdate -color Gold -itemcolor Gold -radix hexadecimal /sdram_tb/memctrl_i1/MemData
add wave -noupdate /sdram_tb/memctrl_i1/mcState
add wave -noupdate /sdram_tb/memctrl_i1/MemCMD
add wave -noupdate /sdram_tb/memctrl_i1/initTimer
add wave -noupdate /sdram_tb/memctrl_i1/initArCount
add wave -noupdate /sdram_tb/memctrl_i1/arTimer
add wave -noupdate /sdram_tb/memctrl_i1/arEnabled
add wave -noupdate /sdram_tb/memctrl_i1/arToggle
add wave -noupdate /sdram_tb/memctrl_i1/arShadow
add wave -noupdate /sdram_tb/memctrl_i1/activated
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/actRowBank
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/to_MemBA
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/to_MemAddr
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/MemData_OE
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/to_MemData
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/from_MemData
add wave -noupdate -radix hexadecimal /sdram_tb/memctrl_i1/dqmShifter
add wave -noupdate /sdram_tb/memctrl_i1/to_MemUDQM
add wave -noupdate /sdram_tb/memctrl_i1/count
add wave -noupdate /sdram_tb/memctrl_i1/initTimer_max
add wave -noupdate /sdram_tb/memctrl_i1/ModeSetting
add wave -noupdate /sdram_tb/memctrl_i1/arTimer_max
add wave -noupdate /sdram_tb/memctrl_i1/dqmShifter_R8
add wave -noupdate /sdram_tb/memctrl_i1/dqmShifter_W1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {273304820 ps} 0}
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
WaveRestoreZoom {273128809 ps} {273497036 ps}
