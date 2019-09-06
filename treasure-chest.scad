include <shapes-library.scad>

maze_r=12;
maze_wall_thickness=5;
hold_h=5;
hold_ball_r=2;
hold_ball_cnt=15;
h=80 - 2*hold_h;
spacing=0.5;


sleve_inner_r = maze_r + spacing;
sleve_outer_r = sleve_inner_r + 3;


module cutter(a=5,w=50,h=100) { 
    render() 
    intersection() { 
        rotate([0,0,-a/2]) translate([0,0,-h/2]) cube([w,50,h]); 
        rotate([0,0,a/2]) translate([0,-50,-h/2]) cube([w,50,h]); 
    } 
} 


module ely_pattern(a=0, w=70) {
    translate([w-1.6,20 + a*PI/180*w,0]) mirror([0,0,1]) rotate([180,0,0]) rotate([0,-90,0]) scale([0.17/2, 0.17/2, 0.05/2])
    surface(file = "ely_logo_black_low_res2.png", invert=true, center=true);
}
//ely_pattern(a=0, w=maze_r);

module cylinder_pattern(w=10, h=20) {
    step=16;
    for( i=[0:step:360+2*step] ) { 
        rotate([0,0,i]) 
        intersection() { 
            ely_pattern(a=-i, w=w); 
            cutter(step,w+20,h+20); 
        } 
    } 
}

module cutout(w=10, th=5, h=20) {
    cylinder_pattern(w=w, h=h);
    cylinder(r=w-th,h=h+0.04,center=true, $fn=60); 
}

$fn=200;

module maze(w=10, th=5, h=20) {
    difference() {
        cylinder(r=w,h=h,center=true, $fn=60); 
        cutout(w=w, th=th, h=h);
    }
}

module maze_assembly(
w=10,
th=5,
h=20,
hold_r=20,
hold_h=5,
hold_ball_r=3,
hold_ball_cnt=20
) {
    translate([0,0,-1]) // translate in order to allow sleve to lock fully
    maze(w=maze_r, th=maze_wall_thickness, h=h);
    translate([0,0,-h/2-hold_h+0.05]) {
        cylinder(r=hold_r, h=hold_h, $fn=60);
        lineup_on_circle(count=hold_ball_cnt, translate_x=hold_r-hold_ball_r/2, translate_z=hold_h/2) {
            sphere(r=hold_ball_r);
        }
    }
    
}

//maze_assembly(w=maze_r, th=maze_wall_thickness, h=h, hold_r=sleve_outer_r, hold_h=hold_h, hold_ball_r=hold_ball_r, hold_ball_cnt=hold_ball_cnt);

module sleve(
sleve_outer_r=10,
sleve_inner_r=5,
sleve_h=10,
hold_h=5,
hold_ball_r=3,
pin_h=1.5,
pin_r=0.8,
) {
    difference() {
        union() {
    hollow_cylinder(outer_diameter=sleve_outer_r, inner_diameter=sleve_inner_r, height=sleve_h, $fn=60);
    
    translate([0,0,-hold_h+0.05]) {
        cylinder(r=sleve_outer_r, h=hold_h,  $fn=60);
        lineup_on_circle(count=hold_ball_cnt, translate_x=sleve_outer_r-hold_ball_r/2, translate_z=hold_h/2) {
            sphere(r=hold_ball_r);
        }
    }
}
    
    /*
    end_ball_r = pin_r * 0.2;
    translate([sleve_inner_r+0.02,0,h/2+20]) rotate([180,90,0]) {
        cylinder(r1=pin_r, r2=end_ball_r, h=pin_h - end_ball_r);
        translate([0,0,pin_h-end_ball_r]) sphere(r=end_ball_r);
    }*/
    translate([sleve_outer_r-1,0,h/2+20]) rotate([180,90,0]) {
        translate([0,0,0]) cylinder(d=2.5, h=10);
        translate([0,0,-10]) cylinder(d=7, h=10);
    }
}

}



translate([50,0,-h/2])
sleve(sleve_outer_r=sleve_outer_r, sleve_inner_r=sleve_inner_r, sleve_h=h, hold_h=hold_h, hold_ball_r=hold_ball_r);










