module hollow_cylinder(outer_diameter=100, inner_diameter=90, height=10.0) {
    translate([0,0,height/2]) difference() {
        cylinder(r=outer_diameter,h=height,center=true);
        cylinder(r=inner_diameter,h=height*1.1,center=true);
    }
}

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

module sphere_slice(
smaller_radius=37,
larger_radius=40,
height=3) {
    y = (larger_radius*larger_radius - smaller_radius * smaller_radius - height*height) / (2*height);
    r = sqrt(y*y+larger_radius*larger_radius);
    
    translate([0,0,-y])
    intersection() {
        sphere(r=r);
        translate([-r, -r, y]) cube([2*r, 2*r, height]);
    }
}

module eliptical_hold(r1=40, r2=20, h=8, overlap_h_fraction=0.3) {
    scale([1,r2/r1,1])
    difference() {
        r=r1;
        
        overlap_r=0.85 * r1;
        overlap_h=overlap_h_fraction * h;
        
        sp_r = 3*r;

        cylinder(r=r, h=h);
        union() {
            translate([0,0,-0.05])
            sphere_slice(smaller_radius=0.1, larger_radius=overlap_r, height=overlap_h);
            translate([0,0,h+0.05])
            rotate([0,180,0]) sphere_slice(smaller_radius=0.1, larger_radius=overlap_r, height=overlap_h);
        }
    }
}

module lineup_on_circle(
count=6, 
fractional_offset=0,
translate_x=0,
translate_z=0) {
    for (i = [fractional_offset * 360/count : 360/count : 360-1]) {
        rotate([0, 0, i]) translate([translate_x, 0, translate_z]) children(0);
    }  
}

