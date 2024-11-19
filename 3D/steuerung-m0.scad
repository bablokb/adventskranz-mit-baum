// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD) Gehäuse Steuermodul für Trinket-M0.
//
// Author: Bernhard Bablok
// License: GPL3
//
// Website: https://github.com/bablokb/pcb-adventskranz
//
// -----------------------------------------------------------------------------

include <BOSL2/std.scad>

$fa = 1;
$fs = 0.4;
$fn= $preview ? 32 : 128;
fuzz = 0.01;

// dimensions
w4 = 1.67;           // wall 4 layers
d  = 0.1;            // delta

x_pcb = 25.0;         // pcb dimensions
y_pcb = 28.3;
z_pcb = 15;

x_usb     = 8;        // cutout for SD-connector
x_off_usb = 0;        // offset relative to PCB
z_off_usb = 11.0;     // offset relative to bottom of pcb

y_pins     = 18.4;    // cutout for pins
y_off_pins = 7.6;     // offset from front edge
z_off_pins = 11;

r = 3;               // edges 3mm rounding
b = 1.2;             // bottom-plate

// --- inner void   --------------------------------------------------------------

module inner() {
  zmove(b) cuboid([x_pcb+2*d,y_pcb+2*d,z_pcb+b], anchor=BOTTOM+CENTER);
}

// --- outer shell   ------------------------------------------------------------

module outer() {
  cuboid([x_pcb+2*d+2*w4,y_pcb+2*d+2*w4,z_pcb+b], anchor=BOTTOM+CENTER,
            rounding=r, edges="Z");
}

difference() {
  outer();
  inner();
  // cutout USB
  move([0,-y_pcb/2-d,z_off_usb]) cuboid([x_usb,3*w4,z_pcb], anchor=BOTTOM+CENTER);
  // cutout pins
  move([-x_pcb/2-d,-y_pcb/2-d+y_pins/2+y_off_pins,z_off_pins])
     cuboid([3*w4,y_pins,z_pcb], anchor=BOTTOM+CENTER);
}
