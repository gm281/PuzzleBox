include </Users/gmilos/Library/CloudStorage/iCloudDrive/Jasiu/bolts_nuts_threaded_rods_-_OpenSCAD_library_Threading/files/Threading.scad>
include </Users/gmilos/Library/CloudStorage/iCloudDrive/Jasiu/Gear_Bearing/bearing.scad>
include <shapes-library.scad>

showexample = 0;

$fn=120;

module thread(pitch=3.0, radius=40.0, height=10.0, male=true) {
        intersection() {
            translate([0,0,-pitch]) {
                if (male) {
                    translate([0,0,-pitch]) threading(pitch=pitch, d=2*radius, windings = height/pitch + 2, angle = 45);
                    hollow_cylinder(outer_diameter=radius-pitch/2, inner_diameter=radius-pitch, height=height+pitch);
                } else {
                    spacing=pitch/2;
                    Threading(pitch = pitch, d=2*radius+spacing, windings = height/pitch+2, angle = 45);
                }
            }
            translate([-2*radius, -2*radius, 0]) {
                cube(size = [4*radius, 4*radius, height]);
            }
        }
}


module outer_ring(inner_diameter=100, outer_diameter=110, height=15, incision_count=6, incision_depth=6, incision_diameter=6) {
    difference() {
        hollow_cylinder(outer_diameter=outer_diameter, inner_diameter=inner_diameter, height=height);
        for (i = [0 : 360/incision_count : 360-1]) {
            rotate([0,0,i]) translate([inner_diameter + incision_depth/2-1, 0, height/2]) rotate([0,90,0]) 
                cylinder(r=incision_diameter/2,h=incision_depth+2,center=true);
        }
    }
}

module inner_ring(inner_diameter=80, outer_diameter=90, height=15, incision_count=6, incision_diameter=6) {
    outer_ring(inner_diameter=inner_diameter, outer_diameter=outer_diameter, height=height, incision_count=incision_count, incision_depth=outer_diameter-inner_diameter+1, incision_diameter=
    incision_diameter);

}

module threaded_nut(pitch=3.0, inner_diameter=100, outer_diameter=110, height=10.0) {
        union() {
            thread(pitch=pitch, radius=inner_diameter, height=height, male=false);
            hollow_cylinder(outer_diameter=outer_diameter, inner_diameter=inner_diameter+pitch/2-0.1, height=height);
        }
}

module threaded_nut_with_holds(pitch=3.0, inner_diameter=100, outer_diameter=110, height=10.0) {
    difference() {
        threaded_nut(pitch=pitch, inner_diameter=inner_diameter, outer_diameter=outer_diameter, height=height);
                
        indentation_d=30;
        indentation_de=2;
        translate([-outer_diameter,0,indentation_d+height-indentation_de])rotate([0,90,0])cylinder(r=indentation_d,h=2*outer_diameter);  
    }
}

module lock_base(
pitch=3.0,
inner_radius=20.0,
inner_wall_radius=35.0,
outer_radius=40.0,
thread_height=12,
wall_height=14,
disc_height=3,
incision_depth=8,
incision_diameter=6) {
    translate([0,0,disc_height]) thread(pitch=pitch, radius=inner_radius+pitch, height=thread_height, male=true);
    translate([0,0,disc_height]) outer_ring(inner_diameter=inner_wall_radius, outer_diameter=outer_radius, height=wall_height, incision_count=6, incision_depth=incision_depth, incision_diameter=incision_diameter);
    hollow_cylinder(outer_diameter=outer_radius, inner_diameter=inner_radius, height=disc_height);
}

module rotating_lock_base(
pitch=3.0,
inner_radius=20.0,
inner_wall_radius=35.0,
outer_radius=40.0,
thread_height=12,
wall_height=14,
disc_height=3,
incision_depth=8,
incision_diameter=6,
stem_height=40,
above_bearing_clearence=6,
bearing_thickness=15,
screw_r=40)
{
    translate([0,0,stem_height])
    lock_base(
pitch=pitch,
inner_radius=inner_radius,
inner_wall_radius=inner_wall_radius,
outer_radius=outer_radius,
thread_height=thread_height,
wall_height=wall_height,
disc_height=disc_height,
incision_depth=incision_depth,
incision_diameter=incision_diameter);
    
    inner_cylinder_thickness = 3;
    hollow_cylinder(outer_diameter=outer_radius, inner_diameter=inner_wall_radius, height=stem_height);

    translate([0,0,bearing_thickness+above_bearing_clearence+disc_height])
    hollow_cylinder(outer_diameter=inner_radius + inner_cylinder_thickness, inner_diameter=inner_radius, height=stem_height-bearing_thickness-above_bearing_clearence-disc_height);

    translate([0,0,bearing_thickness+above_bearing_clearence])
    cylinder(r=outer_radius, h=disc_height);
    
    difference() {
        bearing(diameter=2*inner_wall_radius, thickness=bearing_thickness);
        bearing_base_screws(r=screw_r, screw_d=5, z_incision=0);
    }
}

module bearing_base_screws(r=30, screw_d=6, z_incision=2.4) {
    screw_count=6;
    for (i = [0 : 360/screw_count : 360-1]) {
        translate([0,0, z_incision]) rotate([0,0,i]) rotate([0, 180, 0]) translate([r,0,0]) screw_ind(screw_th=screw_d, screw_l=0);
    }
}

