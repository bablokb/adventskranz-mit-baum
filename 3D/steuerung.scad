// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD) Gehäuse Steuermodul.
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
//$fn = 64;
$fn = 24;

fuzz = 0.001;

// dimensions
w4 = 1.67;           // wall 4 layers
d  = 0.2;            // delta

x_pcb = 100;         // pcb dimensions
y_pcb = 35;
z_pcb = 15;

x_85     = 18;       // attiny85 dimensions
y_85     = 24.1;
x_off_85 = 62.8;     // offset of attiny85
y_off_85 = 10.3;

x_sd     = 8;        // cutout for SD-connector
x_off_sd = 5.3;      // offset relative to x_85
z_off_sd = 4.0;      // offset relative to bottom of pcb

x_pins     = 8.2;    // cutout for pins
x_off_pins = 73.5;
z_off_pins = 3.5;

r = 3;               // edges 3mm rounding
b = 1.2;             // bottom-plate
s_x = 5;             // support in the corners
s_y = s_x;
s_z = 2;

// --- inner void   --------------------------------------------------------------

module inner() {
  cuboid([x_pcb+2*d,y_pcb+2*d,z_pcb+b], p1=[-d,-d,b]);                      // pcb
  cuboid([x_85+2*d,y_85+2*d,z_pcb+b], p1=[-d+x_off_85-d,-d-y_off_85-d,b]);  // attiny85
}

// --- outer shell   ------------------------------------------------------------

module outer() {
  cuboid(
      [x_pcb+2*d+2*w4,y_pcb+2*d+2*w4,z_pcb], p1=[-d-w4,-d-w4,0],
      rounding=r,
      edges=[LEFT+FRONT,RIGHT+FRONT,LEFT+BACK,RIGHT+BACK]
  );
  cuboid(
      [x_85+2*d+2*w4,y_85+2*d+2*w4,z_pcb], p1=[-d+x_off_85-d-w4,-d-y_off_85-d-w4,0],
      rounding=r,
      edges=[LEFT+FRONT,RIGHT+FRONT,LEFT+BACK,RIGHT+BACK]
  );
}

difference() {
  outer();
  inner();
  cuboid([x_sd+2*d,10,z_pcb+b], p1=[-d+x_off_85+x_off_sd-d,-d-y_off_85-5,b+s_z+z_off_sd]);
  cuboid([x_pins+2*d,10,z_pcb+b], p1=[-d+x_off_pins-d,y_pcb-5,b+s_z+z_off_pins]);
}
cuboid([s_x,s_y,s_z], p1=[-d,-d,b]);
cuboid([s_x,s_y,s_z], p1=[-d,y_pcb+d-s_y,b]);
cuboid([s_x,s_y,s_z], p1=[x_pcb-s_x+d,-d,b]);
cuboid([s_x,s_y,s_z], p1=[x_pcb-s_x+d,y_pcb+d-s_y,b]);
