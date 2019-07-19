
module box(side=10)  {
  $fn=50;
  radius = side * 1/6;
  translate([radius, radius, radius])
  minkowski()
  {
      cube([side, side, side], 0);
      sphere(radius);
  }
}

// box(10);


module frame(side=10, thickness=1)  {
  $fn=50;
  innerSize = side - thickness * 2;
  difference() {
    // outer cube
    cube([side, side, side]);

    // inner cut
    translate([thickness, thickness, thickness])
    union() {
      for (x = [-2:4:2]) {
        translate([x*thickness, 0, 0])
        cube([innerSize, innerSize, innerSize]);
      }
      for (y = [-2:4:2]) {
        translate([0, y*thickness, 0])
        cube([innerSize, innerSize, innerSize]);
      }
      for (z = [-2:4:2]) {
        translate([ 0, 0, z*thickness])
        cube([innerSize, innerSize, innerSize]);
      }
    };
  }
}

// Pair this with $fn to account for not a perfect radius

side = 10;
delta = side/50;
thickness = side * 1/32;
radius = side * 1/32;
width = radius*2 + thickness - delta;
dark = "#3a3a30";
//light = "#eaeae1";
// dark = "black";
light = "white";

module roundedFrame() {
  $fn=6;
  translate([radius,radius,radius])
  color(dark)
  minkowski()
  {
      frame(side - 2*radius, thickness);
      sphere(radius);
  }
}

module panel() {
  panelSide = side - 2*radius;
  cube([panelSide,panelSide, width]);
}


module notion() {
  roundedFrame();

  // left
  color(dark)
    rotate([90,0,0])
    translate([radius,radius,-width - delta/2])
    panel();

  // back
  color(light)
    rotate([0,-90,0])
    translate([radius,radius,-width - delta/2])
    panel();

  // top
  // color(light)
  //   translate([0,0,side])
  //   translate([radius,radius,-width - delta/2])
  //   panel();

  // top
  color(light)
    translate([0,0,0])
    translate([radius,radius,delta/2])
    panel();

  // right
  color(light)
    translate([0,side - delta/2,0])
    rotate([90,0,0])
    translate([radius,radius,0])
    panel();
}

notion();

color(dark)
translate([side*0.55,side*0.25,width])
scale(0.65)
rotate([90,0,90])
text("N", font="serif");


// Minkowski doesnt work on text!
// minkowski()
// {
//   text("N", font="serif");
//   translate([1,0,0]) sphere(0.5);
// }

// Maybe we can iterate this thing in a circle...
// module Embossed(step = 0.05, height = 1, grad = 0.5) {
//         for (z = [ 0 : step : height ]) {
//                 translate([0, 0, z])
//                 linear_extrude(height = step)
//                 offset(delta = -z * grad, chamfer = true)
//                 children();
//         }
// };
