$fa = 1;
$fs = 0.4;

fuzz = 0.001;

difference() {
  union() {
    translate([-0.225,0.525,5]) import("Ornament.stl");
    cylinder(5+fuzz,10.5,10.5);
  }
  translate([0,0,-1]) cylinder(10,6,6);
}
