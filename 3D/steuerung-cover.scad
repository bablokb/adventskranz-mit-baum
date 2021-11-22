// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD) Abdeckung Steuermodul.
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
$fn = 64;
//$fn = 24;

fuzz = 0.001;

// dimensions
w4 = 1.67;           // wall 4 layers
w2 = 0.86;           // wall 2 layers
d  = 0.2;            // delta

x_pcb = 100;         // pcb dimensions
y_pcb = 35;
//h_pcb = 10;
h_pcb = 2;

x_85     = 18.3;     // attiny85 dimensions
y_85     = 24.1;
x_off_85 = 62.8;     // offset of attiny85
y_off_85 = 10.3;

x_off_pins = 73.5;

r = 3;               // edges 3mm rounding
//b = 1.2;             // bottom-plate
b = 0.8;             // bottom-plate

r_sen = 6;           // sensor radius
x_off_sen_1 = 1.9;   // x-offset from wall
x_off_sen_2 = 27.6;  // x-offset from wall
y_off_sen   = 7.5;   // y-offset from wall

r_but     = 2;       // button radius
x_off_but = 57.2;    // x-offset from wall
y_off_but = 23.1;    // y-offset from wall


// --- inner void   --------------------------------------------------------------

module inner() {
  difference() {
    // walls
    union() {
      cuboid([x_pcb+2*d,y_pcb+2*d,h_pcb], p1=[-d,-d,-h_pcb+fuzz]);                      // pcb
      cuboid([x_85+2*d,y_85+2*d,h_pcb], p1=[-d+x_off_85-d,-d-y_off_85-d,-h_pcb+fuzz]);  // attiny85
    }
    // inner void
    union() {
      cuboid([x_pcb+2*d-2*w2,y_pcb+2*d-2*w2,h_pcb], p1=[-d+w2,-d+w2,-h_pcb+fuzz]);      // pcb
      cuboid([x_85+2*d-2*w2,y_85+2*d+w2,h_pcb], 
              p1=[-d+x_off_85-d+w2,-d-y_off_85-d+w2,-h_pcb+fuzz]);                     // attiny85
    }
    // remove additional walls
    cuboid([20,y_pcb+2*d-2*w2,h_pcb], p1=[-5,-d+w2,-h_pcb+fuzz]);         // left
    cuboid([x_pcb-w2-w4-x_off_85,y_85+2*d,h_pcb],
            p1=[x_off_85-5,-d-y_off_85-d,-h_pcb+fuzz]);                   // front attiny85
    cuboid([x_pcb-w2-w4-x_off_pins,20,h_pcb],
            p1=[x_off_pins-5,y_pcb-5,-h_pcb+fuzz]);                   // front attiny85
    
  } 
}

// --- outer shell   ------------------------------------------------------------

module outer() {
  cuboid(
      [x_pcb+2*d+2*w4,y_pcb+2*d+2*w4,b], p1=[-d-w4,-d-w4,0],
      rounding=r,
      edges=[LEFT+FRONT,RIGHT+FRONT,LEFT+BACK,RIGHT+BACK]
  );
  cuboid(
      [x_85+2*d+2*w4,y_85+2*d+2*w4,b], p1=[-d+x_off_85-d-w4,-d-y_off_85-d-w4,0],
      rounding=r,
      edges=[LEFT+FRONT,RIGHT+FRONT,LEFT+BACK,RIGHT+BACK]
  );
}

difference() {
  outer();
  translate([-d+w4+x_off_sen_1+r_sen,-d+r_sen+w4+y_off_sen,-fuzz]) cylinder(b+2*fuzz,r1=r_sen,r2=r_sen);
  translate([-d+w4+x_off_sen_2+r_sen,-d+r_sen+w4+y_off_sen,-fuzz]) cylinder(b+2*fuzz,r1=r_sen,r2=r_sen);
  translate([-d+w4+x_off_but+r_but,-d+r_but+w4+y_off_but,-fuzz]) cylinder(b+2*fuzz,r1=r_but,r2=r_but);
}
inner();
