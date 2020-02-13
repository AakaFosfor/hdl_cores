set nfacs [ gtkwave::getNumFacs ]
set dumpname [ gtkwave::getDumpFileName ]
set dmt [ gtkwave::getDumpType ]

puts "number of signals in dumpfile '$dumpname' of type $dmt: $nfacs"

set signals [list]

for {set i 0} {$i < $nfacs } {incr i} {
  set facname [ gtkwave::getFacName $i ]
  set indx [ string first "\." $facname [expr [ string first "\." $facname  ] + 1 ] ]
  if {$indx != -1} {
    lappend signals "$facname"
  }
}

set ll [ llength $signals ]
puts "number of signals in DUT: $ll"

set num_added [ gtkwave::addSignalsFromList $signals ]
puts "num signals added: $num_added"

gtkwave::/Time/Zoom/Zoom_Full