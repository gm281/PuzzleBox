// TODOs
// * set the diameter of the base pads to match the silicon pads
// * verify holders for the rotation
// * verify hex hole in the overall base
// * verify cup


include </Users/gmilos/Library/CloudStorage/iCloudDrive/Jasiu/bolts_nuts_threaded_rods_-_OpenSCAD_library_Threading/files/Threading.scad>
include </Users/gmilos/Library/CloudStorage/iCloudDrive/Jasiu/Gear_Bearing/bearing.scad>
include </Users/gmilos/Library/CloudStorage/iCloudDrive/Jasiu/Parametric_Snap_Pins/pin2.scad>
include <shapes-library.scad>

showexample = 0;

$fn=60;

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


module outer_ring(inner_diameter=100, outer_diameter=110, height=15, incision_count=6, incision_depth=6, incision_diameter=6, rotation_lock_r=3, spacing=0.5) {
    difference() {
        hollow_cylinder(outer_diameter=outer_diameter, inner_diameter=inner_diameter, height=height);
           
        lineup_on_circle(count=incision_count, translate_x=inner_diameter + incision_depth/2-1, translate_z=height/2){
        rotate([0,90,0]) 
            cylinder(r=incision_diameter/2,h=incision_depth+2,center=true);
        }
        rotation_lock_count=incision_count/2;
        lineup_on_circle(count=rotation_lock_count, fractional_offset=0.25, translate_x=inner_diameter+spacing, translate_z=0.05){
            cylinder(r=rotation_lock_r, h=height+0.1);
        }
    }
}

module inner_ring(inner_diameter=80, outer_diameter=90, height=15, incision_count=6, incision_diameter=6, rotation_lock_r=3, spacing=1.5) {
    
    outer_ring(inner_diameter=inner_diameter, outer_diameter=outer_diameter, height=height, incision_count=incision_count, incision_depth=outer_diameter-inner_diameter+1, incision_diameter=
    incision_diameter, rotation_lock_r=0);
    
    rotation_lock_count=incision_count/2;
    lineup_on_circle(count=rotation_lock_count, fractional_offset=0.25, translate_x=outer_diameter, translate_z=height-rotation_lock_r){
        sphere(r=rotation_lock_r-spacing/2);
    }

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
                
        indentation_d=20;
        indentation_de=5;
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
incision_diameter=6,
incision_count=6,
rotation_lock_r=3,
spacing=0.5) {
    translate([0,0,disc_height]) thread(pitch=pitch, radius=inner_radius+pitch, height=thread_height, male=true);
    
    translate([0,0,disc_height]) outer_ring(inner_diameter=inner_wall_radius, outer_diameter=outer_radius, height=wall_height, incision_count=incision_count, incision_depth=incision_depth, incision_diameter=incision_diameter, rotation_lock_r=rotation_lock_r, spacing=spacing);
    
    hollow_cylinder(outer_diameter=outer_radius, inner_diameter=inner_radius, height=disc_height);
}

module _rotating_lock_base(
pitch=3.0,
inner_radius=20.0,
inner_wall_radius=35.0,
outer_radius=40.0,
thread_height=12,
wall_height=14,
disc_height=3,
incision_depth=8,
incision_diameter=6,
incision_count=6,
stem_height=40,
above_bearing_clearence=6,
bearing_thickness=15,
screw_r=40,
rotation_lock_r=3,
spacing=0.5,
hex_width=8.3)
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
incision_diameter=incision_diameter,
incision_count=incision_count,
rotation_lock_r=rotation_lock_r,
spacing=spacing);
    inner_cylinder_thickness = 3;
    hollow_cylinder(outer_diameter=outer_radius, inner_diameter=inner_wall_radius, height=stem_height);

    translate([0,0,bearing_thickness+above_bearing_clearence+disc_height])
    hollow_cylinder(outer_diameter=inner_radius + inner_cylinder_thickness, inner_diameter=inner_radius, height=stem_height-bearing_thickness-above_bearing_clearence-disc_height);

    translate([0,0,bearing_thickness+above_bearing_clearence])
    cylinder(r=outer_radius, h=disc_height);
    
    difference() {
        bearing(diameter=2*inner_wall_radius, thickness=bearing_thickness, hex_width=hex_width, tolerance=0.52);
        bearing_base_screws(r=screw_r, screw_d=3, z_incision=0);
    }
