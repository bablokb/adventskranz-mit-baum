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
br_i  = 10.5;          // base inner radius
b_fac = 0.6;           // slimify-factor (> br_i/br_o)


// --- Generisches Ring Modul   ----------------------------------------------
// Der Faktor gibt an, um wieviel sich die Breite nach unten verjüngt

module ring(o,i,h,fac=1) {
  difference() {
    cylinder(h,o*fac,o);
    translate([0,0,-fuzz]) cylinder(h+2*fuzz,i,i);
  }
}

// --- Basis des Kranz   -----------------------------------------------------
// zusammengesetzt aus einem großen Ring und vier Ringen für die Kerzen

module basis() {
  ring(kr_o,kr_i,k_h,fac=k_fac);
  translate([kr_i+kr_w/2,0,0])  ring(br_o,br_i,k_h+b_h,fac=b_fac);
  translate([-kr_i-kr_w/2,0,0]) ring(br_o,br_i,k_h+b_h,fac=b_fac);
  translate([0,kr_i+kr_w/2,0])  ring(br_o,br_i,k_h+b_h,fac=b_fac);
  translate([0,-kr_i-kr_w/2,0]) ring(br_o,br_i,k_h+b_h,fac=b_fac);
}

// --- Kranz   ---------------------------------------------------------------
// Zusätzliche Ausschnitte für die Platinen je Kerzenhalter sowie
// einem 360°-Kabelkanal

module kranz() {
  difference() {
    basis();
    translate([kr_i+kr_w/2,0,k_h-p_h])  cylinder(b_h+p_h+fuzz,br_i,br_i);
    translate([-kr_i-kr_w/2,0,k_h-p_h]) cylinder(b_h+p_h+fuzz,br_i,br_i);
    translate([0,kr_i+kr_w/2,k_h-p_h])  cylinder(b_h+p_h+fuzz,br_i,br_i);
    translate([0,-kr_i-kr_w/2,k_h-p_h]) cylinder(b_h+p_h+fuzz,br_i,br_i);
    // Kabelkanal
    translate([0,0,k_b]) ring(kr_o-(kr_w-kr_c)/2,kr_i+(kr_w-kr_c)/2,k_h+b_h+fuzz);
    // Ausschnitt für Anschluss
    rotate([0,0,25]) translate([kr_i+6,-10,k_b]) cube([30,20,30]);
  }
}

// --- Abdeckung Kabelkanal   ------------------------------------------------

module cover(anschluss=false) {
  delta  = 0.1;                     // Verkleinerung für Passgenauigkeit
  k      = (kr_w-kr_c)/2 - 2*delta; // (Breite Ring - Breite Cutout)/2
  d = k_h - k_b - delta;            // Cutout-Depth (Höhe - Basis)
  w2 = 0.86;                        // Wanddicke, 2 Schichten
  c_b = 1;                          // Basis Cover
  winkel = 8;                       // Abstand in Grad zur Achse

  points = [
    [delta + kr_i+k,     0],
    [delta + kr_i+k+kr_c,0],
    [delta + kr_i+k+kr_c,d],
    [delta + kr_i+k+kr_c-w2,d],
    [delta + kr_i+k+kr_c-w2,c_b],
    [delta + kr_i+k+w2,c_b],
    [delta + kr_i+k+w2,d],
    [delta + kr_i+k,d]
    ];
  difference() {
    rotate([0,0,winkel]) rotate_extrude(angle=90-2*winkel) polygon(points);
    rotate([0,0,winkel]) translate([kr_i,-10,k_b]) cube([30,30,30]);
    rotate([0,0,90-winkel]) translate([kr_i,-20,k_b]) cube([30,30,30]);
    if (anschluss) {
      rotate([0,0,90-25]) translate([kr_i+6,-10,k_b]) cube([30,20,30]);
    }
  }
}

// --- Ausschnitte für Testdruck   -------------------------------------------

//intersection() {
//  rotate([0,0,45]) kranz();
//  translate([10,40,0]) cube(90);
//}

//intersection() {
//  cover(true);
//  translate([70,0,0]) cube(90);
//}

// --- Test für Kabelkanalabdeckung   ----------------------------------------

//rotate([0,0,45]) color("blue") translate([0,0,k_h]) mirror([0,0,90]) cover(true);

// --- Finale Objekte   ------------------------------------------------------

// rotate([0,0,45]) kranz();       // kompletter Kranz, gedreht wg. Druckbett
// cover();                        // Abdeckung Kabelkanal ohne Ausschnitt
   cover(true);                    // Abdeckung Kabelkanal mit  Ausschnitt
