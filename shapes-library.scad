module _screw_ind(screw_th=4, screw_l=100) {
    translate([-50,0,0]) linear_extrude(height = screw_l) rotate([0,0,0]) polygon(points = [[0,-screw_th/2], [50,-screw_th/2], [100,-screw_th/2-50],[100,+screw_th/2+50], [50,+screw_th/2], [0,+screw_th/2]]);
    rotate([0,90,0]) cylinder(h=50, r2=+screw_th/2+50, r1=+screw_th/2);
    translate([0,0,screw_l]) rotate([0,90,0]) cylinder(h=50, r2=+screw_th/2+50, r1=+screw_th/2);
    translate([-50,0,0]) rotate([0,90,0]) cylinder(h=50, r2=+screw_th/2, r1=+screw_th/2);
    translate([-50,0,screw_l]) rotate([0,90,0]) cylinder(h=50, r2=+screw_th/2, r1=+screw_th/2);
}

module screw_ind(screw_th=5, screw_l=100) {
    translate([screw_l,0,0]) rotate([0,-90,0])_screw_ind(screw_th=screw_th, screw_l=screw_l);
}