/*    
    difference() {
         bearing(diameter=2*inner_wall_radius, thickness=bearing_thickness, hex_width=hex_width, tolerance=0.52);
        bearing_base_screws(r=screw_r, screw_d=3, z_incision=0);
    }
                        
    hold_h=8;
    hold_cnt=2;
    for (i = [0 : 360/hold_cnt : 360-1]) {
        rotate([0,0,i])
        translate([25+62-20,hold_h/2,7])
        rotate([0,0,0])
        rotate([90,0,0])
        eliptical_hold(r1=10, r2=16, h=hold_h);
    }
    */
}

module good_pinhole(length=14) {
    sc = length / 14;
    scale([sc,sc,sc])
    pinhole(r=3.5,l=14,nub=0.5,fixed=1,fins=1);
}

module good_pinpeg(length=14) {
    sc = length / 14;
    preload=0.1;
    scale([sc,sc,sc])   
    pinpeg(r=3.5,l=14,d=2.5-preload,nub=0.5,t=1.8,space=0.25);
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
incision_count=6,
stem_height=40,
above_bearing_clearence=6,
bearing_thickness=15,
screw_r=40,
rotation_lock_r=3,
spacing=0.5,
hex_width=8.3,
holder_hole_l=7,
holder_hole_spacing=15)
{
    //for printing only
    //intersection() {
    //union() {
        
    difference() {
        hole_z_translation = stem_height-1;
        union() {
        _rotating_lock_base(
pitch=pitch,
inner_radius=inner_radius,
inner_wall_radius=inner_wall_radius,
outer_radius=outer_radius,
thread_height=thread_height,
wall_height=wall_height,
disc_height=disc_height,
incision_depth=incision_depth,
incision_diameter=incision_diameter,
incision_count=incision_count,
stem_height=stem_height,
above_bearing_clearence=above_bearing_clearence,
bearing_thickness=bearing_thickness,
screw_r=screw_r,
rotation_lock_r=rotation_lock_r,
spacing=spacing,
hex_width=hex_width);
            // Cylinders to support the pinholes
            lineup_on_circle(count=2, translate_x=outer_radius, translate_z=hole_z_translation) {
                union() {
                    surface_indent=3;
                    cyl_h = outer_radius - inner_radius - surface_indent;
                    translate([-surface_indent,0,0]) rotate([0,-90,0]) cylinder(r=holder_hole_l*0.3, h=cyl_h);
                    translate([-surface_indent,0,-holder_hole_spacing]) rotate([0,-90,0]) cylinder(r=holder_hole_l*0.3, h=cyl_h);
                }
            }
        }
        lineup_on_circle(count=2, translate_x=outer_radius, translate_z=hole_z_translation) {
            union() {
                rotate([0,-90,0]) good_pinhole(length=holder_hole_l);
                translate([0,0,-holder_hole_spacing]) rotate([0,-90,0]) good_pinhole(length=holder_hole_l);
            }
        }
    }
    
    // For printing only
    //translate([50,0,12.5])
    //rotate([0,0,0])
    //cube(size=[20,60,17], center=true);
    //}
    //translate([100,0,32.5])
    //rotate([0,0,45])
    //cube(size=[100,100,60], center=true);
    //}
}

