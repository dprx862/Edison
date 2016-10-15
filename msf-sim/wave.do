onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/dsurst
add wave -noupdate /testbench/time_sig
add wave -noupdate /testbench/msf1/r.rxstate
add wave -noupdate -radix binary /testbench/msf1/r.rsempty
add wave -noupdate -radix hexadecimal /testbench/msf1/r.rhold(0)
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1754930000 ps} 1} {{Cursor 2} {1859669556 ps} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1765009993 ps} {1863576137 ps}
