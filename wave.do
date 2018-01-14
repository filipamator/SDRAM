onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider memctrl-host
add wave -noupdate /sdram_tb/memctrl_i1/CacheDout
add wave -noupdate /sdram_tb/memctrl_i1/RADDR
add wave -noupdate /sdram_tb/memctrl_i1/R_REQ
add wave -noupdate /sdram_tb/memctrl_i1/W_REQ
add wave -noupdate /sdram_tb/memctrl_i1/clk
add wave -noupdate /sdram_tb/memctrl_i1/rst
add wave -noupdate /sdram_tb/memctrl_i1/RW_ACK
add wave -noupdate /sdram_tb/memctrl_i1/R_VALID
add wave -noupdate /sdram_tb/memctrl_i1/SdramDout
add wave -noupdate -divider memctrl-sdram
add wave -noupdate /sdram_tb/memctrl_i1/MemAddr
add wave -noupdate /sdram_tb/memctrl_i1/MemBA
add wave -noupdate /sdram_tb/memctrl_i1/MemCAS
add wave -noupdate /sdram_tb/memctrl_i1/MemCKE
add wave -noupdate /sdram_tb/memctrl_i1/MemCS
add wave -noupdate /sdram_tb/memctrl_i1/MemClk
add wave -noupdate /sdram_tb/memctrl_i1/MemLDQM
add wave -noupdate /sdram_tb/memctrl_i1/MemRAS
add wave -noupdate /sdram_tb/memctrl_i1/MemUDQM
add wave -noupdate /sdram_tb/memctrl_i1/MemWE
add wave -noupdate -divider memctrl-internal
add wave -noupdate /sdram_tb/memctrl_i1/arTimer
add wave -noupdate /sdram_tb/memctrl_i1/initTimer
add wave -noupdate /sdram_tb/memctrl_i1/mcState
add wave -noupdate -divider sdram-internal
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {1 ns}