module under_bearing_base(
smaller_radius=37,
larger_radius=40,
height=3,
bearing_base_height=3,
hex_access_radius=8,
screw_r=40) {
    bearing_base_r = smaller_radius*0.35;
    difference() {
        union() {
            sphere_slice(smaller_radius=smaller_radius, larger_radius=larger_radius, height=height);
            translate([0,0,height]) cylinder(r=bearing_base_r, h=bearing_base_height);
        }
        union() {
            translate([0,0,-0.05]) cylinder(r=hex_access_radius, h=bearing_base_height+height+0.1);
            bearing_base_screws(r=screw_r, screw_d=6, z_incision=2.4);
            
            rubber_pad_distance=larger_radius * 0.80;
            rubber_pad_r=5;
            rubber_pad_indent=1.5;
            rubber_pad_count=6;
            for (i = [0 : 360/rubber_pad_count : 360-1]) {
                rotate([0,0,i]) translate([rubber_pad_distance,0,-0.05]) cylinder(r=rubber_pad_r, h=rubber_pad_indent);
            }   
        }
    }
}

module cup_thread(pitch=3, radius=20, height=15, screw_count=3, screw_r=10) {
    disc_height=3;
    mirror([1,0,0])
    thread(pitch=pitch, radius=radius, height=height, male=true);
    translate([0,0,height-disc_height]) {
        difference() {
            cylinder(r=radius-pitch/2, h=disc_height);
            z_incision=1;
            for (i = [0 : 360/screw_count : 360-1]) {
                translate([0,0, z_incision]) rotate([0,0,i]) rotate([0, 180, 0]) translate([screw_r,0,0]) screw_ind(screw_th=2, screw_l=0);
            }
        }
    }
}
module cup(disc_height=4, screw_r=20) {
    sc=6;
    th_h=10;
    thread_d=30;
    pitch=3;
    hold_cnt=3;
    cup_thread_screw_r=15;
    
    scale([sc,sc,sc]) rotate([90,0,0]) import("cup.stl");
    difference() {
        cylinder(d=73, h=disc_height);
        bearing_base_screws(r=screw_r, screw_d=3, z_incision=0);
    }
    
    translate([0,0,165 - th_h])
    mirror([1,0,0])
    threaded_nut(pitch=pitch, inner_diameter=thread_d, outer_diameter=33, height=th_h);

    translate([50,80,th_h])
    rotate([0,180,0])
    cup_thread(pitch=pitch, radius=thread_d, height=th_h, screw_count=hold_cnt, screw_r=cup_thread_screw_r);
    
    translate([100,0,0]) {
        difference() {
            union() {
                sphere_slice(smaller_radius=10, larger_radius=38.5, height=6);

                difference() {
                    hold_h=4;
                    union() {
                        for (i = [0 : 360/hold_cnt : 360-1]) {
                            rotate([0,0,i])
                            translate([-20,hold_h/2,3])
                            rotate([0,-6,0])
                            rotate([90,0,0])
                            eliptical_hold(r1=16, r2=10, h=hold_h);
                        }
                    }
                    translate([-50,-50,-100+0.05]) cube([100,100,100]);
                }
            }
        
            union() {
                screw_hole_indent=10;
                for (i = [0 : 360/hold_cnt : 360-1]) {
                    rotate([0,0,180+i]) translate([cup_thread_screw_r,0,-0.05]) cylinder(r=0.75,h=screw_hole_indent);
                }
            }
        }
    }
}

module rotating_lock_top(outer_r=40, lock_inner_r=30, lock_outer_r=35, height=10, disc_height=4, incision_diameter=6, screw_r=20) {
    translate([0,0,disc_height]) inner_ring(inner_diameter=lock_inner_r, outer_diameter=lock_outer_r, height=height, incision_count=6, incision_diameter=incision_diameter);
    difference() {
        cylinder(r=outer_r,h=disc_height);
        rotate([0, 180, 0]) bearing_base_screws(r=screw_r, screw_d=5, z_incision=-3);
    }
}

h1=14;
h2=15;
disc_height=4;

pitch=3.0;
spacing=0.75;
inner_thickness=4;
outer_thickness=10;
outer_incision=outer_thickness-2;
incision_diameter=6;
under_bearing_base_hight=disc_height*2;

r0=45;
r1=r0+pitch;
r2=r1+outer_thickness-inner_thickness;
r3=r2+spacing;
r4=r3+inner_thickness;
r5=r4+spacing;
r6=r5+outer_thickness;

screw_r = r6*0.35 /* bearing base */ * 0.75;

translate([-10,130,0])
threaded_nut_with_holds(pitch=pitch, inner_diameter=r1, outer_diameter=r2, height=h1);

translate([145,0,0])
rotating_lock_base(
pitch=pitch,
inner_radius=r0,
inner_wall_radius=r5,
outer_radius=r6,
thread_height=h1,
wall_height=h2,
disc_height=disc_height,
incision_depth=outer_incision,
incision_diameter=incision_diameter,
screw_r=screw_r);

translate([130,150,0])
under_bearing_base(
smaller_radius=r6,
larger_radius=r6+under_bearing_base_hight,
height=under_bearing_base_hight,
screw_r=screw_r);

translate([-150,0,0])
rotating_lock_top(
outer_r=r6,
lock_inner_r=r3,
lock_outer_r=r4,
height=h2,
disc_height=disc_height,
incision_diameter=incision_diameter,
screw_r=screw_r);

translate([-250,150,0]) {
    cup(disc_height=disc_height, screw_r=screw_r);
}









