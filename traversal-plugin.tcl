# store an index to select when you get a list of all the atoms; number and symbol boxes, that is.
set ::pdtk_canvas::atom_index "0"

proc ::pdtk_canvas::next_atom {tkcanvas x y} {
      # make sure the mouse isn't held down.
  pdtk_canvas_mouseup $tkcanvas $x $y 1
      # find all the atoms.
  set atom_ids [$tkcanvas find withtag {atom&&text}]
  set size [llength $atom_ids]
  if {$size > 0} {
        # increment upon the last stored index, but keep it within the bounds of the list with a modulo
    set ::pdtk_canvas::atom_index [expr { (1 + $::pdtk_canvas::atom_index) % $size}]
        # get the id number the coords command needs to look for
    set atom [lindex $atom_ids $::pdtk_canvas::atom_index]
        # set the new x and y coordinates to the location of the new atom
    lassign [$tkcanvas coords $atom] x y
        # click on the new atom.  FYI, the 1 is for mousebutton one and the 0 is for not holding shift.
    pdtk_canvas_mouse $tkcanvas $x $y 1 0
    pdtk_canvas_mouseup $tkcanvas $x $y 1
  }
}

    # make this event special so other gui-plugins can bind to it.
event  add <<Traverse>> <Key-Tab>
    # bind to the canvas class and substitute the name of the window along with current mouse coordinates for arguments
bind Canvas <<Traverse>> {::pdtk_canvas::next_atom %W %x %y}
