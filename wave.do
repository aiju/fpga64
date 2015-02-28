onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /pipetest/pipe0/phi2
add wave -noupdate -radix hexadecimal /pipetest/pipe0/stall
add wave -noupdate -divider IC
add wave -noupdate -radix hexadecimal /pipetest/pipe0/icade
add wave -noupdate -radix hexadecimal /pipetest/pipe0/icbusy
add wave -noupdate -radix hexadecimal /pipetest/pipe0/icerror
add wave -noupdate -radix hexadecimal /pipetest/pipe0/icfill
add wave -noupdate -radix hexadecimal /pipetest/pipe0/icinstr
add wave -noupdate -radix hexadecimal /pipetest/pipe0/icmiss
add wave -noupdate -radix hexadecimal /pipetest/pipe0/ictag
add wave -noupdate /pipetest/itlbbusy
add wave -noupdate /pipetest/itlbfill
add wave -noupdate /pipetest/itlbmiss
add wave -noupdate /pipetest/itlbpa
add wave -noupdate -divider RF
add wave -noupdate -radix hexadecimal /pipetest/pipe0/rfade
add wave -noupdate -radix hexadecimal -childformat {{{/pipetest/pipe0/rfdec[50]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[49]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[48]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[47]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[46]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[45]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[44]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[43]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[42]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[41]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[40]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[39]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[38]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[37]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[36]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[35]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[34]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[33]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[32]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[31]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[30]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[29]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[28]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[27]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[26]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[25]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[24]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[23]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[22]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[21]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[20]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[19]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[18]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[17]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[16]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[15]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[14]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[13]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[12]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[11]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[10]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[9]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[8]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[7]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[6]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[5]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[4]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[3]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[2]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[1]} -radix hexadecimal} {{/pipetest/pipe0/rfdec[0]} -radix hexadecimal}} -subitemconfig {{/pipetest/pipe0/rfdec[50]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[49]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[48]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[47]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[46]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[45]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[44]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[43]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[42]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[41]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[40]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[39]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[38]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[37]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[36]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[35]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[34]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[33]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[32]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[31]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[30]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[29]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[28]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[27]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[26]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[25]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[24]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[23]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[22]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[21]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[20]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[19]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[18]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[17]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[16]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[15]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[14]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[13]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[12]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[11]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[10]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[9]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[8]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[7]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[6]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[5]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[4]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[3]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[2]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[1]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/rfdec[0]} {-height 16 -radix hexadecimal}} /pipetest/pipe0/rfdec
add wave -noupdate -radix hexadecimal /pipetest/pipe0/rfinstr
add wave -noupdate -radix hexadecimal /pipetest/pipe0/rfkill
add wave -noupdate -radix hexadecimal /pipetest/pipe0/rfr0
add wave -noupdate -radix hexadecimal /pipetest/pipe0/rfr1
add wave -noupdate -radix hexadecimal /pipetest/pipe0/rfwhy
add wave -noupdate -divider EX
add wave -noupdate -radix hexadecimal -childformat {{{/pipetest/pipe0/exdec[50]} -radix hexadecimal} {{/pipetest/pipe0/exdec[49]} -radix hexadecimal} {{/pipetest/pipe0/exdec[48]} -radix hexadecimal} {{/pipetest/pipe0/exdec[47]} -radix hexadecimal} {{/pipetest/pipe0/exdec[46]} -radix hexadecimal} {{/pipetest/pipe0/exdec[45]} -radix hexadecimal} {{/pipetest/pipe0/exdec[44]} -radix hexadecimal} {{/pipetest/pipe0/exdec[43]} -radix hexadecimal} {{/pipetest/pipe0/exdec[42]} -radix hexadecimal} {{/pipetest/pipe0/exdec[41]} -radix hexadecimal} {{/pipetest/pipe0/exdec[40]} -radix hexadecimal} {{/pipetest/pipe0/exdec[39]} -radix hexadecimal} {{/pipetest/pipe0/exdec[38]} -radix hexadecimal} {{/pipetest/pipe0/exdec[37]} -radix hexadecimal} {{/pipetest/pipe0/exdec[36]} -radix hexadecimal} {{/pipetest/pipe0/exdec[35]} -radix hexadecimal} {{/pipetest/pipe0/exdec[34]} -radix hexadecimal} {{/pipetest/pipe0/exdec[33]} -radix hexadecimal} {{/pipetest/pipe0/exdec[32]} -radix hexadecimal} {{/pipetest/pipe0/exdec[31]} -radix hexadecimal} {{/pipetest/pipe0/exdec[30]} -radix hexadecimal} {{/pipetest/pipe0/exdec[29]} -radix hexadecimal} {{/pipetest/pipe0/exdec[28]} -radix hexadecimal} {{/pipetest/pipe0/exdec[27]} -radix hexadecimal} {{/pipetest/pipe0/exdec[26]} -radix hexadecimal} {{/pipetest/pipe0/exdec[25]} -radix hexadecimal} {{/pipetest/pipe0/exdec[24]} -radix hexadecimal} {{/pipetest/pipe0/exdec[23]} -radix hexadecimal} {{/pipetest/pipe0/exdec[22]} -radix hexadecimal} {{/pipetest/pipe0/exdec[21]} -radix hexadecimal} {{/pipetest/pipe0/exdec[20]} -radix hexadecimal} {{/pipetest/pipe0/exdec[19]} -radix hexadecimal} {{/pipetest/pipe0/exdec[18]} -radix hexadecimal} {{/pipetest/pipe0/exdec[17]} -radix hexadecimal} {{/pipetest/pipe0/exdec[16]} -radix hexadecimal} {{/pipetest/pipe0/exdec[15]} -radix hexadecimal} {{/pipetest/pipe0/exdec[14]} -radix hexadecimal} {{/pipetest/pipe0/exdec[13]} -radix hexadecimal} {{/pipetest/pipe0/exdec[12]} -radix hexadecimal} {{/pipetest/pipe0/exdec[11]} -radix hexadecimal} {{/pipetest/pipe0/exdec[10]} -radix hexadecimal} {{/pipetest/pipe0/exdec[9]} -radix hexadecimal} {{/pipetest/pipe0/exdec[8]} -radix hexadecimal} {{/pipetest/pipe0/exdec[7]} -radix hexadecimal} {{/pipetest/pipe0/exdec[6]} -radix hexadecimal} {{/pipetest/pipe0/exdec[5]} -radix hexadecimal} {{/pipetest/pipe0/exdec[4]} -radix hexadecimal} {{/pipetest/pipe0/exdec[3]} -radix hexadecimal} {{/pipetest/pipe0/exdec[2]} -radix hexadecimal} {{/pipetest/pipe0/exdec[1]} -radix hexadecimal} {{/pipetest/pipe0/exdec[0]} -radix hexadecimal}} -subitemconfig {{/pipetest/pipe0/exdec[50]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[49]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[48]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[47]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[46]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[45]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[44]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[43]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[42]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[41]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[40]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[39]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[38]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[37]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[36]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[35]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[34]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[33]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[32]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[31]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[30]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[29]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[28]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[27]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[26]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[25]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[24]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[23]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[22]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[21]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[20]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[19]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[18]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[17]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[16]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[15]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[14]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[13]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[12]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[11]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[10]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[9]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[8]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[7]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[6]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[5]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[4]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[3]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[2]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[1]} {-height 16 -radix hexadecimal} {/pipetest/pipe0/exdec[0]} {-height 16 -radix hexadecimal}} /pipetest/pipe0/exdec
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exinstr
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exr1
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exr0
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exalur
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exfpe
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exovfl
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exbcmp
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exbtarg
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exdade
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exlink
add wave -noupdate -radix hexadecimal /pipetest/pipe0/extargr
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exkill
add wave -noupdate -radix hexadecimal /pipetest/pipe0/exwhy
add wave -noupdate /pipetest/pipe0/exloadr0
add wave -noupdate /pipetest/pipe0/exloadr1
add wave -noupdate -divider DC
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcdec
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcalur
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcbusy
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcdade
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcdata
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcerror
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcfill
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcfpe
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dckill
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcmiss
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcovfl
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcpa
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcread
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcsz
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dctag
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dctargr
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcva
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcval
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcwdata
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcwhy
add wave -noupdate -radix hexadecimal /pipetest/pipe0/dcwrite
add wave -noupdate /pipetest/pipe0/dcissued
add wave -noupdate /pipetest/pipe0/jtlbcache
add wave -noupdate /pipetest/pipe0/jtlbdirty
add wave -noupdate /pipetest/pipe0/jtlberror
add wave -noupdate /pipetest/pipe0/jtlbmiss
add wave -noupdate -radix hexadecimal /pipetest/pipe0/jtlbpa
add wave -noupdate -radix hexadecimal /pipetest/pipe0/jtlbreq
add wave -noupdate -radix hexadecimal /pipetest/pipe0/jtlbva
add wave -noupdate -divider WB
add wave -noupdate -radix hexadecimal /pipetest/pipe0/wbdec
add wave -noupdate -radix hexadecimal /pipetest/pipe0/wbtargr
add wave -noupdate -radix hexadecimal /pipetest/pipe0/wbval
add wave -noupdate -divider EXT
add wave -noupdate /pipetest/cache0/extaddr
add wave -noupdate /pipetest/cache0/extrdata
add wave -noupdate /pipetest/cache0/extrdy
add wave -noupdate /pipetest/cache0/extreply
add wave -noupdate /pipetest/cache0/extreplyto
add wave -noupdate /pipetest/cache0/extreq
add wave -noupdate /pipetest/cache0/extsrc
add wave -noupdate /pipetest/cache0/extsz
add wave -noupdate /pipetest/cache0/extwdata
add wave -noupdate /pipetest/cache0/extwr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19095 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 205
configure wave -valuecolwidth 137
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
configure wave -timelineunits ps
update
WaveRestoreZoom {14444 ps} {50556 ps}
