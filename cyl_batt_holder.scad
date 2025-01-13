/**
 * @file cyl_batt_holder.scad
 * @brief A script to generate a battery holder for arrays of cylindrical battery cells
 * @author Cameron K. Brooks
 * @copyright 2025
 *
 * This is inspired by "Parametric 18650 battery grid" written by delboy711: https://www.thingiverse.com/thing:3026658
 * This script is a more modular and overall vastly improved version of the 18650 battery holder script
 *
 */

// uses the shape_trapezium.scad module from dotSCAD
use <dotSCAD/src/shape_trapezium.scad> // from dotSCAD: https://github.com/JustinSDK/dotSCAD

// ---------------------------------
// Global Parameters
// ---------------------------------
$fn = $preview ? 32 : 128;  // number of fragments for circles, affects render time
zFite = $preview ? 0.1 : 0; // z-fighting avoidance for preview

// Module to create a single cell
module cell(cell_diameter, height, thickness, connector_depth, tab_radius, tab_height, cell_tolerance, conn_tolerance,
            tabs = true, tie_slot = false)
{
    // base_width = cell_diameter + thickness * 2;
    base_width = cell_diameter + thickness;
    trap_width = base_width * 2 / 3; // Width of the trapezoid
    trapezium_major = cell_diameter - thickness;
    conn_shift = (base_width + connector_depth) / 2;

    difference()
    {
        union()
        {
            // difference()
            {
                union()
                {
                    // main body
                    translate([ 0, 0, height / 2 ]) cube([ base_width, base_width, height ], center = true);

                    // tabs to hold the battery
                    if (tabs)
                        for (rotation = [45:90:325])
                            rotate([ 0, 0, rotation ]) translate([ 0, cell_diameter / 2, 0 ])
                            {
                                translate([ 1, 0, height ]) cylinder(r = tab_radius, h = tab_height, $fn = 16);
                            }
                }
                for (i = [0:1:3])
                    translate([ 0, 0, height / 2 ]) cube([ base_width, base_width, height ], center = true);
            }

            // Connectors
            // Generate the connectors between cells

            translate([ 0, conn_shift, 0 ]) conns(base = base_width, width = trapezium_major, depth = connector_depth,
                                                  height = height, type = "male");

            rotate([ 0, 0, -90 ]) translate([ 0, conn_shift, 0 ]) conns(
                base = base_width, width = trapezium_major, depth = connector_depth, height = height, type = "male");

            rotate([ 0, 0, 90 ]) translate([ 0, conn_shift, 0 ])
                conns(base = base_width, width = trapezium_major, depth = connector_depth, height = height,
                      tolerance = conn_tolerance, type = "female");

            rotate([ 0, 0, 180 ]) translate([ 0, conn_shift, 0 ])
                conns(base = base_width, width = trapezium_major, depth = connector_depth, height = height,
                      tolerance = conn_tolerance, type = "female");
        }
        // Main body hole for the battery cell
        translate([ 0, 0, -zFite / 2 ])
            cylinder(r = cell_diameter / 2 + cell_tolerance / 2, h = height + zFite, $fn = 64);
    }
}

module conns(base, width, depth, height, tolerance = 0, type = "male")
{
    if (type == "female")
    {

        difference()
        {
            translate([ 0, -0, height / 2 ]) cube([ base, depth, height ], center = true);
            translate([ 0, 0, -zFite / 2 ]) linear_extrude(height + zFite) polygon(
                shape_trapezium([ width + tolerance, width - depth + tolerance ], h = depth + zFite, corner_r = 0));
        }
    }
    else
    {
        translate([ 0, 0, -zFite / 2 ]) linear_extrude(height + zFite)
            polygon(shape_trapezium([ width - depth - tolerance, width - tolerance ], h = depth + zFite, corner_r = 0));
    }
}

// Main configuration module
module batteryHolderConfig(cells_x, cells_y, width, tolerance = 0)
{
    for (i = [0:1:cells_x])
        for (j = [0:1:cells_y])
            // Generate the grid of cells and connectors
            translate([ width * i, width * j + tolerance / 2 * j, 0 ]) children();
}