module rotating_lock_base_holder(
cylinder_r=50,
holder_hole_l=7,
holder_hole_spacing=15
) {
    hold_h=6;
    hold_l = 28;
    screw_l= hold_l * 0.9;
    
    
    intersection() {
        difference() {
            union() {
                translate([0,hold_h/2,5]) rotate([90,0,0]) eliptical_hold(r1=16, r2=hold_l/2, h=hold_h);
        
                translate([-screw_l/2,0,3])
                intersection() {
                    screw_ind(screw_th=0.1, screw_l=screw_l);
                    translate([-screw_l*5, -screw_l*5, 0]) cube(size=[screw_l*10, screw_l*10, screw_l*10]);
                }
            }
            cylinder_offset = 90;
            translate([0,0,cylinder_offset]) {
                translate([-100,0,0]) 
                rotate([0,90,0]) cylinder(r=cylinder_r, h=200);

                translate([holder_hole_spacing/2,0,-cylinder_r+0.05]) rotate([0,180,0]) good_pinhole(length=holder_hole_l);
            
                translate([-holder_hole_spacing/2,0,-cylinder_r+0.05])
                rotate([0,180,0]) good_pinhole(length=holder_hole_l);
            }
        }
        l = hold_l * 1.14;
        translate([-l/2,-50,-50]) cube(size=[l, 100, 100]);
    }
    /*
    removal_space=0.15/2;
    translate([-holder_hole_spacing/2,0,cylinder_offset-cylinder_r+removal_space]) cylinder(r=2.2+0.5, h=1);
    translate([holder_hole_spacing/2,0,cylinder_offset-cylinder_r+removal_space]) cylinder(r=2.2+0.5, h=1);
    */
}

module bearing_base_screws(r=30, screw_d=6, z_incision=2.4) {
    screw_count=6;
    lineup_on_circle(count=screw_count, translate_x=r, translate_z=z_incision){
        rotate([0, 180, 0]) screw_ind(screw_th=screw_d, screw_l=0);
    }
}

