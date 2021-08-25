// -----------------------------------------------------------------------------
// 3D-Model (OpenSCAD) Adventskranz.
//
// Author: Bernhard Bablok
// License: GPL3
//
// Website: https://github.com/bablokb/pcb-adventskranz
//
// -----------------------------------------------------------------------------

$fa = 1;
$fs = 0.4;

fuzz = 0.001;

k_b   = 3;             // base
k_h   = 15;            // height
kr_o  = 195/2;         // outer radius
kr_w  = 20;            // width
kr_i  = kr_o - kr_w;   // inner radius
kr_c  = 10;            // cutout-width
k_fac = 0.95;          // slimify-factor
p_h   = 1.6;           // pcb-height

b_h   = 5;             // base height
br_o  = 20;            // base outer radius
br_i  = 10.6;          // base inner radius
b_fac = 0.6;           // slimify-factor (> br_i/br_o)

module ring(o,i,h,fac=1) {
  difference() {
    cylinder(h,o*fac,o);
    translate([0,0,-fuzz]) cylinder(h+2*fuzz,i,i);
  }
}

module kranz() {
  ring(kr_o,kr_i,k_h,fac=k_fac);
  translate([kr_i+kr_w/2,0,0]) ring(br_o,br_i,k_h+b_h,fac=b_fac);
  translate([-kr_i-kr_w/2,0,0]) ring(br_o,br_i,k_h+b_h,fac=b_fac);
  translate([0,kr_i+kr_w/2,0]) ring(br_o,br_i,k_h+b_h,fac=b_fac);
  translate([0,-kr_i-kr_w/2,0]) ring(br_o,br_i,k_h+b_h,fac=b_fac);
}

module all() {
  rotate([0,0,45]) difference() {
    kranz();
    translate([kr_i+kr_w/2,0,k_h-p_h]) cylinder(b_h+p_h+fuzz,br_i,br_i);
    translate([-kr_i-kr_w/2,0,k_h-p_h]) cylinder(b_h+p_h+fuzz,br_i,br_i);
    translate([0,kr_i+kr_w/2,k_h-p_h]) cylinder(b_h+p_h+fuzz,br_i,br_i);
    translate([0,-kr_i-kr_w/2,k_h-p_h]) cylinder(b_h+p_h+fuzz,br_i,br_i);
    translate([0,0,k_b]) ring(kr_o-(kr_w-kr_c)/2,kr_i+(kr_w-kr_c)/2,k_h+b_h+fuzz);
  }
}

//intersection() {
//  all();
//  translate([40,40,0]) cube(50);
//}
all();
