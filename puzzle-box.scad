include </Users/gmilos/Library/CloudStorage/iCloudDrive/Jasiu/bolts_nuts_threaded_rods_-_OpenSCAD_library_Threading/files/Threading.scad>
include </Users/gmilos/Library/CloudStorage/iCloudDrive/Jasiu/Gear_Bearing/bearing.scad>

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

module hollow_cylinder(outer_diameter=100, inner_diameter=90, height=10.0) {
    translate([0,0,height/2]) difference() {
        cylinder(r=outer_diameter,h=height,center=true);
        cylinder(r=inner_diameter,h=height*1.1,center=true);
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
    difference() {
        union() {
            thread(pitch=pitch, radius=inner_diameter, height=height, male=false);
            hollow_cylinder(outer_diameter=outer_diameter, inner_diameter=inner_diameter+pitch/2-0.1, height=height);
        }
        
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
stem_height=40)
{
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
    
}


h1=14;
h2=15;
disc_height=3;

pitch=3.0;
spacing=0.5;
inner_thickness=4;
outer_thickness=8;
outer_incision=outer_thickness-2;
incision_diameter=6;

r0=27;
r1=r0+pitch;
r2=r1+outer_thickness-inner_thickness;
r3=r2+spacing;
r4=r3+inner_thickness;
r5=r4+spacing;
r6=r5+outer_thickness;


translate([60,100,0])
threaded_nut(pitch=pitch, inner_diameter=r1, outer_diameter=r2, height=h1);

translate([120,0,0])
rotating_lock_base(
pitch=pitch,
inner_radius=r0,
inner_wall_radius=r5,
outer_radius=r6,
thread_height=h1,
wall_height=h2,
disc_height=disc_height,
incision_depth=outer_incision,
incision_diameter=incision_diameter);


translate([0,0,disc_height])
union() {
    inner_ring(inner_diameter=r3, outer_diameter=r4, height=h2, incision_count=6, incision_diameter=incision_diameter);
    translate([0,0,-disc_height/2]) cylinder(r=r6,h=disc_height,center=true);
}



translate([60,-80,0]) bearing();






