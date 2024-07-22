// Copyright (c) 2024 Steve Grace (s.r.grace[at]gmail.com) (or [Your Organization], if applicable)

// This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
// To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/4.0/deed.en or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.


include <BOSL2/std.scad>
include <BOSL2/screws.scad>

// Change this value to at least 64 if you want more segments
// Or you can load this in FreeCAD and have it render a perfect cylinder
$fn=24;

screw_used = screw_info("M8,16", drive="hex", head="hex");
echo(screw_used);

// Test fit an m8 screw
// up(10) screw(struct_val(screw_used, "name"), length=struct_val(screw_used,"length"), head=struct_val(screw_used,"head"), anchor=TOP);

// Modify these at your own risk. Some changes to these values will break the screw hole (hard-coded)
outer_radius = 46;
inner_radius = 42;
cup_left_pos = 38;
cup_right_pos = 38;
cup_height = 90;
rounding_val = 3;
base_thickness = 10;

// Comment this line out to see half of the model
// back_half(300)
difference() {

    // Create cube to hold both cylinders together
    union() {
        diff() {
            up(cup_height/2) cube([cup_left_pos+cup_right_pos,cup_left_pos+cup_right_pos,cup_height], center = true) {
                let(p = $parent_size*2) {
                    edge_mask(TOP)
                        rounding_edge_mask(l=p.z, r=rounding_val);
                }
            }
        }

        // Right cylinder with a radius of 46mm
        // difference() {
            translate([cup_right_pos,0,0]) cylinder(cup_height,outer_radius,outer_radius);
            // up(cup_height) right(cup_right_pos) rounding_cylinder_mask(r=outer_radius, rounding=rounding_val);
        // }
        
        // Left cylinder with a radius of 46mm
        // difference() {
            translate([-1*cup_left_pos,0,0]) cylinder(cup_height,outer_radius,outer_radius);
            // up(cup_height) left(cup_left_pos) rounding_cylinder_mask(r=outer_radius, rounding=rounding_val);
        // }
    }

    // Removes a cylinder size of 42mm from the center. This leaves a 4mm border
    translate([cup_right_pos,0,base_thickness]) cylinder(cup_height,inner_radius,inner_radius);
    up(cup_height) right(cup_right_pos) rounding_hole_mask(r=inner_radius, rounding=rounding_val);
    
    // Removes a cylinder size of 42mm from the center. This leaves a 4mm border
    translate([-1* cup_left_pos,0,base_thickness]) cylinder(cup_height,inner_radius,inner_radius);
    up(cup_height) left(cup_left_pos) rounding_hole_mask(r=inner_radius, rounding=rounding_val);


    // Where the cylinders meet has a cube that has a 8mm hole and a nut trap for flush m8x16 hex screw
    // These values have no corresponding variable due to how the diff matched with the rounding
    // If someone wants to remix this scad to fix that, it would be great and I'll update!
    up(50.5) cuboid([struct_val(screw_used, "head_size",8),46.5,81], rounding=-4, edges=[TOP+FRONT, TOP+BACK], trimcorners=true);

    // Comment these two lines if you want a screw hole with counterbore instead
    // This is used if you want to use the cup holder has a screw head for mounting
    translate([0,0,-1]) cylinder(base_thickness,struct_val(screw_used, "diameter",8)/2,struct_val(screw_used, "diameter",8)/2);
    up(base_thickness/2) nut_trap_inline(base_thickness, struct_val(screw_used, "name"));

    // Uncomment this if you want a screw_hole with a counterbore instead of a nut trap
    // screw_hole(struct_val(screw_used, "name"), length=struct_val(screw_used, "length"), counterbore=5,head="hex");
}

    
