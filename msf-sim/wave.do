onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/time_sig
add wave -noupdate /testbench/msf1/r.rxstate
add wave -noupdate -radix binary /testbench/msf1/r.rsempty
add wave -noupdate /testbench/msf1/r.second
add wave -noupdate -radix hexadecimal -childformat {{/testbench/msf1/r.rhold(7) -radix hexadecimal} {/testbench/msf1/r.rhold(6) -radix hexadecimal} {/testbench/msf1/r.rhold(5) -radix hexadecimal} {/testbench/msf1/r.rhold(4) -radix hexadecimal} {/testbench/msf1/r.rhold(3) -radix hexadecimal} {/testbench/msf1/r.rhold(2) -radix hexadecimal} {/testbench/msf1/r.rhold(1) -radix hexadecimal} {/testbench/msf1/r.rhold(0) -radix hexadecimal}} -subitemconfig {/testbench/msf1/r.rhold(7) {-height 13 -radix hexadecimal} /testbench/msf1/r.rhold(6) {-height 13 -radix hexadecimal} /testbench/msf1/r.rhold(5) {-height 13 -radix hexadecimal} /testbench/msf1/r.rhold(4) {-height 13 -radix hexadecimal} /testbench/msf1/r.rhold(3) {-height 13 -radix hexadecimal} /testbench/msf1/r.rhold(2) {-height 13 -radix hexadecimal} /testbench/msf1/r.rhold(1) {-height 13 -radix hexadecimal} /testbench/msf1/r.rhold(0) {-height 13 -radix hexadecimal}} /testbench/msf1/r.rhold
add wave -noupdate /testbench/msf1/r
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {25543056 ps} 0} {{Cursor 2} {1755910000 ps} 0}
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
WaveRestoreZoom {1744064693 ps} {1768706229 ps}