module under_bearing_base(
smaller_radius=37,
larger_radius=40,
height=3,
bearing_base_height=3,
screw_r=40,
hex_width=15) {
    bearing_base_r = smaller_radius*0.35;
    difference() {
        union() {
            sphere_slice(smaller_radius=smaller_radius, larger_radius=larger_radius, height=height);
            translate([0,0,height]) cylinder(r=bearing_base_r, h=bearing_base_height);
        }
        union() {
            translate([0,0,-0.05]) cylinder(r=hex_width/sqrt(3), h=bearing_base_height+height+0.1, $fn=6);
            bearing_base_screws(r=screw_r, screw_d=4, z_incision=1.4);
            
            rubber_pad_distance=larger_radius * 0.80;
            rubber_pad_r=6.6;
            rubber_pad_indent=2.3;
            rubber_pad_count=6;
            lineup_on_circle(count=rubber_pad_count, translate_x=rubber_pad_distance, translate_z=-0.05){
                cylinder(r=rubber_pad_r, h=rubber_pad_indent);
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
            
            lineup_on_circle(count=screw_count, translate_x=screw_r, translate_z=z_incision){
                rotate([0, 180, 0]) screw_ind(screw_th=3.3, screw_l=0);
            }
        }
    }
}
module cup(disc_height=4, screw_r=20, hex_width=8.3) {
    sc=6;
    th_h=10;
    thread_d=30;
    pitch=3;
    hold_cnt=3;
    cup_thread_screw_r=15;
/*    
    // Cup
    difference() {
        union() {
            scale([sc,sc,sc]) rotate([90,0,0]) import("cup.stl");
            translate([0,0,0]) cylinder(d=73, h=4.05);
            translate([0,0,4]) cylinder(d=67, h=4.05);
            translate([0,0,8]) cylinder(d=57, h=2.05);
            translate([0,0,10]) cylinder(d=48, h=2.05);
            translate([0,0,12]) cylinder(d=39, h=2.05);
            translate([0,0,14]) cylinder(d=33, h=2.05);
            translate([0,0,16]) cylinder(d=30, h=2.05);
            translate([0,0,18]) cylinder(d=28, h=2.05);
        }
        union() {
            // Hex key holder
            translate([0,
            4.2, // center of mass offset
            27 // level of the bed
            - 10 // incision
            ]) cylinder(r=hex_width/sqrt(3),h=15,$fn=6);
            // Screw holes
            intersection() {
                bearing_base_screws(r=screw_r, screw_d=3, z_incision=-2);
                translate([0,0,-12]) cube(size=[50,50,50], center=true);
            }
        }
    }

    // Thread in the cup
    translate([0,0,165 - th_h])
    mirror([1,0,0])
    threaded_nut(pitch=pitch, inner_diameter=thread_d, outer_diameter=33, height=th_h);
*/    
    // Lid top with holds
    translate([100,0,0]) {
        difference() {
            union() {
                sphere_slice(smaller_radius=10, larger_radius=38.5, height=6);

                difference() {
                    hold_h=7;
                    union() {
                        lineup_on_circle(count=hold_cnt, translate_x=-20, translate_z=3) {
                            translate([0,hold_h/2,0])
                            rotate([0,-6,0])
                            rotate([90,0,0])
                            eliptical_hold(r1=16, r2=10, h=hold_h, overlap_h_fraction=0.22);
                        }
                    }
                    translate([-50,-50,-100+0.05]) cube([100,100,100]);
                }
            }
        
            union() {
                screw_hole_indent=10;
                lineup_on_circle(count=hold_cnt, fractional_offset=0.5, translate_x=cup_thread_screw_r, translate_z=-0.05) {
                    cylinder(d=3,h=screw_hole_indent);
                }
            }
        }
    }
/*
    // Lid with thread
    translate([50,80,th_h])
    rotate([0,180,0])
    cup_thread(pitch=pitch, radius=thread_d, height=th_h, screw_count=hold_cnt, screw_r=cup_thread_screw_r);
*/    
}

module rotating_lock_top(outer_r=40, lock_inner_r=30, lock_outer_r=35, height=10, disc_height=4, incision_diameter=6, incision_count=8, screw_r=20, rotation_lock_r=3, spacing=1.5) {
    
    translate([0,0,disc_height]) inner_ring(inner_diameter=lock_inner_r, outer_diameter=lock_outer_r, height=height, incision_count=incision_count, incision_diameter=incision_diameter, rotation_lock_r=rotation_lock_r, spacing=spacing);
    
    difference() {
        cylinder(r=outer_r,h=disc_height);
        rotate([0, 180, 0]) bearing_base_screws(r=screw_r, screw_d=4, z_incision=-3);
    }
}

h1=14;
h2=15;
disc_height=4;

pitch=3.0;
spacing=0.6;
inner_thickness=4;
outer_thickness=10;
outer_incision=outer_thickness-2;
incision_diameter=4.8;
incision_count=16;
under_bearing_base_hight=disc_height*2;
stem_height=40;
rotation_lock_r=2;
hex_width=8.3;
holder_l=15;
holder_spacing=h1;

//r0=20;
r0=45;
r1=r0+pitch;
r2=r1+outer_thickness-inner_thickness;
r3=r2+spacing;
r4=r3+inner_thickness;
r5=r4+spacing;
r6=r5+outer_thickness;

screw_r = r6*0.35 /* bearing base */ * 0.75;

/*
translate([150,300,0])
under_bearing_base(
smaller_radius=r6,
larger_radius=r6+under_bearing_base_hight,
height=under_bearing_base_hight,
screw_r=screw_r,
hex_width=hex_width+0.05);
*/

/*
translate([145,0,0])
//translate([85,0,-stem_height])
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
incision_count=incision_count,
screw_r=screw_r,
stem_height=stem_height,
rotation_lock_r=rotation_lock_r,
spacing=spacing/2,
hex_width=hex_width,
holder_hole_l=holder_l,
holder_hole_spacing=holder_spacing);
*/

translate([-60,0,0])
//translate([0,0,0])
rotating_lock_top(
outer_r=r6,
lock_inner_r=r3,
lock_outer_r=r4,
height=h2,
disc_height=disc_height,
incision_diameter=incision_diameter,
incision_count=incision_count,
screw_r=screw_r,
rotation_lock_r=rotation_lock_r,
spacing=spacing);

/*
rotating_lock_base_holder(
cylinder_r=r6,
holder_hole_l=holder_l,
holder_hole_spacing=holder_spacing);
*/

/*
translate([-40,0,0])
good_pinpeg(length=holder_l);
translate([-50,0,0])
good_pinpeg(length=holder_l);
*/

/*
translate([200,150,0])
//translate([0,90,0])
threaded_nut_with_holds(
pitch=pitch,
inner_diameter=r1,
outer_diameter=r2,
height=h1);
*/

/*
translate([-50,150,0])
cup(disc_height=disc_height, screw_r=screw_r, hex_width=hex_width);
*/












